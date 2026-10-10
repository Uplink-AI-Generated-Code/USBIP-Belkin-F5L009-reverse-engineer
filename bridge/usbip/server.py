"""
USB/IP server (TCP 3240) exporting the Belkin hub's USB devices over SXUPTP.

Run it, then from a Linux client:
    usbip list  -r <this-host>
    usbip attach -r <this-host> -b 1-1

One TCP connection = one imported device. OP_REQ_DEVLIST is answered from the
hub's device list; OP_REQ_IMPORT attaches the device over SXUPTP, reads its
descriptors, and then relays USBIP_CMD_SUBMIT/UNLINK as USB transfers.
"""
from __future__ import annotations

import argparse
import socket
import socketserver
import threading
import time

from ..sxuptp.client import SxuptpClient
from . import protocol as u
from .backend import Device


class Hub:
    """Inventory of exportable devices, discovered once at startup."""

    def __init__(self, host: str, client_ip: str):
        self.host = host
        self.client_ip = client_ip
        self.attach_lock = threading.Lock()

        # Two persistent sockets for the server's whole life (sharing them is the
        # only arrangement that attaches reliably — see sxuptp.client.attach):
        #   _grant : bound (client_ip, 19540) — receives the OPEN_WAIT grant.
        #   _session: ephemeral, connected to the hub — issues GET USB_DEVICE_LIST
        #             AND every CONNECT, so they share one source port (the hub
        #             keys the session to it).
        self._grant = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self._grant.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self._grant.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
        self._grant.bind((client_ip, 19540))
        self._session = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self._session.bind((client_ip, 0))
        self._session.connect((host, 19540))
        self._session.settimeout(2.0)

        devs = SxuptpClient.discover(target=host)
        if not devs:
            raise RuntimeError(f"no SXUPTP hub answered discovery at {host}")
        self.mac = bytes(int(x, 16) for x in devs[0]["mac"].split(":"))
        time.sleep(1.0)   # the hub drops a device-list query issued too soon after discovery
        listed = self._list_on_session(retries=4)
        self.devices: dict[str, Device] = {}
        for i, d in enumerate(listed):
            busid = f"1-{i + 1}"
            self.devices[busid] = Device(host, client_ip, self.mac, d["port"],
                                         busid, busnum=1, devnum=i + 1,
                                         vid=d.get("vid", 0), pid=d.get("pid", 0),
                                         udp=self._session, bc=self._grant,
                                         lock=self.attach_lock)
        self.names = {busid: d["device"] for busid, d in zip(self.devices, listed)}

    def exclude_for(self, busid: str) -> tuple[int, ...]:
        """devIds already bound to OTHER busids that share this one's VID:PID, so
        two identical devices (e.g. the two keyboards) resolve to distinct handles."""
        me = self.devices[busid]
        return tuple(d.resolved_dev_id for b, d in self.devices.items()
                     if b != busid and d.resolved_dev_id is not None
                     and d.vid == me.vid and d.pid == me.pid)

    def _list_on_session(self, retries: int = 4) -> list:
        """GET USB_DEVICE_LIST on the shared session socket (same source port the
        CONNECTs use)."""
        from ..sxuptp import protocol as sx
        req = b"\x00\x01\x00\x01GET USB_DEVICE_LIST" + b"\0" * 0x4F + b"\x02\x00"
        for _ in range(max(1, retries)):
            try:
                self._session.send(req)
                data = self._session.recv(8192)
                devs = sx.parse_device_list(data)
                if devs:
                    return devs
            except socket.timeout:
                pass
        return []

    def devlist(self) -> list[u.UsbipDevice]:
        """Advertisement (no attach): busids + VID:PID from GET USB_DEVICE_LIST.
        Full descriptor fields are filled by IMPORT. `usbip attach -b <busid>`
        is the real path."""
        out = []
        for busid, dev in self.devices.items():
            out.append(u.UsbipDevice(busid=busid, busnum=dev.busnum,
                                     devnum=dev.devnum, id_vendor=dev.vid,
                                     id_product=dev.pid, b_num_interfaces=1,
                                     interfaces=[(0, 0, 0)]))
        return out


class Handler(socketserver.BaseRequestHandler):
    def _recvall(self, n: int) -> bytes:
        buf = b""
        while len(buf) < n:
            chunk = self.request.recv(n - len(buf))
            if not chunk:
                raise ConnectionError("client closed")
            buf += chunk
        return buf

    def handle(self) -> None:
        hub: Hub = self.server.hub          # type: ignore[attr-defined]
        try:
            hdr = self._recvall(8)
        except ConnectionError:
            return
        _ver, opcode, _st = u.parse_op_header(hdr)

        if opcode == u.OP_REQ_DEVLIST:
            self.request.sendall(u.pack_devlist_reply(hub.devlist()))
            return

        if opcode != u.OP_REQ_IMPORT:
            return
        busid = u.parse_import_request_busid(hdr + self._recvall(32))
        dev = hub.devices.get(busid)
        if dev is None:
            self.request.sendall(u.pack_import_reply(None))
            return
        try:
            info = dev.attach(exclude=hub.exclude_for(busid))
        except Exception as e:
            print(f"[usbip] import {busid} failed: {e}")
            self.request.sendall(u.pack_import_reply(None))
            return
        self.request.sendall(u.pack_import_reply(info))
        print(f"[usbip] imported {busid} ({hub.names.get(busid)}) "
              f"{info.id_vendor:04x}:{info.id_product:04x}")
        try:
            self._urb_loop(dev)
        finally:
            dev.detach()
            print(f"[usbip] detached {busid}")

    def _urb_loop(self, dev: Device) -> None:
        while True:
            try:
                hdr = self._recvall(u.CMD_HDR_LEN)
            except ConnectionError:
                return
            command, cmd = u.parse_command(hdr)
            if command == u.USBIP_CMD_SUBMIT:
                if not cmd.is_in and cmd.transfer_buffer_length:
                    cmd.transfer_buffer = self._recvall(cmd.transfer_buffer_length)
                status, data = dev.submit(cmd)
                self.request.sendall(u.pack_ret_submit(cmd, status, data))
            elif command == u.USBIP_CMD_UNLINK:
                self.request.sendall(u.pack_ret_unlink(cmd, 0))


class Server(socketserver.ThreadingTCPServer):
    allow_reuse_address = True
    daemon_threads = True


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="USB/IP exporter for the Belkin SXUPTP hub")
    ap.add_argument("host", help="the hub's IP (e.g. 192.168.2.3)")
    ap.add_argument("--client-ip", required=True,
                    help="a NON-gateway IP on the hub's subnet to connect from")
    ap.add_argument("--listen", default="0.0.0.0")
    ap.add_argument("--port", type=int, default=3240)
    args = ap.parse_args(argv)

    hub = Hub(args.host, args.client_ip)
    print(f"[usbip] hub {args.host} mac={hub.mac.hex()}; devices:")
    for busid, name in hub.names.items():
        print(f"         {busid}  {name}")
    srv = Server((args.listen, args.port), Handler)
    srv.hub = hub                          # type: ignore[attr-defined]
    print(f"[usbip] listening on {args.listen}:{args.port} "
          f"(usbip attach -r <host> -b 1-1)")
    try:
        srv.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        srv.shutdown()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

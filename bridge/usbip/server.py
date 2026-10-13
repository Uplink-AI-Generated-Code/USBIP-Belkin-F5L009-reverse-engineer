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
import os
import socket
import socketserver
import sys
import threading
import time

from ..sxuptp.client import KeepaliveResponder, SxuptpClient
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
        self._grant = self._session = None
        self.keepalive = KeepaliveResponder(host, client_ip)
        try:
            self._grant = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            self._grant.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            self._grant.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
            self._bind(self._grant, (client_ip, 19540))
            self._session = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            self._bind(self._session, (client_ip, 0))
            self._session.connect((host, 19540))
            self._session.settimeout(2.0)

            # One host-level SXUP_ALC keepalive responder for the whole Hub: the
            # hub runs a SINGLE keepalive stream per host (confirmed: one stream
            # for two attached drives), so this is the sole responder — each
            # device's own SxuptpClient keepalive is disabled under a Hub (backend
            # sets _ka_enabled=False). Answering it is what cures the ~69s
            # data-channel wedge, so failing to bind it is fatal. Disable it
            # deliberately with SXUPTP_NO_KEEPALIVE.
            if os.environ.get("SXUPTP_NO_KEEPALIVE") is None:
                if not self.keepalive.start():
                    raise OSError(f"keepalive responder: {self.keepalive.error}")
            self._discover_devices(host, client_ip)
        except BaseException:
            self.close()
            raise

    @staticmethod
    def _bind(sock: socket.socket, addr: tuple[str, int]) -> None:
        try:
            sock.bind(addr)
        except OSError as e:
            raise OSError(f"cannot bind UDP {addr[0]}:{addr[1]}: {e}") from e

    def _discover_devices(self, host: str, client_ip: str) -> None:
        devs = SxuptpClient.discover(target=host)
        if not devs:
            raise RuntimeError(f"no SXUPTP hub answered discovery at {host}")
        self.mac = bytes(int(x, 16) for x in devs[0]["mac"].split(":"))
        time.sleep(1.0)   # the hub drops a device-list query issued too soon after discovery
        listed = self._list_on_session(retries=4)
        # Group same-VID:PID nodes in list order: a composite device's interfaces
        # are split across consecutive nodes (dev02=if0, dev03=if1). The first node
        # of a group is the primary busid; when it attaches and finds a multi-
        # interface config it claims the others as secondary channels (see below).
        self._claimed: set[str] = set()         # sibling nodes hidden by a composite
        self._claim_lock = threading.Lock()
        sib: dict[tuple[int, int], list[str]] = {}
        for d in listed:
            sib.setdefault((d.get("vid", 0), d.get("pid", 0)), []).append(d["port"])
        self.devices: dict[str, Device] = {}
        for i, d in enumerate(listed):
            busid = f"1-{i + 1}"
            siblings = tuple(sib.get((d.get("vid", 0), d.get("pid", 0)), [d["port"]]))
            self.devices[busid] = Device(host, client_ip, self.mac, d["port"],
                                         busid, busnum=1, devnum=i + 1,
                                         vid=d.get("vid", 0), pid=d.get("pid", 0),
                                         udp=self._session, bc=self._grant,
                                         lock=self.attach_lock,
                                         siblings=siblings, hub=self)
        self.names = {busid: d["device"] for busid, d in zip(self.devices, listed)}
        self._node_busid = {d.node: b for b, d in self.devices.items()}

    @property
    def ka_echoed(self) -> int:
        return self.keepalive.echoed

    def close(self) -> None:
        """Stop the keepalive responder and close the Hub's shared sockets."""
        try:
            self.keepalive.stop()
        except Exception:
            pass
        for s in (getattr(self, "_grant", None), getattr(self, "_session", None)):
            if s is not None:
                try:
                    s.close()
                except OSError:
                    pass
        self._grant = self._session = None

    def claim_node(self, node: str) -> str | None:
        """Mark a node as a composite secondary so its standalone busid refuses.
        Returns None on success, or the busid that already has the node imported
        standalone (then nothing is claimed: a second channel to a node that
        already has one would collide on the hub)."""
        with self._claim_lock:
            busid = self._node_busid.get(node)
            if busid is not None and self.devices[busid].in_use:
                return busid
            self._claimed.add(node)
            return None

    def unclaim_node(self, node: str) -> None:
        with self._claim_lock:
            self._claimed.discard(node)

    def is_claimed(self, node: str) -> bool:
        with self._claim_lock:
            return node in self._claimed

    def reserve(self, dev: Device) -> str | None:
        """Mark `dev` imported. Returns None on success, else why it refuses.
        Checked atomically with claim_node, so a node is never held both as a
        standalone import and as a composite's secondary channel."""
        with self._claim_lock:
            if dev.node in self._claimed:
                return ("secondary channel of a composite device "
                        "(import its primary busid instead)")
            if dev.in_use:
                return "already imported by another client"
            dev.in_use = True
            return None

    def release(self, dev: Device) -> None:
        with self._claim_lock:
            dev.in_use = False

    def detach_all(self) -> None:
        """Disconnect every device's channels (shutdown). Device.detach is a
        no-op for a device that is not attached, so every busid is simply swept:
        an open channel keeps the node's slot reserved until the hub reboots."""
        for dev in self.devices.values():
            try:
                dev.detach()
            except Exception as e:
                print(f"[usbip] detach {dev.busid} at shutdown failed: {e}")

    def exclude_for(self, busid: str) -> tuple[int, ...]:
        """devIds already bound to OTHER busids that share this one's VID:PID, so
        two identical devices (e.g. the two keyboards) resolve to distinct handles.
        Call with attach_lock held (Device.attach does), so a concurrent attach
        cannot resolve the same devId in between."""
        me = self.devices[busid]
        return tuple(d.resolved_dev_id for b, d in self.devices.items()
                     if b != busid and d.resolved_dev_id is not None
                     and d.vid == me.vid and d.pid == me.pid)

    def _list_on_session(self, retries: int = 4) -> list:
        """GET USB_DEVICE_LIST on the shared session socket (same source port the
        CONNECTs use)."""
        from ..sxuptp import protocol as sx
        req = sx.pack_device_list_query()        # vendor-exact full-dump request
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
        is the real path. Nodes claimed as a composite's secondary channel are
        omitted: they are served through their primary busid."""
        out = []
        for busid, dev in self.devices.items():
            if self.is_claimed(dev.node):
                continue
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
        # Refuse a secondary node of a composite (already exported as part of its
        # primary busid) and a busid another client already has imported — a
        # second channel to the same node would collide on the hub.
        why = hub.reserve(dev)
        if why is not None:
            print(f"[usbip] import {busid} refused: {why}")
            self.request.sendall(u.pack_import_reply(None))
            return
        imported = False
        try:
            try:
                info = dev.attach()          # cleans up its own channels on failure
            except Exception as e:
                print(f"[usbip] import {busid} failed: {e}")
                self.request.sendall(u.pack_import_reply(None))
                return
            imported = True
            self.request.sendall(u.pack_import_reply(info))
            print(f"[usbip] imported {busid} ({hub.names.get(busid)}) "
                  f"{info.id_vendor:04x}:{info.id_product:04x}")
            self._urb_loop(dev)
        finally:
            # always disconnect (idempotent), even if the client vanished before
            # the import reply went out: a leaked channel holds the hub slot.
            dev.detach()
            hub.release(dev)
            if imported:
                print(f"[usbip] detached {busid}")

    def _complete_async(self, cmd, status: int, data: bytes) -> None:
        """Complete an async (interrupt/bulk-IN) URB from the mux reader thread.
        Dropped if the URB was already UNLINKed by the kernel — sending a
        RET_SUBMIT for an unlinked seqnum makes the client drop the whole device
        (seen with the FTDI, which unlinks its reads constantly)."""
        with self._send_lock:
            if cmd.seqnum not in self._inflight:
                return
            self._inflight.discard(cmd.seqnum)
            try:
                self.request.sendall(u.pack_ret_submit(cmd, status, data))
            except OSError:
                pass

    def _urb_loop(self, dev: Device) -> None:
        self._send_lock = threading.Lock()
        self._inflight: set[int] = set()        # seqnums of async URBs awaiting completion
        while True:
            try:
                hdr = self._recvall(u.CMD_HDR_LEN)
            except ConnectionError:
                return
            command, cmd = u.parse_command(hdr)
            if command == u.USBIP_CMD_SUBMIT:
                if not cmd.is_in and cmd.transfer_buffer_length:
                    cmd.transfer_buffer = self._recvall(cmd.transfer_buffer_length)
                if dev.is_async(cmd):
                    # completed later, on the mux reader thread, when the reply lands
                    with self._send_lock:
                        self._inflight.add(cmd.seqnum)
                    dev.enqueue_async(cmd, self._complete_async)
                else:
                    status, data = dev.submit(cmd)
                    with self._send_lock:
                        try:
                            self.request.sendall(u.pack_ret_submit(cmd, status, data))
                        except OSError:
                            pass
            elif command == u.USBIP_CMD_UNLINK:
                # Cancel the victim async URB so its (now stale) completion is
                # dropped, then ack the unlink.
                with self._send_lock:
                    self._inflight.discard(cmd.unlink_seqnum)
                    try:
                        self.request.sendall(u.pack_ret_unlink(cmd, 0))
                    except OSError:
                        pass


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

    try:
        hub = Hub(args.host, args.client_ip)
    except (OSError, RuntimeError) as e:     # RuntimeError: no hub answered discovery
        print(f"[usbip] FATAL: not starting: {e}", file=sys.stderr)
        return 1
    print(f"[usbip] hub {args.host} mac={hub.mac.hex()}; devices:")
    for busid, name in hub.names.items():
        print(f"         {busid}  {name}")
    try:
        srv = Server((args.listen, args.port), Handler)
    except OSError as e:
        print(f"[usbip] FATAL: cannot bind TCP {args.listen}:{args.port}: {e}",
              file=sys.stderr)
        hub.close()
        return 1
    srv.hub = hub                          # type: ignore[attr-defined]
    print(f"[usbip] listening on {args.listen}:{args.port} "
          f"(usbip attach -r <host> -b 1-1)")
    try:
        srv.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        srv.shutdown()
        srv.server_close()
        # Handler threads are daemons and die with the process without running
        # their own detach, so release every channel here or the hub keeps
        # those slots reserved until it is rebooted.
        hub.detach_all()
        hub.close()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

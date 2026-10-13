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
from .backend import EPIPE, Device

ECONNRESET = -104   # RET_UNLINK status for a URB cancelled while still pending

# USBIP_TRACE=1: log every URB-phase CMD from the kernel and every RET we send,
# per busid, with a monotonic timestamp and the first data bytes. Diagnostic only.
_TRACE = bool(os.environ.get("USBIP_TRACE"))
_T0 = time.monotonic()


def _trace(busid: str, line: str) -> None:
    os.write(2, f"[trace {time.monotonic() - _T0:9.4f} {busid}] {line}\n".encode())


def _hexhead(data: bytes, n: int = 16) -> str:
    return data[:n].hex() + ("…" if len(data) > n else "")


class _TracingSocket:
    """Wraps the client connection to log each RET_SUBMIT/RET_UNLINK sent."""

    def __init__(self, sock, busid: str):
        self._sock = sock
        self._busid = busid

    def __getattr__(self, name):
        return getattr(self._sock, name)

    def sendall(self, pkt: bytes) -> None:
        if len(pkt) >= u.CMD_HDR_LEN:
            import struct
            command, seq, _devid, direction, ep, status, actual = \
                struct.unpack_from(">IIIIIiI", pkt, 0)
            if command == u.USBIP_RET_SUBMIT:
                _trace(self._busid, f"RET_SUBMIT seq={seq} ep={ep} "
                       f"{'IN ' if direction else 'OUT'} st={status} len={actual} "
                       f"{_hexhead(pkt[u.CMD_HDR_LEN:])}")
            elif command == u.USBIP_RET_UNLINK:
                _trace(self._busid, f"RET_UNLINK seq={seq} st={status}")
        self._sock.sendall(pkt)


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
    _busid = "?"                     # set on import; labels USBIP_TRACE lines

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
            if _TRACE:
                self.request = _TracingSocket(self.request, busid)
                self._busid = busid
            self._urb_loop(dev)
        finally:
            # always disconnect (idempotent), even if the client vanished before
            # the import reply went out: a leaked channel holds the hub slot.
            dev.detach()
            hub.release(dev)
            if imported:
                print(f"[usbip] detached {busid}")

    @staticmethod
    def _ret_submit(cmd, status: int, data) -> bytes:
        """RET_SUBMIT bytes for a completed async URB. An ISO URB's `data` is its
        per-packet result list; a failed one reports every packet as errored."""
        if cmd.iso_packets:
            if status != 0:
                data = [(status, 0, b"")] * len(cmd.iso_packets)
            return u.pack_ret_submit_iso(cmd, cmd.iso_packets, data)
        return u.pack_ret_submit(cmd, status, data)

    def _complete_async(self, cmd, status: int, data) -> None:
        """Complete an async (interrupt/bulk-IN) URB from the mux reader thread.
        Dropped if the URB was already UNLINKed by the kernel — sending a
        RET_SUBMIT for an unlinked seqnum makes the client drop the whole device
        (seen with the FTDI, which unlinks its reads constantly). If an UNLINK
        lost the race to this completion, its RET_UNLINK (status 0, "already
        completed") goes out right after the RET_SUBMIT, in that order."""
        with self._send_lock:
            if self._inflight.pop(cmd.seqnum, None) is None:
                return
            unl = self._unlink_after.pop(cmd.seqnum, None)
            try:
                self.request.sendall(self._ret_submit(cmd, status, data))
                if unl is not None:
                    self.request.sendall(u.pack_ret_unlink(unl, 0))
            except OSError:
                pass

    def _urb_loop(self, dev: Device) -> None:
        self._send_lock = threading.Lock()
        self._inflight: dict[int, u.CmdSubmit] = {}  # async URBs awaiting completion
        self._unlink_after: dict[int, u.CmdUnlink] = {}  # victim seqnum -> its UNLINK
        while True:
            try:
                hdr = self._recvall(u.CMD_HDR_LEN)
                command, cmd = u.parse_command(hdr)
            except ConnectionError:
                return
            except ValueError as e:              # unknown command: stream is unframed
                print(f"[usbip] {e}; closing connection")
                return
            if command == u.USBIP_CMD_SUBMIT:
                try:
                    if not cmd.is_in and cmd.transfer_buffer_length:
                        cmd.transfer_buffer = self._recvall(cmd.transfer_buffer_length)
                    if cmd.iso_desc_len:
                        # ISO URB: its packet descriptors follow the OUT data and
                        # must be consumed to stay framed. Isochronous IN on a
                        # registered endpoint is served; anything else (ISO OUT, an
                        # unknown endpoint, descriptors that don't fit the buffer)
                        # fails with -EPIPE without touching the device.
                        if cmd.number_of_packets > u.MAX_ISO_PACKETS:
                            print(f"[usbip] bogus ISO packet count "
                                  f"{cmd.number_of_packets}; closing connection")
                            return
                        descs = self._recvall(cmd.iso_desc_len)
                        pkts = u.parse_iso_descs(descs)
                        if dev.is_isoc(cmd) and sum(l for _o, l in pkts) <= \
                                cmd.transfer_buffer_length:
                            cmd.iso_packets = pkts
                        else:
                            with self._send_lock:
                                try:
                                    self.request.sendall(
                                        u.pack_ret_submit_iso_error(cmd, EPIPE, descs))
                                except OSError:
                                    pass
                            continue
                except ConnectionError:
                    return
                if _TRACE:
                    _trace(self._busid, f"CMD_SUBMIT seq={cmd.seqnum} ep={cmd.ep} "
                           f"{'IN ' if cmd.is_in else 'OUT'} len={cmd.transfer_buffer_length}"
                           + (f" setup={cmd.setup.hex()}" if (cmd.ep & 0x0F) == 0 else "")
                           + (f" data={_hexhead(cmd.transfer_buffer)}"
                              if cmd.transfer_buffer else "")
                           + (" async" if dev.is_async(cmd) else ""))
                if dev.is_async(cmd):
                    # completed later, on the mux reader thread, when the reply lands
                    with self._send_lock:
                        self._inflight[cmd.seqnum] = cmd
                    dev.enqueue_async(cmd, self._complete_async)
                else:
                    status, data = dev.submit(cmd)
                    with self._send_lock:
                        try:
                            self.request.sendall(u.pack_ret_submit(cmd, status, data))
                        except OSError:
                            pass
            elif command == u.USBIP_CMD_UNLINK:
                # Linux stub semantics: a still-pending URB is cancelled and
                # answered ONLY by RET_UNLINK(-ECONNRESET); one that already
                # completed gets RET_UNLINK(0). Holding _send_lock across the
                # cancel orders us against _complete_async (lock order: _send_lock
                # -> mux lock; the mux never calls back holding its own lock).
                if _TRACE:
                    _trace(self._busid, f"CMD_UNLINK seq={cmd.seqnum} "
                           f"victim={cmd.unlink_seqnum}")
                with self._send_lock:
                    victim = self._inflight.get(cmd.unlink_seqnum)
                    if victim is not None and not dev.cancel_async(victim):
                        # its completion is already in flight (blocked on this
                        # lock): RET_SUBMIT must reach vhci first, then this ack.
                        self._unlink_after[cmd.unlink_seqnum] = cmd
                        continue
                    if victim is not None:
                        del self._inflight[cmd.unlink_seqnum]
                        status = ECONNRESET
                    else:
                        status = 0
                    try:
                        self.request.sendall(u.pack_ret_unlink(cmd, status))
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

"""
Bridge a USB/IP export to the SXUPTP data channel.

Maps the hub's USB devices onto USB/IP busids and turns USBIP_CMD_SUBMIT into
SXUPTP transfers via `sxuptp.SxuptpClient`.

Control (ep0) and bulk run on the device's main data channel. Interrupt (HID)
endpoints each get their OWN dedicated SXUPTP channel + reader thread (as the
official driver does): interrupt is a continuous async stream (type 0x0002), and
mixing it with control on one channel desyncs the stream and resets the device.
"""
from __future__ import annotations

import queue
import socket
import struct
import threading

from ..sxuptp.client import SxuptpClient
from ..sxuptp import protocol as sx
from . import protocol as u

# Linux URB status codes (negative errno) we hand back in RET_SUBMIT.status
EPIPE = -32          # stall
EREMOTEIO = -121     # short/other IO error

# How long backend.submit waits for a queued interrupt report before returning
# "no data" (idle keyboard produces no reports). Bounds detach latency.
INTR_WAIT = 20.0


class InterruptChannel:
    """A dedicated SXUPTP connection + reader thread for one interrupt IN
    endpoint. Keeps interrupt reads outstanding and drains HID reports into a
    queue; submit() pops from it. Isolating interrupt from control is what keeps
    the stream from desyncing (the whole reason the keyboard reset before)."""

    def __init__(self, host, client_ip, device_mac, node, dev_id, ep_addr,
                 length, interval, grant_sock, lock):
        self.ep_addr = ep_addr
        self.q: queue.Queue = queue.Queue(maxsize=256)
        self._stop = False
        self.client = SxuptpClient(host)
        # own session socket (fresh source port); list on it then connect, with
        # the shared grant socket. Serialize the attach so only one OPEN_WAIT job
        # exists at a time (the match is by client IP).
        udp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        udp.bind((client_ip, 0)); udp.connect((host, 19540)); udp.settimeout(2.0)
        udp.send(b"\x00\x01\x00\x01GET USB_DEVICE_LIST" + b"\0" * 0x4F + b"\x02\x00")
        try: udp.recv(8192)
        except socket.timeout: pass
        if lock is not None:
            lock.acquire()
        try:
            self.client.attach(node, device_mac, client_ip, udp=udp, bc=grant_sock)
        finally:
            if lock is not None:
                lock.release()
        self.client._owns_udp = True          # close this session socket on disconnect
        self.client.dev_id = dev_id            # reuse known handle; no control here
        self.length = length
        self.interval = interval or 10
        self._t = threading.Thread(target=self._reader, daemon=True)
        self._t.start()

    def _reader(self):
        while not self._stop:
            try:
                status, data = self.client.interrupt_in(self.ep_addr, self.length,
                                                         self.interval, timeout=30)
            except socket.timeout:
                continue                       # idle; resubmit
            except Exception:
                break                          # channel gone
            if status == 0 and data:
                try:
                    self.q.put_nowait(data)
                except queue.Full:
                    pass

    def get(self, timeout):
        try:
            return self.q.get(timeout=timeout)
        except queue.Empty:
            return None

    def close(self):
        self._stop = True
        try:
            self.client.disconnect()           # RST-closes its channel
        except Exception:
            pass


class Device:
    """One exported hub device: a busid <-> (SXUPTP node, host) pair."""

    def __init__(self, host: str, client_ip: str, device_mac: bytes,
                 node: str, busid: str, busnum: int, devnum: int,
                 vid: int = 0, pid: int = 0, udp=None, bc=None, lock=None):
        self.host = host
        self.client_ip = client_ip
        self.device_mac = device_mac
        self.node = node
        self.busid = busid
        self.busnum = busnum
        self.devnum = devnum
        self.vid = vid         # expected USB VID:PID (from GET USB_DEVICE_LIST),
        self.pid = pid         # used to resolve the right devId (not the node idx)
        self._udp = udp        # shared persistent session socket (list + connect)
        self._bc = bc          # shared persistent grant socket (client_ip:19540)
        self._lock = lock      # serialize attaches across the shared session socket
        self.client: SxuptpClient | None = None
        self.info: u.UsbipDevice | None = None
        self.resolved_dev_id: int | None = None
        self.ep_info: dict[int, tuple[int, int]] = {}
        self._intr: dict[int, InterruptChannel] = {}   # ep_addr -> channel
        self._intr_lock = threading.Lock()

    # --- lifecycle ------------------------------------------------------
    def attach(self, exclude: tuple[int, ...] = ()) -> u.UsbipDevice:
        """Open the SXUPTP channel and read enough descriptors to describe the
        device to USB/IP. Resolves the devId by VID:PID (the devId is a USB
        address, not the devNN index); `exclude` skips handles already bound to
        other busids with the same VID:PID. Returns the populated UsbipDevice."""
        c = SxuptpClient(self.host)
        if self._lock is not None:
            self._lock.acquire()
        try:
            c.attach(self.node, self.device_mac, self.client_ip,
                     udp=self._udp, bc=self._bc)
            c.find_dev_id(want_vid=self.vid or None, want_pid=self.pid or None,
                          exclude=exclude)
        finally:
            if self._lock is not None:
                self._lock.release()
        self.resolved_dev_id = c.dev_id
        self.client = c

        dd = c.control_transfer(sx.Setup.get_descriptor(desc_type=1, desc_index=0,
                                                        length=18))
        id_vendor = dd[8] | (dd[9] << 8)
        id_product = dd[10] | (dd[11] << 8)
        bcd_device = dd[12] | (dd[13] << 8)
        dev_class, dev_sub, dev_proto = dd[4], dd[5], dd[6]
        num_cfg = dd[17] if len(dd) > 17 else 1

        # config descriptor header (9 bytes): wTotalLength, bNumInterfaces, bConfigValue
        cfg = c.control_transfer(sx.Setup.get_descriptor(desc_type=2, desc_index=0,
                                                        length=9))
        num_intf = cfg[4] if len(cfg) >= 5 else 1
        cfg_value = cfg[5] if len(cfg) >= 6 else 1

        # per-interface class triples + max endpoint packet size, from the full
        # config descriptor
        total = (cfg[2] | (cfg[3] << 8)) if len(cfg) >= 4 else 9
        interfaces: list[tuple[int, int, int]] = []
        max_ep_mps = 0
        # endpoint address -> (transfer_type, bInterval); type 3 = interrupt
        self.ep_info: dict[int, tuple[int, int]] = {}
        if total > 9:
            full = c.control_transfer(sx.Setup.get_descriptor(desc_type=2, desc_index=0,
                                                             length=total))
            i = 0
            while i + 1 < len(full):
                blen, btype = full[i], full[i + 1]
                if blen == 0:
                    break
                if btype == 0x04 and i + 8 < len(full):      # INTERFACE descriptor
                    interfaces.append((full[i + 5], full[i + 6], full[i + 7]))
                elif btype == 0x05 and i + 6 < len(full):    # ENDPOINT descriptor
                    addr = full[i + 2]
                    attr = full[i + 3] & 0x03
                    mps = (full[i + 4] | (full[i + 5] << 8)) & 0x07FF
                    interval = full[i + 6]
                    self.ep_info[addr] = (attr, interval)
                    max_ep_mps = max(max_ep_mps, mps)
                i += blen

        # Derive the USB speed the hub must advertise to the client, so the vhci
        # does not clamp maxpacket (full-speed + 512-byte bulk EPs -> EPIPE loop).
        #   512-byte endpoint  -> high speed
        #   EP0 maxpacket == 8 -> low speed (e.g. the keyboards)
        #   otherwise          -> full speed
        bmps0 = dd[7] if len(dd) > 7 else 64
        if max_ep_mps >= 512:
            speed = u.SPEED_HIGH
        elif bmps0 <= 8:
            speed = u.SPEED_LOW
        else:
            speed = u.SPEED_FULL

        self.info = u.UsbipDevice(
            busid=self.busid, busnum=self.busnum, devnum=self.devnum,
            speed=speed, id_vendor=id_vendor, id_product=id_product,
            bcd_device=bcd_device, b_device_class=dev_class,
            b_device_subclass=dev_sub, b_device_protocol=dev_proto,
            b_configuration_value=cfg_value, b_num_configurations=num_cfg or 1,
            b_num_interfaces=num_intf or 1, interfaces=interfaces)
        return self.info

    def detach(self) -> None:
        for ch in list(self._intr.values()):
            ch.close()
        self._intr.clear()
        if self.client:
            try:
                self.client.disconnect()
            finally:
                self.client = None

    def _intr_channel(self, ep_addr: int, length: int, interval: int) -> "InterruptChannel":
        """Lazily open the dedicated interrupt channel for an endpoint."""
        with self._intr_lock:
            ch = self._intr.get(ep_addr)
            if ch is None:
                ch = InterruptChannel(self.host, self.client_ip, self.device_mac,
                                      self.node, self.resolved_dev_id, ep_addr,
                                      length or 8, interval or 10, self._bc, self._lock)
                self._intr[ep_addr] = ch
            return ch

    # --- URB handling ---------------------------------------------------
    def submit(self, cmd: u.CmdSubmit) -> tuple[int, bytes]:
        """Execute a SUBMIT -> (usbip_status, in_data). status 0 = success."""
        if self.client is None:
            return EPIPE, b""
        ep_num = cmd.ep & 0x0F
        if ep_num == 0:
            return self._control(cmd)
        ep_addr = (ep_num | 0x80) if cmd.is_in else ep_num
        attr, interval = self.ep_info.get(ep_addr, (2, 10))
        try:
            if attr == 3:                    # interrupt IN -> dedicated channel
                if not cmd.is_in:
                    return EPIPE, b""        # interrupt OUT: unsupported for now
                ch = self._intr_channel(ep_addr, cmd.transfer_buffer_length or 8, interval)
                data = ch.get(timeout=INTR_WAIT)
                return (0, data) if data is not None else (0, b"")
            if cmd.is_in:                    # bulk IN
                status, data = self.client.bulk_in(ep_addr, cmd.transfer_buffer_length)
                return (0, data) if status == 0 else (EREMOTEIO, b"")
            status = self.client.bulk_out(ep_addr, cmd.transfer_buffer)  # bulk OUT
            return (0, b"") if status == 0 else (EREMOTEIO, b"")
        except Exception:
            return EPIPE, b""

    def _control(self, cmd: u.CmdSubmit) -> tuple[int, bytes]:
        bm, b_req, w_value, w_index, w_length = struct.unpack("<BBHHH", cmd.setup)
        setup = sx.Setup(bmRequestType=bm, bRequest=b_req, wValue=w_value,
                         wIndex=w_index, wLength=w_length)
        try:
            if bm & 0x80:                    # IN
                data = self.client.control_transfer(setup)
                return 0, data[:w_length]
            else:                            # OUT
                self.client.control_transfer(setup, cmd.transfer_buffer)
                return 0, b""
        except Exception:
            return EPIPE, b""

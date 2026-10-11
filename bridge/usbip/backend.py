"""
Bridge a USB/IP export to the SXUPTP data channel.

Maps the hub's USB devices onto USB/IP busids and turns USBIP_CMD_SUBMIT into
SXUPTP transfers via `sxuptp.SxuptpClient`.

Control (ep0), bulk, and interrupt (HID) all run on the device's one SXUPTP data
channel. Each hub node (interface) is its own busid/channel, so a keyboard's ep0
enumeration and its ep81 interrupt reports share a single channel with no
competing traffic. Interrupt uses transfer type 0x0002 and every reply is a
uniformly framed 10-byte-header + data message (see sxuptp.client._read_reply);
exactly one interrupt_read is kept outstanding so idle waits never pile up.
"""
from __future__ import annotations

import socket
import struct

from ..sxuptp.client import SxuptpClient
from ..sxuptp import protocol as sx
from . import protocol as u

# Linux URB status codes (negative errno) we hand back in RET_SUBMIT.status
EPIPE = -32          # stall
EREMOTEIO = -121     # short/other IO error

# How long an interrupt-IN read waits for a report before returning "no data".
# Kept short so the single-threaded URB loop cycles between endpoints (ep81
# keyboard vs ep82 consumer) without parking too long on an idle one.
INTR_WAIT = 10.0


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
        self.single_cfg: bytes | None = None

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
        # A single-interface config descriptor we present to the kernel (see
        # self.single_cfg below); None until synthesized.
        self.single_cfg: bytes | None = None
        if total > 9:
            full = c.control_transfer(sx.Setup.get_descriptor(desc_type=2, desc_index=0,
                                                             length=total))
            # The hub splits a composite device's interfaces across SEPARATE nodes
            # (dev02=interface0/ep81, dev03=interface1/ep82), each on its own SXUPTP
            # channel. This busid is ONE node and serves only its first interface's
            # endpoint; polling the other interface's EP on this channel corrupts it
            # (verified: it drove the keyboard into a -32 reset loop). So we present
            # only interface 0 to the client and cut `full` off at the 2nd INTERFACE
            # descriptor, so the kernel never creates/polls the foreign interface.
            cut = len(full)
            seen_iface = False
            i = 0
            while i + 1 < len(full):
                blen, btype = full[i], full[i + 1]
                if blen == 0:
                    break
                if btype == 0x04:                            # INTERFACE descriptor
                    if seen_iface:
                        cut = i                              # start of 2nd interface
                        break
                    seen_iface = True
                    if i + 8 < len(full):
                        interfaces.append((full[i + 5], full[i + 6], full[i + 7]))
                elif btype == 0x05 and i + 6 < len(full):    # ENDPOINT descriptor
                    addr = full[i + 2]
                    attr = full[i + 3] & 0x03
                    mps = (full[i + 4] | (full[i + 5] << 8)) & 0x07FF
                    interval = full[i + 6]
                    self.ep_info[addr] = (attr, interval)    # only interface 0's EPs
                    max_ep_mps = max(max_ep_mps, mps)
                i += blen

            if cut < len(full):
                single = bytearray(full[:cut])
                single[2] = cut & 0xFF                       # wTotalLength (LE)
                single[3] = (cut >> 8) & 0xFF
                single[4] = 1                                # bNumInterfaces = 1
                self.single_cfg = bytes(single)
                num_intf = 1
                interfaces = interfaces[:1]

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
        if self.client:
            try:
                self.client.disconnect()
            finally:
                self.client = None

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
            if attr == 3:                    # interrupt IN (type 0x0002) on main channel
                if not cmd.is_in:
                    return EPIPE, b""        # interrupt OUT: unsupported for now
                try:
                    status, data = self.client.interrupt_in(
                        ep_addr, cmd.transfer_buffer_length or 8, interval or 10,
                        timeout=INTR_WAIT)
                except socket.timeout:
                    return 0, b""            # idle interval, no report -> resubmit
                return (0, data) if status == 0 else (EREMOTEIO, b"")
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
                # Serve our single-interface config descriptor (hides the foreign
                # interface whose EP lives on another node) instead of the device's
                # real 2-interface one. wValue = (descType << 8) | index; 0x02 = CONFIG.
                if (self.single_cfg is not None and b_req == 0x06
                        and (w_value >> 8) == 0x02):
                    return 0, self.single_cfg[:w_length]
                data = self.client.control_transfer(setup)
                return 0, data[:w_length]
            else:                            # OUT
                self.client.control_transfer(setup, cmd.transfer_buffer)
                return 0, b""
        except Exception:
            return EPIPE, b""

"""
Bridge a USB/IP export to the SXUPTP data channel.

Maps the hub's USB devices onto USB/IP busids and turns USBIP_CMD_SUBMIT into
SXUPTP transfers via `sxuptp.SxuptpClient`.

Control (ep0), bulk, and interrupt (HID) all run on the device's one SXUPTP data
channel; interrupt uses transfer type 0x0002 and every reply is a uniformly
framed 10-byte-header + data message (see sxuptp.client._read_framed).

Two interrupt-endpoint shapes:
  * One interrupt-IN endpoint (a plain keyboard): the URB loop polls it
    synchronously, keeping exactly one interrupt_read outstanding.
  * COMPOSITE HID device (this keyboard: if0=ep81 keys, if1=ep82 consumer/media +
    system control). The hub splits a composite device's interfaces across
    SEPARATE nodes/channels (dev02=if0, dev03=if1) and delivers each endpoint's
    reports only on its own node's channel. So we present the full device, run the
    primary node (control + if0/ep81) through a ChannelMux, and open a SECONDARY
    channel to the sibling node for if1/ep82 (reusing the devId; the sibling node
    answers no control). Each ChannelMux's reader thread demuxes replies by seq and
    completes kernel URBs asynchronously the instant a report lands, so every
    endpoint stays crisp. The Hub claims the sibling node so it is not also
    exported as a standalone busid.
"""
from __future__ import annotations

import socket
import struct

from ..sxuptp.client import ChannelMux, SxuptpClient
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
                 vid: int = 0, pid: int = 0, udp=None, bc=None, lock=None,
                 siblings: tuple[str, ...] = (), hub=None):
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
        # ordered same-VID:PID node names (this node first); a composite device's
        # interfaces are split across these (dev02=if0, dev03=if1, ...).
        self.siblings = siblings
        self.hub = hub         # for claiming sibling nodes as secondary channels
        self.client: SxuptpClient | None = None
        self.info: u.UsbipDevice | None = None
        self.resolved_dev_id: int | None = None
        self.ep_info: dict[int, tuple[int, int]] = {}
        self.ep_mps: dict[int, int] = {}
        self.ep_iface: dict[int, int] = {}     # endpoint addr -> interface index
        self.single_cfg: bytes | None = None
        self.composite: bool = False
        self.intr_in_eps: list[int] = []
        self.mux = None                        # primary ChannelMux (control + if0)
        self._secondary: list = []             # [(SxuptpClient, ChannelMux), ...]
        self.ep_mux: dict[int, object] = {}    # interrupt ep addr -> owning mux

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
        # All interrupt-IN endpoint addrs, in descriptor order (ep81, ep82, ...).
        self.intr_in_eps: list[int] = []
        self.ep_mps: dict[int, int] = {}       # endpoint addr -> wMaxPacketSize
        self.composite = False
        if total > 9:
            full = c.control_transfer(sx.Setup.get_descriptor(desc_type=2, desc_index=0,
                                                             length=total))
            # Walk the full config, collecting every interface's class triple and
            # every endpoint. `cut` marks the start of the 2nd interface (used only
            # for the single-interface fallback below).
            cut = len(full)
            iface_idx = -1
            i = 0
            while i + 1 < len(full):
                blen, btype = full[i], full[i + 1]
                if blen == 0:
                    break
                if btype == 0x04:                            # INTERFACE descriptor
                    iface_idx += 1
                    if iface_idx == 1 and cut == len(full):
                        cut = i                              # start of 2nd interface
                    if i + 8 < len(full):
                        interfaces.append((full[i + 5], full[i + 6], full[i + 7]))
                elif btype == 0x05 and i + 6 < len(full):    # ENDPOINT descriptor
                    addr = full[i + 2]
                    attr = full[i + 3] & 0x03
                    mps = (full[i + 4] | (full[i + 5] << 8)) & 0x07FF
                    interval = full[i + 6]
                    self.ep_info[addr] = (attr, interval)
                    self.ep_mps[addr] = mps
                    self.ep_iface[addr] = max(iface_idx, 0)
                    max_ep_mps = max(max_ep_mps, mps)
                    if attr == 3 and (addr & 0x80):
                        self.intr_in_eps.append(addr)
                i += blen

            # A composite HID device (e.g. this keyboard: if0=ep81 keys, if1=ep82
            # consumer/media keys) has >1 interrupt-IN endpoint, and the hub splits
            # the interfaces across SEPARATE nodes/channels (dev02=if0, dev03=if1):
            # ep82 reports arrive only on dev03's channel (verified in the driver
            # capture). So in composite mode we present the FULL device, keep if0 on
            # this (primary) channel, and open a secondary channel to the sibling
            # node for each further interface's interrupt endpoint.
            # Otherwise (a lone extra interface with no interrupt-IN endpoint we
            # handle) fall back to presenting only interface 0 — cut the descriptor
            # at the 2nd INTERFACE so the kernel never polls the foreign endpoint.
            self.composite = len(self.intr_in_eps) >= 2 and len(self.siblings) >= 2
            if not self.composite and cut < len(full):
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

        # Composite HID: the primary channel (this node) carries control + every
        # interface-0 interrupt endpoint via a ChannelMux. Each FURTHER interface's
        # interrupt endpoint lives on a sibling node, so open a secondary channel
        # (fresh ephemeral CONNECT socket, reusing this device's devId — the
        # sibling node does not answer control) with its own mux. After this the
        # reader thread(s) own the socket(s).
        if self.composite:
            self.mux = ChannelMux(c)
            for ep in self.intr_in_eps:
                iface = self.ep_iface.get(ep, 0)
                interval = self.ep_info[ep][1]
                length = self.ep_mps.get(ep, 8) or 8
                if iface == 0:
                    self.mux.register_intr(ep, length, interval)
                    self.ep_mux[ep] = self.mux
                else:
                    smux = self._open_secondary(iface, c.dev_id)
                    if smux is not None:
                        smux.register_intr(ep, length, interval)
                        self.ep_mux[ep] = smux
        return self.info

    def _open_secondary(self, iface: int, dev_id: int):
        """Attach the sibling node that carries interface `iface` and return a
        ChannelMux for it (reusing dev_id; no control on the sibling). Marks the
        sibling busid claimed so it is not exported independently."""
        if iface >= len(self.siblings):
            return None
        node = self.siblings[iface]
        sc = SxuptpClient(self.host)
        if self._lock is not None:
            self._lock.acquire()
        try:
            # own fresh ephemeral CONNECT socket (udp=None); shared grant socket.
            sc.attach(node, self.device_mac, self.client_ip, udp=None, bc=self._bc)
        finally:
            if self._lock is not None:
                self._lock.release()
        sc._owns_udp = True
        sc.dev_id = dev_id                       # reuse; sibling answers no control
        if self.hub is not None:
            self.hub.claim_node(node)            # hide its standalone busid
        smux = ChannelMux(sc)
        self._secondary.append((sc, smux))
        return smux

    def detach(self) -> None:
        for _sc, smux in self._secondary:
            try:
                smux.close()
            except Exception:
                pass
        for sc, _smux in self._secondary:
            try:
                sc.disconnect()
            except Exception:
                pass
        self._secondary = []
        if self.mux is not None:
            try:
                self.mux.close()
            except Exception:
                pass
            self.mux = None
        if self.client:
            try:
                self.client.disconnect()
            finally:
                self.client = None

    # --- URB handling ---------------------------------------------------
    def is_async_interrupt(self, cmd: u.CmdSubmit) -> bool:
        """True if this SUBMIT is an interrupt-IN a ChannelMux completes
        asynchronously (so the URB loop must not reply inline)."""
        if not cmd.is_in or (cmd.ep & 0x0F) == 0:
            return False
        return ((cmd.ep & 0x0F) | 0x80) in self.ep_mux

    def enqueue_interrupt(self, cmd: u.CmdSubmit, complete) -> None:
        """Hand an interrupt-IN URB to its endpoint's mux; `complete(cmd, status,
        data)` is invoked when a report arrives (status 0 = OK)."""
        ep_addr = (cmd.ep & 0x0F) | 0x80
        self.ep_mux[ep_addr].enqueue(
            ep_addr, cmd,
            lambda c, st, data: complete(
                c, 0 if st == 0 else EREMOTEIO, data if st == 0 else b""))

    def submit(self, cmd: u.CmdSubmit) -> tuple[int, bytes]:
        """Execute a synchronous SUBMIT -> (usbip_status, in_data). status 0 = OK.

        Interrupt-IN in composite (mux) mode is handled by enqueue_interrupt, not
        here — see is_async_interrupt."""
        if self.client is None:
            return EPIPE, b""
        ep_num = cmd.ep & 0x0F
        if ep_num == 0:
            return self._control(cmd)
        ep_addr = (ep_num | 0x80) if cmd.is_in else ep_num
        attr, interval = self.ep_info.get(ep_addr, (2, 10))
        try:
            if attr == 3:                    # interrupt
                if not cmd.is_in:
                    return EPIPE, b""        # interrupt OUT: unsupported for now
                # non-mux (single interrupt endpoint) path: synchronous one-shot
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
            # In composite mode the mux owns the channel; route control through it.
            if self.mux is not None:
                if bm & 0x80:
                    status, data = self.mux.control(setup)
                    return (0, data[:w_length]) if status == 0 else (EPIPE, b"")
                status, _ = self.mux.control(setup, cmd.transfer_buffer)
                return (0, b"") if status == 0 else (EPIPE, b"")
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

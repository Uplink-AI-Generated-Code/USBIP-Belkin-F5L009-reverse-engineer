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

import os
import socket
import struct
import time

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
        self.use_mux: bool = False
        self.intr_in_eps: list[int] = []
        self.bulk_in_eps: list[int] = []
        self._async_eps: list[int] = []
        self.mux = None                        # primary ChannelMux (control + if0)
        self._secondary: list = []             # [(SxuptpClient, ChannelMux), ...]
        self.ep_mux: dict[int, object] = {}    # interrupt ep addr -> owning mux
        # Mass-storage keep-alive [OPT-IN, OFF BY DEFAULT]: the vendor driver never
        # lets the bulk pipe go quiet -- it slips a TEST_UNIT_READY (+REQUEST_SENSE)
        # onto the device every ~0.3-1 s, idle or mid-write, and interleaves ~1200
        # READ(10) across a large write. Linux goes silent on the bulk pipe while
        # streaming a big write, which lets the hub's write path back up. Mirror the
        # vendor: inject our own command between the kernel's commands when the pipe
        # has been one-directional for too long. SXMS_KEEPALIVE = seconds between
        # injections (0 = off, the default). NOTE: this materially extends how far a
        # sustained write streams (the mid-stream wedge moves out by a lot), but it
        # does NOT overcome this hub's non-deterministic mid-write drops -- direct
        # SXUPTP tests (no Linux) show the hub can wedge a single 512 B write at
        # random. See memory bridge-working-usbip. So this is a best-effort aid for
        # the reliable range (tens of MB), not a guaranteed 128 MB fix.
        self.mass_storage = False
        self._ms_bulk_out: int | None = None
        self._ms_bulk_in: int | None = None
        self._ka_interval = float(os.environ.get("SXMS_KEEPALIVE", "0") or 0)
        self._ka_debug = bool(os.environ.get("SXMS_KA_DEBUG"))
        # Read-drain mode: inject a READ(10) instead of a TUR. A TUR is only a
        # status poll; a READ forces a real bulk-IN transaction, making the hub
        # turn its internal bus around and drain its write FIFO -- the vendor's
        # actual anti-wedge mechanism (its ~1200 interleaved READ(10)). Reads a
        # fixed, always-valid LBA (default 0 = the boot sector); the data is
        # discarded, only the IN transaction matters.
        self._ka_read = bool(os.environ.get("SXMS_KA_READ"))
        self._ka_read_lba = int(os.environ.get("SXMS_KA_READ_LBA", "0") or 0)
        # Rotate the read LBA each injection so the hub can't serve it from its
        # own read cache (a cached read never turns the device bus around and so
        # never drains the write FIFO). Stride in 512-byte blocks, wrapped in a
        # safe low window. SXMS_KA_READ_BLOCKS = blocks per read (bus turnaround
        # scales with transfer size).
        self._ka_read_stride = int(os.environ.get("SXMS_KA_READ_STRIDE", "2048") or 0)
        self._ka_read_window = int(os.environ.get("SXMS_KA_READ_WINDOW", "2097152") or 1)
        self._ka_read_blocks = int(os.environ.get("SXMS_KA_READ_BLOCKS", "8") or 1)
        self._ka_last = 0.0
        self._ka_tag = 0xCAFE0000
        self._ka_n = 0
        self._ka_fail = 0
        # Data-channel RECONNECT workaround (the reliable fix for the ~60-70s hub
        # RST). The hub has a per-TCP-connection keepalive/RTO timer that RSTs a
        # single long transfer at ~68s regardless of traffic (see
        # proprietary-Belkin-Silex/analysis/F5L009_v1.2.0/
        # tcp_connection_and_keepalive.md -- the root reset condition the vendor
        # driver uses could not be reproduced). A fresh connection has a fresh
        # timer, so we transparently re-establish the SXUPTP data channel every
        # SXMS_RECONNECT_SECS seconds, at a Bulk-Only-Transport boundary (right
        # after a CSW). Proven: 256MB written through 3 reconnects, no wedge.
        # 0 = off (default). Use e.g. 50 (comfortably under ~68s).
        self._reconnect_secs = float(os.environ.get("SXMS_RECONNECT_SECS", "0") or 0)
        self._reconnect_debug = bool(os.environ.get("SXMS_RECONNECT_DEBUG"))
        self._reconnect_last = 0.0
        self._reconnect_n = 0

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
        # async-read endpoint addrs, in descriptor order (interrupt-IN, bulk-IN).
        self.intr_in_eps: list[int] = []
        self.bulk_in_eps: list[int] = []
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
                    if addr & 0x80:
                        if attr == 3:
                            self.intr_in_eps.append(addr)
                        elif attr == 2:
                            self.bulk_in_eps.append(addr)
                i += blen

            # Endpoints whose reads can block and must run async through a
            # ChannelMux: interrupt-IN (HID reports) and bulk-IN (serial RX parks
            # with no data). Mass storage (class 0x08) stays on the synchronous
            # bulk path (request/response, never idle-blocks) — don't disturb it.
            mass_storage = any(cls == 0x08 for cls, _, _ in interfaces)
            self.mass_storage = mass_storage
            if mass_storage:
                outs = [a for a, (attr, _) in self.ep_info.items()
                        if not (a & 0x80) and attr == 2]
                self._ms_bulk_out = outs[0] if outs else None
                self._ms_bulk_in = self.bulk_in_eps[0] if self.bulk_in_eps else None
            async_eps = [] if mass_storage else (self.intr_in_eps + self.bulk_in_eps)
            # The hub splits a composite device's interfaces across SEPARATE
            # nodes/channels (keyboard: dev02=if0/ep81, dev03=if1/ep82) and delivers
            # each endpoint's reports only on its own node's channel. So if any
            # async endpoint lives on interface >=1 AND we have the sibling nodes for
            # it, go composite: present the FULL device and open a secondary channel
            # per further interface. If a foreign interface's endpoint has no sibling
            # node to reach it, fall back to presenting only interface 0 (truncate
            # the descriptor) so the kernel never polls an unreachable endpoint.
            foreign = [e for e in async_eps if self.ep_iface.get(e, 0) >= 1]
            reachable = all(self.ep_iface[e] < len(self.siblings) for e in foreign)
            self.composite = bool(foreign) and reachable
            self.use_mux = bool(async_eps) and (not foreign or self.composite)
            if foreign and not reachable and cut < len(full):
                single = bytearray(full[:cut])
                single[2] = cut & 0xFF                       # wTotalLength (LE)
                single[3] = (cut >> 8) & 0xFF
                single[4] = 1                                # bNumInterfaces = 1
                self.single_cfg = bytes(single)
                num_intf = 1
                interfaces = interfaces[:1]
                async_eps = [e for e in async_eps if self.ep_iface.get(e, 0) == 0]
                self.use_mux = bool(async_eps)
                self.composite = False
            self._async_eps = async_eps
            # Give the client the enumerated endpoint MaxPacketSizes so its bulk
            # headers carry the real 0x8000|mps (e.g. 0x8200 for a 512-byte HS
            # bulk endpoint) instead of the hardcoded 64 the default would use.
            c.ep_mps = dict(self.ep_mps)

        # Derive the USB speed the hub must advertise to the client, so the vhci
        # does not clamp maxpacket (full-speed + 512-byte bulk EPs -> EPIPE loop)
        # nor coerce bulk endpoints to interrupt (low-speed has no bulk).
        #   512-byte endpoint        -> high speed
        #   has a BULK endpoint      -> full speed (low-speed can't do bulk; e.g.
        #                               the FTDI/PL2303 serial adapters have EP0
        #                               maxpacket 8 but are full-speed)
        #   EP0 maxpacket == 8, no bulk -> low speed (e.g. the keyboards)
        #   otherwise                -> full speed
        bmps0 = dd[7] if len(dd) > 7 else 64
        has_bulk = any(attr == 2 for attr, _ in self.ep_info.values())
        if max_ep_mps >= 512:
            speed = u.SPEED_HIGH
        elif has_bulk:
            speed = u.SPEED_FULL
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

        # The primary channel (this node) carries control, bulk-OUT, and every
        # interface-0 async-IN endpoint (interrupt + bulk) via a ChannelMux. A
        # composite device's FURTHER interfaces live on sibling nodes, so open a
        # secondary channel per such interface (fresh ephemeral CONNECT socket,
        # reusing this device's devId — the sibling node answers no control) with
        # its own mux. After this the reader thread(s) own the socket(s).
        if self.use_mux:
            self.mux = ChannelMux(c)
            secondary: dict[int, object] = {}
            for ep in self._async_eps:
                iface = self.ep_iface.get(ep, 0)
                if iface == 0:
                    mux = self.mux
                else:
                    mux = secondary.get(iface) or self._open_secondary(iface, c.dev_id)
                    if mux is None:
                        continue
                    secondary[iface] = mux
                if ep in self.intr_in_eps:
                    mux.register_intr(ep, self.ep_mps.get(ep, 8) or 8,
                                      self.ep_info[ep][1])
                else:
                    mux.register_bulk_in(ep)
                self.ep_mux[ep] = mux
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
        sc.ep_mps = dict(self.ep_mps)            # carry real MPS on the sibling's bulk headers
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
    def is_async(self, cmd: u.CmdSubmit) -> bool:
        """True if this SUBMIT is an IN endpoint a ChannelMux completes
        asynchronously (interrupt-IN or bulk-IN), so the URB loop must not reply
        inline but hand it to enqueue_async."""
        if not cmd.is_in or (cmd.ep & 0x0F) == 0:
            return False
        return ((cmd.ep & 0x0F) | 0x80) in self.ep_mux

    def enqueue_async(self, cmd: u.CmdSubmit, complete) -> None:
        """Hand an async IN URB (interrupt or bulk) to its endpoint's mux;
        `complete(cmd, status, data)` runs when the reply arrives (status 0 = OK)."""
        ep_addr = (cmd.ep & 0x0F) | 0x80
        mux = self.ep_mux[ep_addr]
        cb = (lambda c, st, data: complete(
            c, 0 if st == 0 else EREMOTEIO, data if st == 0 else b""))
        if ep_addr in self.intr_in_eps:
            mux.enqueue(ep_addr, cmd, cb)
        else:                                # bulk-IN
            mux.enqueue_bulk_in(ep_addr, cmd, cb, cmd.transfer_buffer_length or 64)

    def submit(self, cmd: u.CmdSubmit) -> tuple[int, bytes]:
        """Execute a synchronous SUBMIT -> (usbip_status, in_data). status 0 = OK.

        Async IN endpoints (mux mode) are handled by enqueue_async, not here —
        see is_async. This path serves control, bulk-OUT, and the non-mux
        synchronous interrupt/bulk IN fallbacks."""
        if self.client is None:
            return EPIPE, b""
        ep_num = cmd.ep & 0x0F
        if ep_num == 0:
            return self._control(cmd)
        ep_addr = (ep_num | 0x80) if cmd.is_in else ep_num
        attr, interval = self.ep_info.get(ep_addr, (2, 10))
        try:
            if not cmd.is_in and self.mux is not None:      # bulk OUT (TX) via mux
                status = self.mux.bulk_out(ep_addr, cmd.transfer_buffer)
                return (0, b"") if status == 0 else (EREMOTEIO, b"")
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
            if cmd.is_in:                    # bulk IN (non-mux: mass storage)
                status, data = self.client.bulk_in(ep_addr, cmd.transfer_buffer_length)
                # A 13-byte "USBS" reply is a CSW -> the device is now idle between
                # commands, the one safe moment to slip in our keep-alive TUR or to
                # reconnect the data channel (reset the hub's ~68s connection timer).
                if (status == 0 and len(data) == 13 and data[:4] == b"USBS"):
                    if self._ka_interval:
                        self._keepalive()
                    if self._reconnect_secs:
                        self._maybe_reconnect()
                return (0, data) if status == 0 else (EREMOTEIO, b"")
            status = self.client.bulk_out(ep_addr, cmd.transfer_buffer)  # bulk OUT (non-mux)
            return (0, b"") if status == 0 else (EREMOTEIO, b"")
        except Exception:
            return EPIPE, b""

    def _maybe_reconnect(self) -> None:
        """Re-establish the mass-storage data channel once it has been up for
        >= _reconnect_secs, resetting the hub's per-connection ~68s keepalive/RTO
        RST timer so an arbitrarily large transfer can complete. Called only at a
        CSW boundary (Bulk-Only-Transport-safe). reconnect() renews the TCP channel
        as a new job and re-captures the devId; the kernel never sees it. On
        failure the channel is down and the transfer fails like an un-worked-around
        wedge would -- this is a best-effort opt-in."""
        now = time.monotonic()
        if self._reconnect_last == 0.0:
            self._reconnect_last = now          # start the clock at the first CSW
            return
        if now - self._reconnect_last < self._reconnect_secs:
            return
        try:
            did = self.client.reconnect()
            self._reconnect_last = time.monotonic()
            self._reconnect_n += 1
            if self._reconnect_debug:
                os.write(2, (f"[reconnect] #{self._reconnect_n} devId={did}\n").encode())
        except Exception as e:
            if self._reconnect_debug:
                os.write(2, (f"[reconnect] FAILED: {e}\n").encode())

    def _keepalive(self) -> None:
        """Inject a TEST_UNIT_READY on the mass-storage bulk pipe if it has been
        quiet for >= _ka_interval, mirroring the vendor's ~0.3-1 Hz poll so the
        hub's write path keeps turning around and the device does not drop. Called
        only between the kernel's own commands (right after a CSW), so the
        Bulk-Only-Transport sequence stays in order. Self-generated; the kernel
        never sees the injected CBW/CSW. Failures are swallowed -- the keep-alive
        must never break the real transfer it rides on."""
        now = time.monotonic()
        if now - self._ka_last < self._ka_interval:
            return
        if self._ms_bulk_out is None or self._ms_bulk_in is None:
            return
        self._ka_last = now
        try:
            if self._ka_read:
                # READ(10) 1 block at a fixed LBA -- a real bulk-IN that drains
                # the hub's write FIFO (see __init__). READ(10) = 0x28; LBA is a
                # 32-bit big-endian field, transfer length a 16-bit big-endian
                # block count.
                lba = self._ka_read_lba
                blocks = self._ka_read_blocks
                cdb = (b"\x28\x00" + struct.pack(">I", lba)
                       + b"\x00" + struct.pack(">H", blocks) + b"\x00")
                csw_status = self._bot_cmd(cdb, 512 * blocks)
                # advance for next time, wrapped in the low window
                self._ka_read_lba = (lba + self._ka_read_stride) % max(
                    1, self._ka_read_window)
                tag = "RD"
            else:
                # TEST_UNIT_READY, then REQUEST_SENSE iff it reports CHECK
                # CONDITION -- the vendor's idle poll. Clearing the sense matters
                # so the kernel's next real command never inherits a stale UNIT
                # ATTENTION.
                csw_status = self._bot_cmd(b"\x00", 0)      # TEST_UNIT_READY
                tag = "TUR"
            if csw_status is None:
                self._ka_fail += 1
                return
            if csw_status != 0 and not self._ka_read:       # CHECK CONDITION
                self._bot_cmd(b"\x03\x00\x00\x00\x12\x00", 18)   # REQUEST_SENSE (18B)
            self._ka_n += 1
            if self._ka_debug:
                os.write(2, (f"[ka] {tag} #{self._ka_n} csw={csw_status} "
                             f"fail={self._ka_fail}\n").encode())
        except Exception:
            self._ka_fail += 1

    def _bot_cmd(self, cdb: bytes, data_in_len: int) -> int | None:
        """Run one self-generated Bulk-Only-Transport command on the mass-storage
        pipe: send a CBW wrapping `cdb`, read `data_in_len` bytes of data-in (if
        any), read the 13-byte CSW. Returns the CSW status byte (0 = GOOD), or None
        on a transport error. The CBW/CSW are never forwarded to the kernel."""
        self._ka_tag = (self._ka_tag + 1) & 0xFFFFFFFF
        flags = 0x80 if data_in_len else 0x00               # bmCBWFlags: IN vs none
        cdb16 = (cdb + bytes(16))[:16]
        cbw = (b"USBC" + struct.pack("<I", self._ka_tag)
               + struct.pack("<IBBB", data_in_len, flags, 0x00, len(cdb)) + cdb16)
        if self.client.bulk_out(self._ms_bulk_out, cbw) != 0:
            return None
        if data_in_len:
            self.client.bulk_in(self._ms_bulk_in, data_in_len)   # data-in, discard
        _st, csw = self.client.bulk_in(self._ms_bulk_in, 13)
        if _st != 0 or len(csw) != 13 or csw[:4] != b"USBS":
            return None
        return csw[12]                                      # bCSWStatus

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

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

import contextlib
import os
import socket
import struct
import threading
import time

from ..sxuptp.client import ChannelMux, ChannelWatcher, SxuptpClient
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
        # True while a USB/IP client has this busid imported (set/cleared by the
        # Hub under its claim lock, so a second IMPORT of the same busid refuses
        # instead of opening a second channel to the same node).
        self.in_use = False
        # False once the hub's device list no longer shows this node (unplugged);
        # the busid is kept so the device returns under the same busid on replug.
        self.present = True
        self._watcher: ChannelWatcher | None = None
        # serializes detach(): the handler thread and the shutdown path may both
        # tear the device down, and each channel must be disconnected exactly once.
        self._detach_lock = threading.Lock()
        self._reset_session_state()
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
        # RETIRED: data-channel RECONNECT workaround. The ~60-70s hub RST is now
        # SOLVED and cured by answering the hub's SXUP_ALC keepalive (UDP :0xC15D,
        # the Hub's KeepaliveResponder) -- the "root reset condition" we couldn't
        # reproduce was simply the client echoing that keepalive. A single
        # connection now lives indefinitely (verified: 600s quiet idle), so
        # periodically tearing down and re-establishing the channel is no longer
        # needed for liveness. reconnect() is kept only as a manual recovery path
        # and stays OFF by default (SXMS_RECONNECT_SECS=0). See
        # proprietary-Belkin-Silex/analysis/F5L009_v1.2.0/
        # tcp_connection_and_keepalive.md (★ SOLVED section).
        self._reconnect_secs = float(os.environ.get("SXMS_RECONNECT_SECS", "0") or 0)
        self._reconnect_debug = bool(os.environ.get("SXMS_RECONNECT_DEBUG"))
        self._reconnect_last = 0.0
        self._reconnect_n = 0

    def _reset_session_state(self) -> None:
        """Per-import state: everything attach() derives from one session's
        channel + descriptors. Reset on construction, at the start of every
        attach, and after detach, so nothing (endpoint maps, mux routes, the
        bound devId) survives into the next import of this busid."""
        self.client: SxuptpClient | None = None
        self.info: u.UsbipDevice | None = None
        self.resolved_dev_id: int | None = None
        # endpoint address -> (transfer_type, bInterval); type 3 = interrupt
        self.ep_info: dict[int, tuple[int, int]] = {}
        self.ep_mps: dict[int, int] = {}       # endpoint addr -> wMaxPacketSize
        self.ep_iface: dict[int, int] = {}     # endpoint addr -> interface index
        # A single-interface config descriptor we present to the kernel (see
        # attach); None unless the foreign-interface fallback synthesized one.
        self.single_cfg: bytes | None = None
        self.composite: bool = False
        self.use_mux: bool = False
        # async-read endpoint addrs, in descriptor order (interrupt-IN, bulk-IN).
        self.intr_in_eps: list[int] = []
        self.bulk_in_eps: list[int] = []
        self.isoc_in_eps: list[int] = []
        self._async_eps: list[int] = []
        self.mux = None                        # primary ChannelMux (control + if0)
        self._secondary: list = []             # [(SxuptpClient, ChannelMux), ...]
        self._claimed_nodes: list[str] = []    # sibling nodes this import claimed
        self.ep_mux: dict[int, object] = {}    # interrupt ep addr -> owning mux
        self.mass_storage = False
        self._ms_bulk_out: int | None = None
        self._ms_bulk_in: int | None = None

    def _locked(self):
        """The shared attach lock (or a no-op when running without a Hub)."""
        return self._lock if self._lock is not None else contextlib.nullcontext()

    # --- lifecycle ------------------------------------------------------
    def attach(self, exclude: tuple[int, ...] = ()) -> u.UsbipDevice:
        """Open the SXUPTP channel and read enough descriptors to describe the
        device to USB/IP. Resolves the devId by VID:PID (the devId is a USB
        address, not the devNN index); `exclude` skips handles already bound to
        other busids with the same VID:PID (under a Hub these are added
        automatically). Returns the populated UsbipDevice.

        On ANY failure every channel opened so far is disconnected before the
        exception propagates: a channel left open keeps the node's slot reserved
        on the hub until it is rebooted."""
        if self.client is not None:
            # never drop a live session's channel references (they'd leak)
            raise RuntimeError(f"{self.busid} is already attached")
        self._reset_session_state()
        try:
            return self._attach(exclude)
        except BaseException:
            self.detach()
            raise

    def _attach(self, exclude: tuple[int, ...]) -> u.UsbipDevice:
        c = SxuptpClient(self.host)
        if self.hub is not None:
            c._ka_enabled = False       # the Hub owns the one host-level keepalive responder
        self.client = c                 # stored first so detach() reaches it on failure
        with self._locked():
            # Resolve the devId and publish it under the attach lock: two imports
            # of identical VID:PID devices must each see the other's handle in
            # `exclude`, or both bind the same devId.
            if self.hub is not None:
                exclude = tuple(exclude) + self.hub.exclude_for(self.busid)
            c.attach(self.node, self.device_mac, self.client_ip,
                     udp=self._udp, bc=self._bc)
            c.find_dev_id(want_vid=self.vid or None, want_pid=self.pid or None,
                          exclude=exclude)
            self.resolved_dev_id = c.dev_id

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
        if total > 9:
            full = c.control_transfer(sx.Setup.get_descriptor(desc_type=2, desc_index=0,
                                                             length=total))
            # Walk the full config, collecting every interface's class triple and
            # every endpoint. `cut` marks the start of the 2nd interface (used only
            # for the single-interface fallback below).
            cut = len(full)
            iface_idx = 0
            i = 0
            while i + 1 < len(full):
                blen, btype = full[i], full[i + 1]
                if blen == 0:
                    break
                if btype == 0x04 and i + 8 < len(full):      # INTERFACE descriptor
                    # Key on bInterfaceNumber, not on a running count of INTERFACE
                    # descriptors: each ALTERNATE setting is another descriptor
                    # (a webcam's streaming interface has several), and counting
                    # them would number its endpoints past the sibling nodes.
                    inum, alt = full[i + 2], full[i + 3]
                    iface_idx = inum
                    if inum >= 1 and cut == len(full):
                        cut = i                              # start of 2nd interface
                    if alt == 0:
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
                        elif attr == 1 and addr not in self.isoc_in_eps:
                            self.isoc_in_eps.append(addr)    # same ep recurs per alt setting
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
            async_eps = [] if mass_storage else (self.intr_in_eps + self.bulk_in_eps
                                                 + self.isoc_in_eps)
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
                elif ep in self.isoc_in_eps:
                    mux.register_isoc_in(ep)
                else:
                    mux.register_bulk_in(ep)
                self.ep_mux[ep] = mux
        return self.info

    def watch(self, on_gone) -> None:
        """Call `on_gone(reason)` (once, from a watcher thread) if the hub closes
        any of this import's data channels -- the device was unplugged. Start it
        after attach(); detach() cancels it so our own teardown never fires it."""
        with self._detach_lock:
            if self.client is None:
                return
            self._stop_watch()
            chans = [self.client] + [sc for sc, _mux in self._secondary]
            self._watcher = ChannelWatcher(chans, on_gone).start()

    def _stop_watch(self) -> None:
        if self._watcher is not None:
            self._watcher.stop()
            self._watcher = None

    def _open_secondary(self, iface: int, dev_id: int):
        """Attach the sibling node that carries interface `iface` and return a
        ChannelMux for it (reusing dev_id; no control on the sibling). Marks the
        sibling busid claimed so it is not exported independently."""
        if iface >= len(self.siblings):
            return None
        node = self.siblings[iface]
        if node == self.node:
            # We ARE a later node of the composite group (imported before its
            # primary claimed us): this interface's channel is our own, and a
            # second channel to one node would collide on the hub.
            raise RuntimeError(f"{self.busid} is a secondary node of a composite "
                               f"device; import its primary busid instead")
        if self.hub is not None:
            # Claim BEFORE connecting so the sibling cannot be imported standalone
            # meanwhile. If it already is, refuse the whole import rather than open
            # a second channel to that node (or present an interface we can't
            # serve); attach()'s cleanup disconnects what we opened so far.
            holder = self.hub.claim_node(node)
            if holder is not None:
                raise RuntimeError(f"composite sibling node {node} is imported "
                                   f"standalone as {holder}; detach it first")
            self._claimed_nodes.append(node)
        sc = SxuptpClient(self.host)
        if self.hub is not None:
            sc._ka_enabled = False       # Hub owns the host-level keepalive responder
        try:
            with self._locked():
                # own fresh ephemeral CONNECT socket (udp=None); shared grant socket.
                sc.attach(node, self.device_mac, self.client_ip, udp=None, bc=self._bc)
        except BaseException:
            sc.disconnect()              # release the sibling's half-made job
            raise
        sc._owns_udp = True
        sc.dev_id = dev_id                       # reuse; sibling answers no control
        sc.ep_mps = dict(self.ep_mps)            # carry real MPS on the sibling's bulk headers
        smux = ChannelMux(sc)
        self._secondary.append((sc, smux))
        return smux

    def detach(self) -> None:
        """Disconnect every channel this import opened (secondaries, then the
        primary), release claimed sibling nodes, and reset per-session state.
        Idempotent and thread-safe: a no-op when nothing is attached."""
        with self._detach_lock:
            self._stop_watch()               # first: closing our channels isn't an unplug
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
            if self.mux is not None:
                try:
                    self.mux.close()
                except Exception:
                    pass
            if self.client is not None:
                try:
                    self.client.disconnect()
                except Exception:
                    pass
            if self.hub is not None:
                for node in self._claimed_nodes:
                    self.hub.unclaim_node(node)
            self._reset_session_state()

    # --- URB handling ---------------------------------------------------
    def is_async(self, cmd: u.CmdSubmit) -> bool:
        """True if this SUBMIT is an IN endpoint a ChannelMux completes
        asynchronously (interrupt-IN or bulk-IN), so the URB loop must not reply
        inline but hand it to enqueue_async."""
        if not cmd.is_in or (cmd.ep & 0x0F) == 0:
            return False
        return ((cmd.ep & 0x0F) | 0x80) in self.ep_mux

    def is_isoc(self, cmd: u.CmdSubmit) -> bool:
        """True if this SUBMIT targets an isochronous-IN endpoint we can serve."""
        return (cmd.is_in and ((cmd.ep & 0x0F) | 0x80) in self.isoc_in_eps
                and ((cmd.ep & 0x0F) | 0x80) in self.ep_mux)

    def enqueue_async(self, cmd: u.CmdSubmit, complete) -> None:
        """Hand an async IN URB (interrupt, bulk or isochronous) to its endpoint's
        mux; `complete(cmd, status, data)` runs when the reply arrives (status 0 =
        OK). For an ISO URB (cmd.iso_packets set) `data` is the per-packet result
        list [(status, actual_length, data)] instead of bytes."""
        ep_addr = (cmd.ep & 0x0F) | 0x80
        mux = self.ep_mux[ep_addr]
        if cmd.iso_packets:
            mux.enqueue_isoc(
                ep_addr, cmd,
                lambda c, st, pkts: complete(c, 0 if st == 0 else EREMOTEIO,
                                             pkts if st == 0 else []),
                [length for _off, length in cmd.iso_packets])
            return
        cb = (lambda c, st, data: complete(
            c, 0 if st == 0 else EREMOTEIO, data if st == 0 else b""))
        if ep_addr in self.intr_in_eps:
            mux.enqueue(ep_addr, cmd, cb)
        else:                                # bulk-IN
            mux.enqueue_bulk_in(ep_addr, cmd, cb, cmd.transfer_buffer_length or 64)

    def cancel_async(self, cmd: u.CmdSubmit) -> bool:
        """Withdraw an async IN URB handed to enqueue_async (kernel UNLINK).
        True = cancelled, its completion will never run; False = its completion
        is already on its way (see ChannelMux.cancel_urb)."""
        mux = self.ep_mux.get((cmd.ep & 0x0F) | 0x80)
        if mux is None:
            return False
        return mux.cancel_urb((cmd.ep & 0x0F) | 0x80, cmd)

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
        if cmd.is_in and self.mux is not None:
            # The mux reader owns the primary socket and every IN endpoint it
            # serves is async (is_async). An IN endpoint with no mux route (e.g. a
            # foreign interface we could not reach) must not do a synchronous
            # read on that socket -- it would race the reader for replies.
            return EPIPE, b""
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
        # Serve our single-interface config descriptor (hides the foreign
        # interface whose EP lives on another node) instead of the device's real
        # multi-interface one -- on the mux and non-mux paths alike (interface 0
        # may still have an interrupt EP, so the fallback can run muxed).
        # wValue = (descType << 8) | index; 0x02 = CONFIG.
        if (self.single_cfg is not None and bm & 0x80 and b_req == 0x06
                and (w_value >> 8) == 0x02):
            return 0, self.single_cfg[:w_length]
        try:
            # In composite mode the mux owns the channel; route control through it.
            if self.mux is not None:
                if bm & 0x80:
                    status, data = self.mux.control(setup)
                    return (0, data[:w_length]) if status == 0 else (EPIPE, b"")
                status, _ = self.mux.control(setup, cmd.transfer_buffer)
                return (0, b"") if status == 0 else (EPIPE, b"")
            if bm & 0x80:                    # IN
                data = self.client.control_transfer(setup)
                return 0, data[:w_length]
            else:                            # OUT
                self.client.control_transfer(setup, cmd.transfer_buffer)
                return 0, b""
        except Exception:
            return EPIPE, b""

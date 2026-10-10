"""
Bridge a USB/IP export to the SXUPTP data channel.

Maps the hub's USB devices onto USB/IP busids and turns USBIP_CMD_SUBMIT into
SXUPTP control/bulk transfers via `sxuptp.SxuptpClient`.

Status: control (endpoint 0) transfers are wired to the confirmed SXUPTP path
and work live. Bulk/interrupt endpoints are stubbed (return a stall) until the
bulk reply loop is exercised against hardware — see TODO below.
"""
from __future__ import annotations

import struct

from ..sxuptp.client import SxuptpClient
from ..sxuptp import protocol as sx
from . import protocol as u

# Linux URB status codes (negative errno) we hand back in RET_SUBMIT.status
EPIPE = -32          # stall
EREMOTEIO = -121     # short/other IO error


class Device:
    """One exported hub device: a busid <-> (SXUPTP node, host) pair."""

    def __init__(self, host: str, client_ip: str, device_mac: bytes,
                 node: str, busid: str, busnum: int, devnum: int):
        self.host = host
        self.client_ip = client_ip
        self.device_mac = device_mac
        self.node = node
        self.busid = busid
        self.busnum = busnum
        self.devnum = devnum
        self.client: SxuptpClient | None = None
        self.info: u.UsbipDevice | None = None

    # --- lifecycle ------------------------------------------------------
    def attach(self) -> u.UsbipDevice:
        """Open the SXUPTP channel and read enough descriptors to describe the
        device to USB/IP. Returns the populated UsbipDevice (also cached)."""
        c = SxuptpClient(self.host)
        c.attach(self.node, self.device_mac, self.client_ip)
        c.find_dev_id()                       # resolve the transfer handle
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

        # per-interface class triples from the full config descriptor
        total = (cfg[2] | (cfg[3] << 8)) if len(cfg) >= 4 else 9
        interfaces: list[tuple[int, int, int]] = []
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
                i += blen

        self.info = u.UsbipDevice(
            busid=self.busid, busnum=self.busnum, devnum=self.devnum,
            speed=u.SPEED_FULL, id_vendor=id_vendor, id_product=id_product,
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
        # TODO(bulk/interrupt): map to sx.bulk_read/bulk_write once the bulk
        # reply loop is confirmed live. For now, stall non-control endpoints so
        # the host sees a clean error instead of hanging.
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

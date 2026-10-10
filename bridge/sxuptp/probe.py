"""
SXUPTP probe CLI.

Usage:
  python3 -m bridge.sxuptp.probe --dry-run
      Print the bytes the probe WOULD send (no network). Works with no device.
  python3 -m bridge.sxuptp.probe discover [--broadcast ADDR]
      Broadcast a 'BS' search on UDP 19540 and dump replies.
  python3 -m bridge.sxuptp.probe getdesc HOST
      Connect, attach, and request the device descriptor (needs a device;
      attach is not yet implemented — see SXUPTP_PROTOCOL.md).
"""
from __future__ import annotations

import argparse

from . import protocol as p
from .client import SxuptpClient


def hexdump(b: bytes) -> str:
    return " ".join(f"{x:02x}" for x in b)


def cmd_dry_run() -> int:
    print(f"SXUPTP port: {p.PORT} (TCP+UDP)")
    disc = p.pack_identify()
    print(f"\nJCP identity/discovery request ({len(disc)} B):\n  {hexdump(disc)}")
    raw = p.control_read(dev_id=4, bm_request_type=0x80, b_request=0x06,
                         w_value=0x0100, w_index=0, length=18, seq=1)
    print(f"\ncontrol GET_DESCRIPTOR(device) request ({len(raw)} B):\n  {hexdump(raw)}")
    print(f"  type=0x{raw[0]:02x}{raw[1]:02x} (ctrl-read)  field0x04=0x{raw[4]:02x}{raw[5]:02x}"
          f"  devId={raw[6]}  SETUP @0x0C={hexdump(raw[0x0C:0x16])}")
    print("  (reply: 10-byte header `type seq status _ size`, then `size` data bytes)")
    print("\n(on-wire bytes per the reverse-engineered framing; CONFIRMED live "
          "against 192.168.2.3 — see SXUPTP_PROTOCOL.md)")
    return 0


def cmd_discover(broadcast: str) -> int:
    print(f"JCP identity query (cmd4/0x9506) on UDP {p.PORT} to {broadcast} ...")
    devs = SxuptpClient.discover(target=broadcast)
    if not devs:
        print("no devices found")
        return 1
    for d in devs:
        print(f"\n  {d['from']}  {d['model']}  mac={d['mac']}  fw={d['firmware']}")
        print(f"    proto={d['proto_version']}  host={d['hostname']}")
        print(f"    USB device: {d['usb_device']!r}")
    return 0


def cmd_getdesc(host: str, client_ip: str, node: str | None) -> int:
    """Attach to a device and fetch its USB device descriptor. CONFIRMED live.

    `client_ip` must be a non-gateway IP on the hub's subnet (see attach()).
    """
    # resolve the hub MAC via discovery, and a device node via the device list
    devs = SxuptpClient.discover(target=host)
    if not devs:
        print(f"no device answered discovery at {host}")
        return 1
    mac = bytes(int(x, 16) for x in devs[0]["mac"].split(":"))
    if node is None:
        listed = SxuptpClient.list_devices(host)
        if not listed:
            print("no USB devices listed on the hub")
            return 1
        node = listed[0]["port"]
        print(f"using node {node} ({listed[0]['device']})")

    c = SxuptpClient(host)
    try:
        dev_id = c.attach(node, mac, client_ip)
        print(f"attached (devId announced: {dev_id})")
        desc = c.control_transfer(p.Setup.get_descriptor(1, 0, 18))
        vid = desc[8] | (desc[9] << 8); pid = desc[10] | (desc[11] << 8)
        print(f"device descriptor ({len(desc)} B, devId={c.dev_id}): {hexdump(desc)}")
        print(f"  idVendor:idProduct = {vid:04x}:{pid:04x}")
        return 0
    finally:
        c.disconnect()


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="SXUPTP probe client")
    ap.add_argument("--dry-run", action="store_true",
                    help="print the bytes we would send; no network")
    sub = ap.add_subparsers(dest="cmd")
    d = sub.add_parser("discover")
    d.add_argument("--broadcast", default="255.255.255.255")
    g = sub.add_parser("getdesc")
    g.add_argument("host")
    g.add_argument("--client-ip", required=True,
                   help="a NON-gateway IP on the hub's subnet to connect from")
    g.add_argument("--node", default=None, help="device node devNN (default: first listed)")
    dl = sub.add_parser("devlist")
    dl.add_argument("host")
    args = ap.parse_args(argv)

    if args.dry_run or args.cmd is None:
        return cmd_dry_run()
    if args.cmd == "discover":
        return cmd_discover(args.broadcast)
    if args.cmd == "getdesc":
        return cmd_getdesc(args.host, args.client_ip, args.node)
    if args.cmd == "devlist":
        for d in SxuptpClient.list_devices(args.host):
            print(f"  {d['port']}  {d['device']}")
        return 0
    return 1


if __name__ == "__main__":
    raise SystemExit(main())

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
    disc = p.pack_udp_command(1)
    print(f"\nUDP control command 1 ({len(disc)} B):\n  {hexdump(disc)}")
    setup = p.Setup.get_descriptor(desc_type=1, desc_index=0, length=18)
    msg = p.Message(category=p.CAT_CONTROL, endpoint=0x00, setup=setup)
    raw = msg.pack()
    print(f"\ncontrol GET_DESCRIPTOR(device) message ({len(raw)} B):\n  {hexdump(raw)}")
    print(f"  header type = 0x{raw[0]:02x}{raw[1]:02x} (dir=request, cat=control)")
    print(f"  SETUP @0x0C = {hexdump(raw[0x0C:0x14])}")
    print("\n(these are the on-wire bytes per the reverse-engineered framing; "
          "CONFIRMED for ports/framing/SETUP, see SXUPTP_PROTOCOL.md)")
    return 0


def cmd_discover(broadcast: str) -> int:
    print(f"sending UDP control command 1 on {p.PORT} to {broadcast} ...")
    replies = SxuptpClient.discover(command=1, target=broadcast)
    if not replies:
        print("no replies (no device, or discovery body/format needs adjustment)")
        return 1
    for ip, data in replies:
        print(f"\nreply from {ip} ({len(data)} B):\n  {hexdump(data)}")
    return 0


def cmd_getdesc(host: str) -> int:
    c = SxuptpClient(host)
    c.connect()
    try:
        c.attach(device_id=0)  # not yet implemented
        desc = c.control_transfer(p.Setup.get_descriptor(1, 0, 18))
        print(f"device descriptor ({len(desc)} B): {hexdump(desc)}")
        return 0
    except NotImplementedError as e:
        print(f"attach not implemented: {e}")
        return 2
    finally:
        c.close()


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="SXUPTP probe client")
    ap.add_argument("--dry-run", action="store_true",
                    help="print the bytes we would send; no network")
    sub = ap.add_subparsers(dest="cmd")
    d = sub.add_parser("discover")
    d.add_argument("--broadcast", default="255.255.255.255")
    g = sub.add_parser("getdesc")
    g.add_argument("host")
    args = ap.parse_args(argv)

    if args.dry_run or args.cmd is None:
        return cmd_dry_run()
    if args.cmd == "discover":
        return cmd_discover(args.broadcast)
    if args.cmd == "getdesc":
        return cmd_getdesc(args.host)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())

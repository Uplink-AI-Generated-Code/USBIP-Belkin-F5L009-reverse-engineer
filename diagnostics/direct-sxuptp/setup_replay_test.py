#!/usr/bin/env python3
"""Replay the vendor driver's SCSI setup sequence (which our direct path skips)
BEFORE sustained bulk, to test whether some setup command disarms the hub's
~69s establishment timer. Decoded from Packet_Dumps/1GB_file_write.pcapng:
  INQUIRY, INQUIRY(evpd), READ FORMAT CAPACITIES, READ CAPACITY,
  MODE SENSE(6) x3, MODE SELECT(6) [data-out], READ CAPACITY.
Single TCP connection (direct path never reconnects).
"""
import sys, time, struct, argparse
sys.path.insert(0, "/Users/radu/Code/Claude/Belkin_F5L009_USB_IP_Hub/diagnostics/direct-sxuptp")
import sxuptp_direct as sx

MS_DATA = bytes.fromhex("0000000800000000000002000812040000000000000000000000000000000000")

def scsi(dev, cdb, dlen, out_data=None):
    """One BOT transaction. out_data set => data-OUT (flags 0x00); else data-IN
    (flags 0x80) reading dlen bytes. Returns (status_str, data_in_or_None)."""
    c = dev.client
    flags = 0x00 if out_data is not None else (0x80 if dlen else 0x00)
    try:
        if c.bulk_out(dev._ms_bulk_out, sx._cbw(sx._tag(), dlen, flags, cdb)) != 0:
            return "cbw-reject", None
        data = None
        if out_data is not None:
            if c.bulk_out(dev._ms_bulk_out, out_data) != 0:
                return "data-out-reject", None
        elif dlen:
            st, data = c.bulk_in(dev._ms_bulk_in, dlen)
            if st != 0:
                return f"data-in-bad(st={st})", data
        st2, csw = c.bulk_in(dev._ms_bulk_in, 13)
    except Exception as e:
        return f"EXC/{type(e).__name__}", None
    if st2 != 0 or len(csw) != 13 or csw[:4] != b"USBS":
        return f"csw-bad(st={st2})", data
    return ("ok" if csw[12] == 0 else f"csw-status={csw[12]}"), data


def run_setup(dev):
    seq = [
        ("INQUIRY",        bytes.fromhex("120000002400"), 36, None),
        ("INQUIRY(evpd)",  bytes.fromhex("12018000ff00"), 255, None),
        ("READ FMT CAPS",  bytes.fromhex("2300000000000000fc00"), 252, None),
        ("READ CAPACITY",  bytes.fromhex("25000000000000000000"), 8, None),
        ("MODE SENSE 1c",  bytes.fromhex("1a001c00c000"), 192, None),
        ("MODE SENSE 08a", bytes.fromhex("1a000800c000"), 192, None),
        ("MODE SENSE 08b", bytes.fromhex("1a000800c000"), 192, None),
        ("MODE SELECT",    bytes.fromhex("151000002000"), 32, MS_DATA),
        ("READ CAPACITY2", bytes.fromhex("25000000000000000000"), 8, None),
    ]
    for name, cdb, dlen, out in seq:
        r, _ = scsi(dev, cdb, dlen, out)
        print(f"  setup {name:14s}: {r}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--host", default="192.168.2.3")
    ap.add_argument("--client-ip", default="192.168.2.50")
    ap.add_argument("--mb", type=int, default=170)
    ap.add_argument("--wb", type=int, default=128)
    ap.add_argument("--no-setup", action="store_true")
    args = ap.parse_args()

    salt = int(time.time()) & 0xffffffff
    hub, dev = sx.attach(args.host, args.client_ip, "1-1", 10.0)
    start = sx.gpt_partitions(dev)[1][1]
    if not args.no_setup:
        print("replaying vendor SCSI setup sequence:")
        run_setup(dev)
    print(f"now sustained write {args.mb}MB @ LBA {start}")
    total = args.mb * 1024 * 1024 // sx.BS
    lba = start; written = wi = 0; t0 = time.monotonic()
    crossed = {68: False, 70: False}; wedge = None
    try:
        while written < total:
            nblk = min(args.wb, total - written)
            r = sx.write10(dev, lba, sx.buffer_for(lba, nblk, salt))
            if r != "ok":
                wedge = (sx.mb(written), time.monotonic() - t0, r); break
            written += nblk; lba += nblk; wi += 1
            el = time.monotonic() - t0
            for mk in (68, 70):
                if el >= mk and not crossed[mk]:
                    crossed[mk] = True; print(f"  *** crossed {mk}s at {sx.mb(written)}MB ***")
            if wi % 256 == 0:
                print(f"  {sx.mb(written)}MB  {el:5.1f}s  {written*sx.BS/1e6/el:.2f}MB/s")
        el = time.monotonic() - t0
        if wedge:
            print(f">>> WEDGE at {wedge[0]}MB / {wedge[1]:.1f}s : {wedge[2]}  "
                  f"{'CROSSED-70s' if crossed[70] else 'before 70s'}")
        else:
            print(f">>> COMPLETE {sx.mb(written)}MB in {el:.1f}s, NO wedge "
                  f"-- {'PASSED the ~70s wall' if crossed[70] else 'too short'}")
    finally:
        sx.detach(dev)
    return 0 if not wedge else 1


if __name__ == "__main__":
    raise SystemExit(main())

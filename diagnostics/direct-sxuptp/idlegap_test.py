#!/usr/bin/env python3
"""Does a genuine fully-idle gap mid-stream reset the hub's ~68s RST clock?
Write bulk for `pre` s, go COMPLETELY idle (no SXUPTP traffic at all) for `gap`
s, then resume writing. The timer is armed ~connection-establishment. If the
idle gap resets it, the wedge (if any) moves to ~68s AFTER the gap, not ~68s
after connect; if the connection instead sails to completion, idle resets it.
Single TCP connection (direct path never reconnects).
"""
import os, sys, time, argparse
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))  # portable: this script's dir
import sxuptp_direct as sx


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--host", default="192.168.2.3")
    ap.add_argument("--client-ip", default="192.168.2.50")
    ap.add_argument("--pre", type=float, default=40.0, help="bulk seconds before the gap")
    ap.add_argument("--gap", type=float, default=6.0, help="fully-idle seconds")
    ap.add_argument("--mb", type=int, default=260)
    ap.add_argument("--wb", type=int, default=128)
    args = ap.parse_args()

    salt = int(time.time()) & 0xffffffff
    hub, dev = sx.attach(args.host, args.client_ip, "1-1", 10.0)
    start = sx.gpt_partitions(dev)[1][1]
    print(f"attached; write {args.pre}s, idle {args.gap}s, then resume to {args.mb}MB @ LBA {start}")
    total = args.mb * 1024 * 1024 // sx.BS
    lba = start; written = wi = 0; t0 = time.monotonic()
    did_gap = False; gap_at = None; wedge = None
    crossed = {68: False}
    try:
        while written < total:
            el = time.monotonic() - t0
            if not did_gap and el >= args.pre:
                print(f"  -- idle gap: {args.gap}s of NO traffic at t={el:.1f}s / {sx.mb(written)}MB --")
                time.sleep(args.gap); did_gap = True; gap_at = time.monotonic()
            nblk = min(args.wb, total - written)
            r = sx.write10(dev, lba, sx.buffer_for(lba, nblk, salt))
            if r != "ok":
                el = time.monotonic() - t0
                since_gap = (time.monotonic() - gap_at) if gap_at else None
                wedge = (sx.mb(written), el, since_gap, r); break
            written += nblk; lba += nblk; wi += 1
            el = time.monotonic() - t0
            if el >= 68 and not crossed[68]:
                crossed[68] = True
                print(f"  *** crossed 68s-from-connect at {sx.mb(written)}MB (gap done={did_gap}) ***")
            if wi % 256 == 0:
                print(f"  {sx.mb(written)}MB  {el:5.1f}s  {written*sx.BS/1e6/el:.2f}MB/s")
        el = time.monotonic() - t0
        if wedge:
            sg = f"{wedge[2]:.1f}s after gap" if wedge[2] is not None else "before gap"
            print(f">>> WEDGE at {wedge[0]}MB / {wedge[1]:.1f}s from connect ({sg}) : {wedge[3]}")
        else:
            print(f">>> COMPLETE {sx.mb(written)}MB in {el:.1f}s, NO wedge -- idle gap reset the clock")
    finally:
        sx.detach(dev)
    return 0 if not wedge else 1


if __name__ == "__main__":
    raise SystemExit(main())

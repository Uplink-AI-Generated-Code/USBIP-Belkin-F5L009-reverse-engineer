#!/usr/bin/env python3
"""Does interleaving READ(10)s (hub sends 64KB back) keep the hub from RST-ing
the single TCP data channel at ~68-70s? On a WRITE the hub sends only a 13-byte
CSW; on a READ it sends 64KB, giving its TCP send side RTT samples that reset the
RTO/keepalive timer. The vendor driver's real file copy interleaves reads
(~1 big hub->client segment/sec in the 1GB capture); our write-only tests don't.

Sustained write to the unformatted 2nd GPT partition, one TCP connection (direct
path never reconnects), with a READ(10) every `rd` writes. Reports crossing 70s.
"""
import os, sys, time, argparse
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))  # portable: this script's dir
import sxuptp_direct as sx


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--host", default="192.168.2.3")
    ap.add_argument("--client-ip", default="192.168.2.50")
    ap.add_argument("--mb", type=int, default=170)
    ap.add_argument("--wb", type=int, default=128)      # 64KB writes
    ap.add_argument("--rd", type=int, default=2)         # READ(10) every N writes (0=off)
    ap.add_argument("--rd-wb", type=int, default=128)    # 64KB reads
    args = ap.parse_args()

    salt = int(time.time()) & 0xffffffff
    hub, dev = sx.attach(args.host, args.client_ip, "1-1", 10.0)
    start = sx.gpt_partitions(dev)[1][1]
    print(f"attached; writing {args.mb}MB @ LBA {start}; READ(10) every "
          f"{args.rd if args.rd else 'OFF'} writes ({args.rd_wb*sx.BS//1024}KB)")
    total = args.mb * 1024 * 1024 // sx.BS
    lba = start; written = wi = nr = 0; t0 = time.monotonic()
    crossed = {60: False, 70: False}
    wedge = None
    try:
        while written < total:
            nblk = min(args.wb, total - written)
            r = sx.write10(dev, lba, sx.buffer_for(lba, nblk, salt))
            if r != "ok":
                el = time.monotonic() - t0
                wedge = (sx.mb(written), el, "write:" + r); break
            written += nblk; lba += nblk; wi += 1
            if args.rd and wi % args.rd == 0:
                back = max(start, lba - args.rd_wb)
                d, rr = sx.read10(dev, back, min(args.rd_wb, lba - start))
                nr += 1
                if rr != "ok" or d is None:
                    el = time.monotonic() - t0
                    wedge = (sx.mb(written), el, "read:" + str(rr)); break
            el = time.monotonic() - t0
            for mark in (60, 70):
                if el >= mark and not crossed[mark]:
                    crossed[mark] = True
                    print(f"  *** crossed {mark}s at {sx.mb(written)}MB (reads={nr}) ***")
            if wi % 256 == 0:
                print(f"  {sx.mb(written)}MB  {el:5.1f}s  "
                      f"{written*sx.BS/1e6/el:.2f}MB/s  reads={nr}")
        el = time.monotonic() - t0
        if wedge:
            print(f">>> WEDGE at {wedge[0]}MB / {wedge[1]:.1f}s : {wedge[2]}  (reads={nr})  "
                  f"{'CROSSED-70s' if crossed[70] else 'before 70s'}")
        else:
            print(f">>> COMPLETE {sx.mb(written)}MB in {el:.1f}s, reads={nr}, NO wedge "
                  f"-- {'PASSED the ~70s wall' if crossed[70] else 'too short'}")
    finally:
        sx.detach(dev)
    return 0 if (not wedge) else 1


if __name__ == "__main__":
    raise SystemExit(main())

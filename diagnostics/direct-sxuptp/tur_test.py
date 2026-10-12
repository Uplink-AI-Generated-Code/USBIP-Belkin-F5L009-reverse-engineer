#!/usr/bin/env python3
"""Does a properly-formed TEST UNIT READY (opcode 0x00, cdblen=6) injected ~1Hz
into a sustained write keep the hub from RST-ing at ~68s? The vendor 1GB capture
shows the driver polling TUR once/second during idle stretches, and that
connection lives 447s. (shape_test's TUR was malformed -- cdblen=1 -- so it
never counted.) Single TCP connection (direct path never reconnects).
"""
import os, sys, time, argparse
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))  # portable: this script's dir
import sxuptp_direct as sx


def tur(dev):
    c = dev.client
    cdb = bytes(6)                              # TEST UNIT READY, 6-byte CDB (vendor-exact)
    if c.bulk_out(dev._ms_bulk_out, sx._cbw(sx._tag(), 0, 0x00, cdb)) != 0:
        return "cbw"
    st, csw = c.bulk_in(dev._ms_bulk_in, 13)
    return "ok" if (st == 0 and len(csw) == 13 and csw[:4] == b"USBS") else f"bad(st={st})"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--host", default="192.168.2.3")
    ap.add_argument("--client-ip", default="192.168.2.50")
    ap.add_argument("--mb", type=int, default=170)
    ap.add_argument("--wb", type=int, default=128)
    ap.add_argument("--tur", type=float, default=1.0, help="TUR period s (0=off)")
    args = ap.parse_args()

    salt = int(time.time()) & 0xffffffff
    hub, dev = sx.attach(args.host, args.client_ip, "1-1", 10.0)
    start = sx.gpt_partitions(dev)[1][1]
    print(f"attached; writing {args.mb}MB @ LBA {start}; TUR every "
          f"{args.tur if args.tur else 'OFF'}s (opcode 0x00 cdblen=6)")
    total = args.mb * 1024 * 1024 // sx.BS
    lba = start; written = wi = nt = 0; t0 = time.monotonic(); last_tur = t0
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
            if args.tur and time.monotonic() - last_tur >= args.tur:
                tr = tur(dev); nt += 1; last_tur = time.monotonic()
                if tr != "ok":
                    el = time.monotonic() - t0
                    wedge = (sx.mb(written), el, "tur:" + tr); break
            el = time.monotonic() - t0
            for mark in (60, 70):
                if el >= mark and not crossed[mark]:
                    crossed[mark] = True
                    print(f"  *** crossed {mark}s at {sx.mb(written)}MB (TURs={nt}) ***")
            if wi % 256 == 0:
                print(f"  {sx.mb(written)}MB  {el:5.1f}s  "
                      f"{written*sx.BS/1e6/el:.2f}MB/s  TURs={nt}")
        el = time.monotonic() - t0
        if wedge:
            print(f">>> WEDGE at {wedge[0]}MB / {wedge[1]:.1f}s : {wedge[2]}  (TURs={nt})  "
                  f"{'CROSSED-70s' if crossed[70] else 'before 70s'}")
        else:
            print(f">>> COMPLETE {sx.mb(written)}MB in {el:.1f}s, TURs={nt}, NO wedge "
                  f"-- {'PASSED the ~70s wall' if crossed[70] else 'too short'}")
    finally:
        sx.detach(dev)
    return 0 if not wedge else 1


if __name__ == "__main__":
    raise SystemExit(main())

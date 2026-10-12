#!/usr/bin/env python3
"""Sustained write + verify, direct SXUPTP. Writes N MB of self-identifying
sectors sequentially into the unformatted partition in WRITE(10)s of WB blocks
each, optionally interleaving a READ(10) every RD writes (read-drain), then reads
the region back in paced chunks and reports exactly where (if anywhere) it stops
matching -- distinguishing a clean wedge from silent corruption, with zero Linux.

The knobs that matter for chasing the "Windows works, bridge doesn't" puzzle:
  --timeout  SXUPTP reply timeout (s). Bridge default 3.0. Windows waits ~30.
             If raising this makes writes that used to 'drop' succeed, the
             'degradation' was our impatience, not the hub.
  --wb       blocks per WRITE(10) (128 = 64KB, the vendor's size)
  --rd       read-drain: inject a READ(10) every RD writes (0 = off)
  --pace     extra sleep between writes (s)

    python3 sustain_test.py --mb 128 --timeout 30 --wb 128 --rd 2
"""
import argparse
import time
import sxuptp_direct as sx


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--host", default="192.168.2.3")
    ap.add_argument("--client-ip", default="192.168.2.50")
    ap.add_argument("--busid", default="1-1")
    ap.add_argument("--timeout", type=float, default=10.0)
    ap.add_argument("--part-start", type=int, default=0)
    ap.add_argument("--mb", type=int, default=32)
    ap.add_argument("--wb", type=int, default=128, help="blocks per WRITE(10)")
    ap.add_argument("--rd", type=int, default=0, help="READ every RD writes (0=off)")
    ap.add_argument("--pace", type=float, default=0.0, help="sleep between writes (s)")
    ap.add_argument("--verify", action="store_true", help="read the region back and check")
    ap.add_argument("--salt", type=int, default=-1)
    ap.add_argument('--written', type=int, default=-1)
    args = ap.parse_args()

    salt = args.salt if args.salt != -1 and args.mb == 0 else int(time.time()) & 0xffffffff
    print(f"[sustain] mb={args.mb} wb={args.wb}({args.wb*sx.BS//1024}KB) rd={args.rd} "
          f"pace={args.pace} timeout={args.timeout}s salt={salt}")
    hub, dev = sx.attach(args.host, args.client_ip, args.busid, args.timeout)
    try:
        start = args.part_start
        if not start:
            parts = sx.gpt_partitions(dev)
            if len(parts) < 2:
                raise SystemExit("no 2nd partition found; pass --part-start")
            start = parts[1][1]
        print(f"[sustain] writing into partition @ LBA {start}")

        total = args.mb * 1024 * 1024 // sx.BS
        lba = start
        written = wi = 0
        t0 = time.monotonic()
        while written < total:
            nblk = min(args.wb, total - written)
            r = sx.write10(dev, lba, sx.buffer_for(lba, nblk, salt))
            if r != "ok":
                print(f"[sustain] WEDGE at ~{sx.mb(written)}MB after {wi} writes: {r}")
                break
            written += nblk; lba += nblk; wi += 1
            if args.rd and wi % args.rd == 0:
                _d, _r = sx.read10(dev, lba - nblk, 1)   # read back what we just wrote
                if _r != "ok":
                    print(f"[sustain]  read-drain hiccup ~{sx.mb(written)}MB: {_r}")
            if args.pace:
                time.sleep(args.pace)
            if wi % 128 == 0:
                el = time.monotonic() - t0
                print(f"[sustain]  {sx.mb(written)}MB  {written*sx.BS/1e6/el:.2f} MB/s")
        el = time.monotonic() - t0
        if args.written != -1:
            written = args.written
        else:
            print(f"[sustain] WROTE {sx.mb(written)}MB in {el:.1f}s "
                f"({written*sx.BS/1e6/max(el,1e-6):.2f} MB/s)")
            print(f"{written=}")

        if args.verify and written:
            verify(dev, start, written, salt, delay=args.pace)
    finally:
        sx.detach(dev)


def verify(dev, start, written, salt, delay = 0.1):
    """Read back in small paced chunks (to avoid the sustained-read wedge) and
    report the first sector that doesn't match, or how far a read got."""
    print(f"[verify] reading back in 64KB chunks, {delay}s apart...")
    vblk = 128
    lba = start
    good = 0
    checked = 0
    while checked < written:
        nblk = min(vblk, written - checked)
        data, r = sx.read10(dev, lba, nblk)
        if data is None or len(data) < nblk * sx.BS:
            print(f"[verify] read wedged at +{sx.mb(checked)}MB ({r}); "
                  f"{sx.mb(good)}MB verified before this")
            return
        for i in range(nblk):
            if data[i*sx.BS:(i+1)*sx.BS] != sx.sector(lba + i, salt):
                mlba, msalt = sx.marker(data[i*sx.BS:i*sx.BS+16])
                print(f"[verify] FIRST MISMATCH at +{sx.mb(checked+i)}MB "
                      f"(lba={lba+i}): marker lba={mlba} salt={msalt} (ours={salt})")
                return
            good += 1
        checked += nblk; lba += nblk
        time.sleep(delay)
    print(f"[verify] ALL {sx.mb(good)}MB MATCH")


if __name__ == "__main__":
    raise SystemExit(main())

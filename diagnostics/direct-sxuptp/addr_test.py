#!/usr/bin/env python3
"""Addressing test: write a self-identifying block to several LBAs spread across
the unformatted partition, then read each back. Each block embeds its own LBA,
so a readback of a DIFFERENT LBA's bytes is provable aliasing (addressing bug),
vs. plain garbage (data-path bug), vs. an exact match (correct).

Writes stay inside the unformatted (2nd) GPT partition, so the exFAT partition is
never touched.

    python3 addr_test.py --host 192.168.2.3 --client-ip 192.168.2.50
    python3 addr_test.py --timeout 30 --offsets 0,100,300,500,700,900
"""
import argparse
import time
import sxuptp_direct as sx


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--host", default="192.168.2.3")
    ap.add_argument("--client-ip", default="192.168.2.50")
    ap.add_argument("--busid", default="1-1")
    ap.add_argument("--timeout", type=float, default=10.0,
                    help="SXUPTP reply timeout (s); bridge default is 3.0")
    ap.add_argument("--offsets", default="0,10,50,100,200",
                    help="comma MB offsets into the unformatted partition to test")
    ap.add_argument("--part-start", type=int, default=0,
                    help="override partition start LBA (0 = auto-probe GPT 2nd part)")
    args = ap.parse_args()

    salt = int(time.time()) & 0xffffffff
    hub, dev = sx.attach(args.host, args.client_ip, args.busid, args.timeout)
    try:
        last, blen = sx.read_capacity(dev)
        print(f"attached {args.busid}; READ CAPACITY last_lba={last} block={blen}; "
              f"timeout={args.timeout}s salt={salt}")

        start = args.part_start
        if not start:
            parts = sx.gpt_partitions(dev)
            print("GPT partitions (index: first..last  size):")
            for idx, first, lastp in parts:
                print(f"  p{idx}: {first}..{lastp}  {sx.mb(lastp - first + 1)}MB")
            if len(parts) < 2:
                raise SystemExit("could not find a 2nd (unformatted) partition; "
                                 "pass --part-start explicitly")
            start = parts[1][1]
        print(f"writing into partition starting at LBA {start}\n")

        offs = [int(x) for x in args.offsets.split(",")]
        lbas = [start + mb * 1024 * 1024 // sx.BS for mb in offs]
        blocks = {lba: sx.sector(lba, salt) for lba in lbas}

        print("PHASE 1  write a self-identifying block to each LBA")
        for o, lba in zip(offs, lbas):
            print(f"  +{o:>4}MB lba={lba}: {sx.write10(dev, lba, blocks[lba])}")
            time.sleep(0.2)

        print("\nPHASE 2  read each LBA back; check addressing + integrity")
        ok = alias = bad = 0
        for o, lba in zip(offs, lbas):
            data, r = sx.read10(dev, lba, 1)
            if data is None or len(data) < sx.BS:
                print(f"  +{o:>4}MB lba={lba}: READ FAIL ({r})"); bad += 1
            elif data == blocks[lba]:
                print(f"  +{o:>4}MB lba={lba}: MATCH ({r})"); ok += 1
            else:
                mlba, msalt = sx.marker(data)
                if msalt == salt and mlba in lbas:
                    print(f"  +{o:>4}MB lba={lba}: *** ALIAS -> returned LBA {mlba}'s data ({r})"); alias += 1
                else:
                    print(f"  +{o:>4}MB lba={lba}: GARBAGE head={data[:16].hex()} ({r})"); bad += 1
            time.sleep(0.2)

        print(f"\nRESULT  match={ok}  alias={alias}  garbage/fail={bad}")
        print("  match=all  -> addressing + data path correct")
        print("  alias>0    -> ADDRESSING BUG (wrong LBA served)")
        print("  garbage>0  -> data-path/read failure (not addressing)")
    finally:
        sx.detach(dev)


if __name__ == "__main__":
    raise SystemExit(main())

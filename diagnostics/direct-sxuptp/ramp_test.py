#!/usr/bin/env python3
"""Write-size ramp, all in ONE attach: warm up, then write a few self-identifying
blocks at each WRITE(10) size (1,2,4,...,256 blocks = 0.5KB..128KB) and read them
back, reporting the first size that fails. Tells you the per-command size the hub
tolerates (if any), without the re-attach churn of separate runs.

    python3 ramp_test.py --timeout 30
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
    ap.add_argument("--at-mb", type=int, default=300,
                    help="offset into the partition to write the ramp (MB)")
    ap.add_argument("--reps", type=int, default=4, help="writes per size")
    args = ap.parse_args()

    salt = int(time.time()) & 0xffffffff
    hub, dev = sx.attach(args.host, args.client_ip, args.busid, args.timeout)
    try:
        last, blen = sx.read_capacity(dev)
        print(f"attached; READ CAPACITY last_lba={last} block={blen}; "
              f"timeout={args.timeout}s salt={salt}")
        start = args.part_start
        if not start:
            parts = sx.gpt_partitions(dev)
            if len(parts) < 2:
                raise SystemExit("no 2nd partition found; pass --part-start")
            start = parts[1][1]
        lba = start + args.at_mb * 1024 * 1024 // sx.BS
        print(f"ramp at LBA {lba} (+{args.at_mb}MB into partition @ {start})\n")

        for wb in [1, 2, 4, 8, 16, 32, 64, 128, 256]:
            kb = wb * sx.BS // 1024
            for n in range(args.reps):
                data = sx.buffer_for(lba, wb, salt)
                rw = sx.write10(dev, lba, data)
                if rw != "ok":
                    print(f"  wb={wb:>3} ({kb:>3}KB): WRITE FAIL rep {n}: {rw}")
                    return _ceiling(kb, wb)
                rd, rr = sx.read10(dev, lba, wb)
                if rd is None or len(rd) < wb * sx.BS:
                    print(f"  wb={wb:>3} ({kb:>3}KB): READBACK FAIL: {rr}")
                    return _ceiling(kb, wb)
                if rd != data:
                    bad = next((i for i in range(wb)
                                if rd[i*sx.BS:(i+1)*sx.BS] != sx.sector(lba+i, salt)), -1)
                    print(f"  wb={wb:>3} ({kb:>3}KB): MISMATCH at sub-block {bad}")
                    return _ceiling(kb, wb)
                lba += wb
                time.sleep(0.03)
            print(f"  wb={wb:>3} ({kb:>3}KB): OK  ({args.reps} write+readback cycles)")
        print("\nRAMP COMPLETE: every size up to 128KB tolerated this run.")
    finally:
        sx.detach(dev)


def _ceiling(kb, wb):
    print(f"\n>>> per-WRITE(10) tolerance this run is below {kb}KB ({wb} blocks)")
    print("    (re-run a few times -- on this hub it moves around run to run)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

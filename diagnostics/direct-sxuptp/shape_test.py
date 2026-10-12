#!/usr/bin/env python3
"""Vendor-cadence replay + ablation harness (direct SXUPTP, no Linux).

The hub RSTs a sustained single transfer at ~60-70s (its TCP keepalive/RTO
backoff; see proprietary-Belkin-Silex/analysis/F5L009_v1.2.0/
tcp_connection_and_keepalive.md). The vendor's 128MB write survives ~91s with a
PACED, BIDIRECTIONAL pattern: 64KB WRITE(10) ~20ms apart + interleaved READ(10)
(~1 per 2 writes) + ~1Hz TEST UNIT READY. This harness replays that shape and
lets you ablate each element to find the MINIMAL shape that survives past 60s.

Each element is a knob:
  --wb N        blocks per WRITE(10)          (128 = 64KB, the vendor size)
  --pace S      sleep after each write (s)    (0 = back-to-back; vendor ~0.02)
  --rd N        inject a READ(10) every N writes (0 = off; vendor ~2)
  --rd-wb N     blocks per injected READ(10)  (128 = 64KB)
  --tur S       inject TEST UNIT READY every S seconds (0 = off; vendor ~1)
  --mb N        total MB to write             (default 192, well past the wall)
  --secs S      stop after S seconds even if < mb (0 = until mb or wedge)

Reports throughput, whether it crossed 60s, and the exact wedge point.
Confines writes to the unformatted 2nd GPT partition (exFAT untouched).

Examples:
  # faithful vendor shape (the key test -- does replay survive?):
  python3 shape_test.py --wb 128 --pace 0.02 --rd 2 --tur 1.0
  # ablations:
  python3 shape_test.py --wb 128 --pace 0.02 --rd 2 --tur 0      # drop TUR
  python3 shape_test.py --wb 128 --pace 0.02 --rd 0 --tur 1.0    # drop reads
  python3 shape_test.py --wb 128 --pace 0    --rd 2 --tur 1.0    # drop pacing
  python3 shape_test.py --wb 128 --pace 0    --rd 0 --tur 0      # bulk baseline
"""
import sys, time, struct, argparse
sys.path.insert(0, "/Users/radu/Code/Claude/Belkin_F5L009_USB_IP_Hub/diagnostics/direct-sxuptp")
import sxuptp_direct as sx


def tur(dev):
    """TEST UNIT READY as a raw BOT command on the mass-storage pipe."""
    c = dev.client
    tag = int(time.monotonic() * 1e6) & 0x7fffffff
    cbw = b"USBC" + struct.pack("<I", tag) + struct.pack("<IBBB", 0, 0, 0, 1) + bytes(16)
    try:
        if c.bulk_out(dev._ms_bulk_out, cbw) != 0:
            return "cbw"
        st, csw = c.bulk_in(dev._ms_bulk_in, 13)
    except Exception as e:
        return f"EXC/{type(e).__name__}"
    return "ok" if (st == 0 and len(csw) == 13 and csw[:4] == b"USBS") else f"bad(st={st})"


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--host", default="192.168.2.3")
    ap.add_argument("--client-ip", default="192.168.2.50")
    ap.add_argument("--busid", default="1-1")
    ap.add_argument("--timeout", type=float, default=10.0)
    ap.add_argument("--part-start", type=int, default=0)
    ap.add_argument("--wb", type=int, default=128)
    ap.add_argument("--pace", type=float, default=0.02)
    ap.add_argument("--rd", type=int, default=2)
    ap.add_argument("--rd-wb", type=int, default=128)
    ap.add_argument("--tur", type=float, default=1.0)
    ap.add_argument("--mb", type=int, default=192)
    ap.add_argument("--secs", type=float, default=0.0)
    args = ap.parse_args()

    salt = int(time.time()) & 0xffffffff
    shape = (f"wb={args.wb}({args.wb*sx.BS//1024}KB) pace={args.pace} "
             f"rd={'every '+str(args.rd)+'w' if args.rd else 'OFF'} "
             f"rd_wb={args.rd_wb} tur={str(args.tur)+'s' if args.tur else 'OFF'}")
    print(f"[shape] {shape}; target={args.mb}MB secs={args.secs or '-'}")
    hub, dev = sx.attach(args.host, args.client_ip, args.busid, args.timeout)
    try:
        start = args.part_start or sx.gpt_partitions(dev)[1][1]
        print(f"[shape] writing into partition @ LBA {start}")
        total = args.mb * 1024 * 1024 // sx.BS
        lba = start
        written = wi = nr = nt = 0
        t0 = time.monotonic()
        last_tur = t0
        crossed60 = False
        wedge = None
        while written < total:
            if args.secs and time.monotonic() - t0 >= args.secs:
                break
            nblk = min(args.wb, total - written)
            r = sx.write10(dev, lba, sx.buffer_for(lba, nblk, salt))
            if r != "ok":
                wedge = (sx.mb(written), time.monotonic() - t0, "write:" + r)
                break
            written += nblk; lba += nblk; wi += 1

            if args.rd and wi % args.rd == 0:
                back = max(start, lba - args.rd_wb)       # read a recently-written region
                d, rr = sx.read10(dev, back, min(args.rd_wb, (lba - start)))
                nr += 1
                if rr != "ok" or d is None:
                    wedge = (sx.mb(written), time.monotonic() - t0, "read:" + str(rr))
                    break
            if args.tur and time.monotonic() - last_tur >= args.tur:
                tr = tur(dev); nt += 1; last_tur = time.monotonic()
                if tr != "ok":
                    wedge = (sx.mb(written), time.monotonic() - t0, "tur:" + tr)
                    break
            if args.pace:
                time.sleep(args.pace)

            el = time.monotonic() - t0
            if el >= 60 and not crossed60:
                crossed60 = True
                print(f"[shape] *** crossed 60s at {sx.mb(written)}MB "
                      f"({written*sx.BS/1e6/el:.2f}MB/s, reads={nr} turs={nt}) ***")
            if wi % 256 == 0:
                print(f"[shape]  {sx.mb(written)}MB  {el:5.1f}s  "
                      f"{written*sx.BS/1e6/el:.2f}MB/s  reads={nr} turs={nt}")
        el = time.monotonic() - t0
        if wedge:
            print(f"[shape] >>> WEDGE at {wedge[0]}MB / {wedge[1]:.1f}s : {wedge[2]}  "
                  f"(reads={nr} turs={nt})  {'CROSSED-60s-then-died' if crossed60 else 'before 60s wall'}")
        else:
            print(f"[shape] >>> DONE {sx.mb(written)}MB in {el:.1f}s "
                  f"({written*sx.BS/1e6/el:.2f}MB/s, reads={nr} turs={nt}) -- "
                  f"{'SURVIVED past 60s' if el >= 60 or crossed60 else 'too short to prove'}")
    finally:
        sx.detach(dev)


if __name__ == "__main__":
    raise SystemExit(main())

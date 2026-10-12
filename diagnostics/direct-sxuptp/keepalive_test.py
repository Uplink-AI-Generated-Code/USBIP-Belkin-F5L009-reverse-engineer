#!/usr/bin/env python3
"""DECISIVE test of the UDP-poll re-arm hypothesis (see memory
udp-poll-rearm-trigger): does a periodic GET USB_DEVICE_LIST from the same
client IP keep the hub from RST-ing the single TCP data channel at ~68-70s?

Runs TWO sustained direct writes to the unformatted 2nd GPT partition on ONE
clean hub, back to back:
  1. CONTROL  (no poll)  -- expect the ~70s wedge.
  2. WITH POLL (every `ka` s, vendor full-dump device-list query from client IP
     on a fresh side socket) -- expect it to sail past 70s.
Single TCP connection each (the direct path never reconnects), so crossing 70s
can only mean the timer was re-armed.
"""
import sys, time, socket, threading, argparse
sys.path.insert(0, "/Users/radu/Code/Claude/Belkin_F5L009_USB_IP_Hub/diagnostics/direct-sxuptp")
sys.path.insert(0, "/Users/radu/Code/Claude/Belkin_F5L009_USB_IP_Hub")
import sxuptp_direct as sx
from bridge.sxuptp import protocol as p


def poll_once(host, client_ip):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    try:
        s.bind((client_ip, 0))
        s.settimeout(1.0)
        s.sendto(p.pack_device_list_query(), (host, p.PORT))
        try:
            s.recvfrom(8192)
        except socket.timeout:
            pass
    finally:
        s.close()


def run(host, client_ip, mb, wb, ka, label):
    salt = int(time.time()) & 0xffffffff
    hub, dev = sx.attach(host, client_ip, "1-1", 10.0)
    start = sx.gpt_partitions(dev)[1][1]
    print(f"\n=== {label}: poll={'OFF' if not ka else str(ka)+'s'}; "
          f"target={mb}MB @ LBA {start} ===")
    stop = threading.Event()
    npoll = [0]
    if ka:
        def poller():
            while not stop.wait(ka):
                try:
                    poll_once(host, client_ip); npoll[0] += 1
                except Exception as e:
                    print(f"  [poll] error: {e}")
        threading.Thread(target=poller, daemon=True).start()
    total = mb * 1024 * 1024 // sx.BS
    lba = start; written = wi = 0; t0 = time.monotonic()
    crossed = {60: False, 70: False}
    wedge = None
    try:
        while written < total:
            nblk = min(wb, total - written)
            r = sx.write10(dev, lba, sx.buffer_for(lba, nblk, salt))
            if r != "ok":
                el = time.monotonic() - t0
                wedge = (sx.mb(written), el, r)
                print(f">>> WEDGE at {sx.mb(written)}MB / {el:.1f}s : {r}  "
                      f"(polls sent={npoll[0]})")
                break
            written += nblk; lba += nblk; wi += 1
            el = time.monotonic() - t0
            for mark in (60, 70):
                if el >= mark and not crossed[mark]:
                    crossed[mark] = True
                    print(f"  *** crossed {mark}s at {sx.mb(written)}MB "
                          f"(polls={npoll[0]}) ***")
            if wi % 256 == 0:
                print(f"  {sx.mb(written)}MB  {el:5.1f}s  "
                      f"{written*sx.BS/1e6/el:.2f}MB/s  polls={npoll[0]}")
        el = time.monotonic() - t0
        if not wedge:
            print(f">>> COMPLETE {sx.mb(written)}MB in {el:.1f}s, NO wedge "
                  f"(polls sent={npoll[0]}) -- PASSED the ~70s wall")
    finally:
        stop.set()
        sx.detach(dev)
    return wedge is None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--host", default="192.168.2.3")
    ap.add_argument("--client-ip", default="192.168.2.50")
    ap.add_argument("--mb", type=int, default=160)
    ap.add_argument("--wb", type=int, default=128)
    ap.add_argument("--ka", type=float, default=5.0)
    ap.add_argument("--control-mb", type=int, default=140)
    args = ap.parse_args()
    # 1) no-poll control (expect wedge ~70s)
    run(args.host, args.client_ip, args.control_mb, args.wb, 0, "CONTROL (no poll)")
    time.sleep(3)
    # 2) with-poll (expect pass)
    run(args.host, args.client_ip, args.mb, args.wb, args.ka, "WITH POLL")


if __name__ == "__main__":
    raise SystemExit(main())

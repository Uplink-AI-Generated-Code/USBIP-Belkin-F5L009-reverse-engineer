#!/usr/bin/env python3
"""PROOF: does a periodic GET USB_DEVICE_LIST on the UDP *session* channel keep
the hub from RST-ing the data channel at ~65 s? Attach, start a session-keepalive
thread (default 5 s, like the vendor), and run a sustained write well past the
~110 MB / ~65 s wall. If it sails past, the wedge is a session-idle timeout and
the keep-alive is the fix."""
import sys, time, threading, argparse
sys.path.insert(0, "/Users/radu/Code/Claude/Belkin_F5L009_USB_IP_Hub/diagnostics/direct-sxuptp")
import sxuptp_direct as sx

ap = argparse.ArgumentParser()
ap.add_argument("--host", default="192.168.2.3")
ap.add_argument("--client-ip", default="192.168.2.50")
ap.add_argument("--mb", type=int, default=160)
ap.add_argument("--wb", type=int, default=128)
ap.add_argument("--timeout", type=float, default=10.0)
ap.add_argument("--ka", type=float, default=5.0, help="session keepalive period s (0=off)")
args = ap.parse_args()

salt = int(time.time()) & 0xffffffff
hub, dev = sx.attach(args.host, args.client_ip, "1-1", args.timeout)
parts = sx.gpt_partitions(dev)
start = parts[1][1]
print(f"attached; session-keepalive={'OFF' if not args.ka else str(args.ka)+'s'}; "
      f"writing {args.mb}MB @ LBA {start}; salt={salt}")

stop = threading.Event()
ka_n = [0]
def keepalive():
    from bridge.sxuptp.client import SxuptpClient
    while not stop.wait(args.ka):
        try:
            SxuptpClient.discover(target=args.host, src=args.client_ip, port = 5555)  # identify probe
            hub._list_on_session(retries=1)                             # + list query
            ka_n[0] += 1
        except Exception as e:
            print(f"  [ka] session poll error: {e}")
if args.ka:
    threading.Thread(target=keepalive, daemon=True).start()

total = args.mb * 1024 * 1024 // sx.BS
lba = start; written = wi = 0; t0 = time.monotonic()
wedge = None
while written < total:
    nblk = min(args.wb, total - written)
    r = sx.write10(dev, lba, sx.buffer_for(lba, nblk, salt))
    if r != "ok":
        el = time.monotonic() - t0
        wedge = (sx.mb(written), el, r)
        print(f">>> WEDGE at {sx.mb(written)}MB / {el:.1f}s : {r}  (session polls sent={ka_n[0]})")
        break
    written += nblk; lba += nblk; wi += 1
    if wi % 256 == 0:
        el = time.monotonic() - t0
        print(f"  {sx.mb(written)}MB  {el:5.1f}s  {written*sx.BS/1e6/el:.2f}MB/s  (ka polls={ka_n[0]})")
stop.set()
el = time.monotonic() - t0
if not wedge:
    print(f">>> COMPLETE: wrote {sx.mb(written)}MB in {el:.1f}s with NO wedge "
          f"(session polls sent={ka_n[0]}) -- passed the 65s wall")
sx.detach(dev)

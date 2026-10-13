#!/usr/bin/env python3
"""Reproduce the vendor's IDLE connection and measure how long a SINGLE SXUPTP
data channel survives while idle.

The vendor's 3-minute idle capture keeps ONE connection alive for 192 s while
doing almost nothing (a ~1 Hz TEST UNIT READY); ours wedge at ~69 s. This is the
direct path, so there is NO reconnect -- the survival time is the raw hub lease.

Mechanism (RE'd 2026-10-13, see ../../proprietary-Belkin-Silex/analysis/
F5L009_v1.2.0/tcp_connection_and_keepalive.md): the kill is the SXUPTP "Salc"
watchdog -- an in-flight transfer record whose age exceeds ~5999 ticks (~69 s)
triggers `SXUP_ALC: Send RST!`. The open question is what resets that age; this
harness measures survival under different idle patterns so we can compare.

Idle patterns (--mode):
  tur     ~--hz TEST UNIT READY, CSW drained promptly   [vendor-like, default]
  read    ~--hz READ(10) of one sector (real data in)
  quiet   hold the TCP connection, send NOTHING (detect the RST via select)

Survival is measured two ways, which should agree:
  * client-observed: elapsed until a transfer hits ConnectionResetError (the RST)
  * hub-side (--web-oracle, on by default): the web event log loginfo.htm
    'Host used' -> 'Host not used' span for this client IP (no packet capture
    needed; see the Tier-1 recon notes).

Prereqs: stop the usbip bridge server first (it holds client_ip:19540). If a
previous run wedged a slot, run ./recover.sh (HTTP reboot) before this.

Cleanup: always detaches on exit.
"""
import argparse
import os
import re
import sys
import time
import select
import socket
import http.cookiejar
import urllib.request
import urllib.parse

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))  # portable
import sxuptp_direct as sx


# --------------------------------------------------------------------------
# web event-log oracle (loginfo.htm): hub-side teardown timestamp + host
# --------------------------------------------------------------------------
def web_eventlog(host):
    """Return the event-log rows as (time_str, event, device, pc). Empty on error.
    Login is empty-password (session/IP based)."""
    cj = http.cookiejar.CookieJar()
    op = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cj))
    try:
        op.open("http://%s/en/login/login.htm" % host,
                urllib.parse.urlencode({"login_password": ""}).encode(), timeout=5)
        raw = op.open("http://%s/en/mnt/loginfo.htm" % host, timeout=5).read()
    except Exception:
        return []
    txt = re.sub(rb"<[^>]+>", b" ", raw).decode("latin-1", "replace")
    rows = []
    for m in re.finditer(
            r"(\d\d:\d\d:\d\d)\s+(Host used|Host not used|USB Connect|USB Disconnect)"
            r"\s+(.*?)\s+(\d+\.\d+\.\d+\.\d+|None)", txt):
        rows.append((m.group(1), m.group(2).strip(), m.group(3).strip(), m.group(4)))
    return rows


def _hms(s):
    h, m, sec = (int(x) for x in s.split(":"))
    return h * 3600 + m * 60 + sec


def hub_side_lifetime(host, client_ip):
    """From the event log, the most recent 'Host used'->'Host not used' span for
    client_ip, as (used_time, notused_time, seconds) or None."""
    rows = web_eventlog(host)
    used = notused = None
    for t, ev, _dev, pc in rows:        # rows are newest-first in the page
        if pc != client_ip:
            continue
        if ev == "Host not used" and notused is None:
            notused = t
        elif ev == "Host used" and notused is not None and used is None:
            used = t
            break
    if used and notused:
        d = _hms(notused) - _hms(used)
        if d < 0:
            d += 24 * 3600
        return used, notused, d
    return None


# --------------------------------------------------------------------------
# idle operations on the open channel
# --------------------------------------------------------------------------
_WEDGE_EXC = (ConnectionResetError, ConnectionAbortedError, BrokenPipeError)


def tur(dev):
    """One TEST UNIT READY. Returns (ok, wedged)."""
    c = dev.client
    try:
        if c.bulk_out(dev._ms_bulk_out, sx._cbw(sx._tag(), 0, 0x00, bytes(6))) != 0:
            return False, False
        st, csw = c.bulk_in(dev._ms_bulk_in, 13)
    except _WEDGE_EXC:
        return False, True
    except OSError:
        return False, True
    return (st == 0 and len(csw) == 13 and csw[:4] == b"USBS"), False


def read_one(dev, lba=0):
    try:
        data, reason = sx.read10(dev, lba, 1)
    except _WEDGE_EXC:
        return False, True
    if reason.startswith("EXC/ConnectionReset") or reason.startswith("EXC/BrokenPipe"):
        return False, True
    return (data is not None and reason == "ok"), False


def quiet_wedged(dev, dwell):
    """Hold idle for `dwell` s; return True if the hub RST'd (socket readable
    with error / EOF)."""
    s = dev.client.tcp
    r, _, x = select.select([s], [], [s], dwell)
    if not r and not x:
        return False
    try:
        if s.recv(1) == b"":      # clean EOF (FIN) also ends the session
            return True
    except _WEDGE_EXC:
        return True
    except OSError:
        return True
    return False      # unexpected inbound data, not a teardown


# --------------------------------------------------------------------------
def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--host", default="192.168.2.3")
    ap.add_argument("--client-ip", default="192.168.2.50")
    ap.add_argument("--busid", default="1-1")
    ap.add_argument("--mode", choices=("tur", "read", "quiet"), default="tur")
    ap.add_argument("--hz", type=float, default=1.0, help="idle op rate (tur/read)")
    ap.add_argument("--max", type=float, default=240.0, help="give up after N s (survived)")
    ap.add_argument("--timeout", type=float, default=10.0, help="SXUPTP reply timeout s")
    ap.add_argument("--no-web-oracle", action="store_true", help="skip loginfo.htm cross-check")
    args = ap.parse_args()

    period = 1.0 / args.hz if args.hz > 0 else 1.0
    print("[idle] attaching %s on %s (mode=%s hz=%s) ..."
          % (args.busid, args.host, args.mode, args.hz))
    hub, dev = sx.attach(args.host, args.client_ip, args.busid, args.timeout)
    ann = getattr(dev.client, "announce", None)
    if ann:
        print("[idle] devId=%s (from 0x2908 announce) vid:pid=%04x:%04x"
              % (dev.client.dev_id, ann.get("vid", 0), ann.get("pid", 0)))

    t0 = time.time()
    wedged = False
    n = 0
    try:
        while time.time() - t0 < args.max:
            if args.mode == "quiet":
                if quiet_wedged(dev, min(period, 2.0)):
                    wedged = True
                    break
                continue
            ok, w = tur(dev) if args.mode == "tur" else read_one(dev)
            n += 1
            if w:
                wedged = True
                break
            el = time.time() - t0
            if n % max(1, int(args.hz * 10)) == 0 or not ok:
                print("[idle] t=%6.1fs  ops=%d  last=%s" % (el, n, "ok" if ok else "ERR"))
            dt = period - ((time.time() - t0) % period)
            time.sleep(max(0.0, min(dt, period)))
    except KeyboardInterrupt:
        print("[idle] interrupted")
    finally:
        survival = time.time() - t0
        verdict = ("WEDGED (hub RST)" if wedged
                   else "SURVIVED to --max (no wedge)")
        print("\n[idle] === %s ===" % verdict)
        print("[idle] client-observed survival: %.1fs  (%d ops, mode=%s, single connection, no reconnect)"
              % (survival, n, args.mode))
        sx.detach(dev)
        print("[idle] detached")

    if not args.no_web_oracle:
        time.sleep(1.5)   # let the hub log the teardown
        hs = hub_side_lifetime(args.host, args.client_ip)
        if hs:
            print("[idle] hub event log: Host used %s -> Host not used %s  = %ds (client %s)"
                  % (hs[0], hs[1], hs[2], args.client_ip))
        else:
            print("[idle] hub event log: no matching Host used/not-used span for %s"
                  % args.client_ip)

    # reference points
    print("[idle] reference: our wedge ~69s (sa_age>5999); vendor idle 192s, 1GB 447s")


if __name__ == "__main__":
    main()

# Direct-SXUPTP mass-storage tests

These scripts talk to the flash drive **straight through the bridge's
`SxuptpClient`** — no vhci, no usbip, no Linux block layer, no filesystem, no
page cache. That strips away every Linux-side variable, so whatever you see comes
from only two places: the bridge's SXUPTP protocol code, or the hub/device
itself. Use them to settle *where* the 128 MB write problem actually lives.

Each 512-byte sector we write **embeds its own LBA** plus a per-run salt, so a
readback can tell three outcomes apart:
- **match** — correct data at the correct address;
- **alias** — a *different* LBA's bytes came back → an addressing bug;
- **garbage** — neither → a data-path/read failure.

All writes are confined to the **unformatted 2nd GPT partition** (auto-detected by
reading the GPT off the device). The exFAT partition is never touched.

## ★ The open question — SOLVED (2026-10-13)

> The ~68–70 s "wedge" was the hub's **SXUP_ALC keepalive going unanswered.** The
> hub pings UDP `client_ip:0xC15D` (49501) with `00 04 42 53` (`{len=4}{"BS"}`)
> every ~10 s and the client MUST echo it; a missed echo lets the per-connection
> "Salc" age reach ~5999 ticks (~69 s) and the hub sends `SXUP_ALC: Send RST!`.
> The vendor echoes every ping (so it lives indefinitely); the bridge never bound
> 49501, so it ICMP-rejected each ping and wedged at ~70 s. **Fix:** the Hub now
> runs a `KeepaliveResponder` that echoes the ping. Verified live: a single
> connection survives 600 s idle and a full-rate 128 MB write+verify (3.2 MB/s,
> ALL MATCH), no reconnect. See `../../proprietary-Belkin-Silex/analysis/
> F5L009_v1.2.0/tcp_connection_and_keepalive.md` (★ SOLVED) and
> `idle_survival_test.py`.

The last hypothesis below turned out to be exactly right. The 3 s-timeout
"impatience" theory was a red herring for the ~69 s wedge (it may still matter for
genuinely slow NAND commits — `--timeout` remains the knob). For the record, the
original suspicions were:

- Was the ~69 s drop just the bridge's hard-coded 3 s reply timeout being too
  impatient? (No — it was the missed keepalive; `--timeout` is unrelated.)
- Does a wedge correlate with a *stall* or a hard error? (A clean RST at ~70 s,
  no stall — the keepalive lease expiring.)
- **Compare the bridge's SXUPTP traffic against the vendor capture — look for a
  periodic session keep-alive the bridge omits.** ← this was the one: the `:49501`
  `"BS"` keepalive.

## Setup

1. From the repo root, make sure the **usbip bridge server is NOT running** — it
   holds the SXUPTP sockets on `client_ip:19540`:
   ```bash
   pkill -f "bridge.usbip.server"
   ```
2. Run the scripts with Python 3 (they add the repo root to `sys.path`
   themselves). Defaults assume hub `192.168.2.3`, client IP `192.168.2.50`,
   busid `1-1` (the flash) — override with `--host/--client-ip/--busid`.

## The scripts

| Script | What it answers |
|---|---|
| `addr_test.py`    | Is there an addressing bug? Writes a self-ID block at several offsets, reads each back (match / alias / garbage). |
| `ramp_test.py`    | In one attach, what per-`WRITE(10)` size does the hub tolerate? Ramps 0.5 KB → 128 KB. |
| `sustain_test.py` | How far does a sustained write get, and does read-drain / a longer timeout help? Writes N MB, optional verify. |
| `idle_survival_test.py` | Reproduces the vendor's IDLE connection: holds ONE channel, idles like the vendor (`--mode tur\|read\|quiet`, `--hz`), measures survival both client-side and from the web event log (`loginfo.htm`). Our 1 Hz TUR wedges at ~70 s (vendor idle lives 192 s) — a vendor-like idle pattern does not reset the ~69 s Salc lease. |
| `recover.sh`      | HTTP-reboot the hub to clear a stuck SXUPTP slot after a wedge. |

### Examples

```bash
# 1. Addressing: default offsets, generous timeout
python3 addr_test.py --timeout 30
#    high offsets too:
python3 addr_test.py --timeout 30 --offsets 0,100,300,500,700,900

# 2. Per-write size tolerance (run it a few times; it moves around)
python3 ramp_test.py --timeout 30

# 3. THE timeout experiment -- same write, short vs long timeout:
python3 sustain_test.py --mb 128 --wb 128 --timeout 3   --verify
python3 sustain_test.py --mb 128 --wb 128 --timeout 30  --verify
#    with vendor-style read-drain (a READ every 2 writes):
python3 sustain_test.py --mb 128 --wb 128 --timeout 30 --rd 2 --verify

# After any run that ends in a WEDGE / "no mass-storage endpoints":
./recover.sh
```

## Reading the output

- `sustain_test.py` prints throughput as it goes, then either `WROTE NMB` or
  `WEDGE at ~NMB ... : <reason>`. `<reason>` of `EXC/TimeoutError` means **we hit
  the `--timeout`** — the single most important thing to notice; try a bigger one.
- `--verify` reads the region back in small paced chunks and reports `ALL NMB
  MATCH`, the `FIRST MISMATCH` offset, or where a read itself wedged. (Note:
  sustained *reads* hit the same hub limit as writes, so a verify can wedge even
  when the write was fine — small/paced reads mitigate it.)
- A wedged write leaves the SXUPTP slot stuck; `./recover.sh` clears it.

## What I found (for contrast — please verify, don't trust)

- **No addressing bug.** In a healthy session every offset read back exact
  (match, 0 alias). The one time a readback looked like a "third pattern" it was a
  corrupted write on an already-struggling hub, not aliasing.
- **The protocol code is correct** — attach, READ CAPACITY, READ(10), WRITE(10)
  are byte-exact when they complete.
- **The ~69 s wedge is SOLVED** (see the top of this file): a missed `:0xC15D`
  SXUP_ALC keepalive, now answered by the Hub's `KeepaliveResponder`. It was a
  fixed per-connection lease, not non-determinism and not the 3 s timeout — a
  full-rate 128 MB write+verify and 600 s idle now pass on a single connection.
  (The earlier "non-deterministic / maybe impatience" read was before the
  keepalive was found; the 3 s timeout can still matter for genuinely slow NAND,
  but it was not the wedge.)

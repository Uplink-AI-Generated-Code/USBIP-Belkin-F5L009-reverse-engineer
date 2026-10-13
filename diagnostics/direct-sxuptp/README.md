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

## The open question these are meant to chase

Windows writes 128 MB to this hub reliably, with no reboot, *even right after the
bridge "wedges" it*. That strongly suggests the problem is at least partly **on
our side**, not dead hardware. The prime suspect baked into these tools:

> **The production bridge builds its `SxuptpClient` with a hard-coded 3.0 s reply
> timeout** (`bridge/usbip/backend.py`). A hub that stalls longer than 3 s while
> committing to NAND (exactly when the drive's LED is thrashing) gets declared
> "dropped" — and the re-enumeration that follows makes it worse. Windows'
> mass-storage stack waits ~30 s. So some of my "the hub dropped" verdicts may
> simply be **impatience**.

Every script here takes `--timeout`. **The first experiment to run is the same
sustained write at `--timeout 3` vs `--timeout 30` and see if the "drops"
disappear.** If they do, the fix is in the bridge (raise/retry the timeout,
tolerate a stall), not the hub.

Other things worth a slow look:
- Does a wedge correlate with a *stall* (long ACK) or a hard error? (Watch the
  `[wstat]` trend from the committed `SXBULK_STATS=1` on the real bridge.)
- Does cleanly closing + reopening the SXUPTP session between attempts behave
  differently than our reboot-based recovery? (i.e. is our *recovery* the thing
  leaving the hub in a bad state?)
- Compare the bridge's on-the-wire SXUPTP traffic during a write against the
  vendor capture in `../../Packet_Dumps/` — look for a periodic session
  keep-alive/credit the bridge omits.

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
- **The wedge was non-deterministic** across my runs and independent of offset
  and size — but I ran almost everything at the bridge's default 3 s timeout, so I
  can't rule out that I was simply **timing out on a slow-but-alive hub**. That's
  the hole these tools are built to let you probe. Given Windows' success, I'd now
  bet real money the timeout/recovery behavior is a bigger factor than I credited.

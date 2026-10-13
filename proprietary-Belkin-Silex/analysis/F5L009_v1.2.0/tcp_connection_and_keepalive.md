# F5L009 TCP connection layer & the ~60–70 s keepalive RST

Deep-RE of the hub's TCP stack, done to explain why a *sustained single transfer*
over an SXUPTP data channel (TCP 19540) gets **RST by the hub after ~60–70 s**,
regardless of direction or payload, while the vendor driver's 128 MB transfer
survives ~91 s on one connection. Addresses are in the reconstructed RAM image
(load base `0x0`, Thumb); see [`report.md`](report.md) and
[`ram_reconstruction.md`](ram_reconstruction.md). This is the **TCP layer**,
below the SXUPTPD *job* state machine already noted in
[`management_and_flash.md`](management_and_flash.md) / `ram/symbols.txt`
(`sxuptp_conn_state_machine` @0x302fb0, job state at `job[4]`). The two layers are
distinct: the SXUPTPD job FSM wraps this TCP connection FSM.

## ★ SOLVED 2026-10-13 — the wedge is a missed UDP keepalive on :49501

The ~69 s RST is the hub's **`SXUP_ALC` keepalive** going unanswered. The hub pings
**UDP `client_ip:49501` (= `0xC15D`, the magic `salc_init` writes to `[salc+8]`)
with the 4 bytes `00 04 42 53` (`{len=4}{"BS"}`) every ~10 s**, and the client is
expected to **echo it verbatim** to `host:49501`. Each echo resets the Salc
activity timer; a missed echo lets `sa_age` climb to 5999 ticks (~69 s) →
`SXUP_ALC: Send RST!` → RST (the teardown path below).

Proof (`Packet_Dumps`, UDP `:49501`, both ends on 49501):
- **Vendor (.36):** echoes every ping (`00044253` back, ~1 ms later) → connection
  lives indefinitely (idle 192 s, 1 GB 447 s).
- **Us (.50), before the fix:** no socket on 49501 → ICMP port-unreachable to each
  ping → wedge at ~70 s (7 missed pings × 10 s).

**Fix (verified live, single connection, NO reconnect):** `SxuptpClient` now runs
a keepalive responder that echoes the ping. A/B in one build —
**keepalive ON: survived 150 s (`--max`), 15 pings echoed; OFF: wedged at 70 s,
0 echoed** — event log agreeing both times. This **supersedes** the delayed-ACK /
retransmit correlation (delaying TCP ACKs never made us echo the *UDP* keepalive,
which is why the dnctl test still wedged) and the "what resets `sa_age`" question:
the answer is the :49501 echo. The data-channel reconnect workaround is no longer
needed for liveness. Repro: `diagnostics/direct-sxuptp/idle_survival_test.py`.

Everything below remains accurate as the *teardown plumbing* the missed keepalive
ultimately triggers; only the "what keeps the connection alive" question is now
answered (the :49501 echo), not open.

## SXUPTP job layer — the teardown path (traced 2026-10-13)

Having shown the RST is not an autonomous TCP timer, I traced the layer above.
The data-channel RST is emitted here:

```
sxuptp_conn_close (0x302a44)              "Close job"
   -> tcp_abort_close (0x31a044)          set close flag 0x20000 in [conn+0x128];
                                          dispatch on TCP state (0x318cc8) -> FIN/RST
   -> conn_free (0x3190c8)
```

`conn_close` has **exactly one caller**: the per-job FSM teardown state (state 3)
at `0x30313c`. The FSM (`sxuptp_conn_state_machine 0x302fb0`, jump table
`@0x37b6d4`, states 0..4: 1=connect-pending, 2=OPEN_WAIT, **3=teardown**,
4=ACTIVE) reaches state 3 **reactively** — only when the data-channel socket recv
`tcp_sock_recv (0x316b24)` returns negative (`0x302fee`, `0x303028`). **The ACTIVE
handler has no `get_tick`/lease check — there is no independent job-level ~69 s
watchdog.** (The timestamps that do exist — `[devctx+0xd0]` set at accept,
`[job+0x10]` set at job-alloc — feed the status/uptime string in the discovery
reply `sxuptp_encode_typed_fields`, and the OPEN_WAIT idle-timeout `[job+0xe4]` is
*cleared* when the job goes ACTIVE. None is the active-transfer killer.)

So the wedge reduces to: **what makes `tcp_sock_recv` return negative at ~69 s?**
recv returns negative on (a) the close/abort flag in `[conn+0x128]` (ret −0x23),
(b) a non-ESTABLISHED TCP state {5,6,7} (ret −0x39), or (c) a socket error
(`0x315864`). It also consumes a job-event (`[conn+0x16]` via `0x3159b0`) and
branches specifically on **events 5 and 6** — and **event 6 is exactly what the
TCP per-tick `[conn+0x100]` expiry posts** via `tcp_signal_job_event`
(`0x31945c` → `0x3159d0`). That is the one TCP→job notification that could drive
the teardown without any peer action.

**Open (the real remaining question), stated honestly:** `[conn+0x100]` is the
prime suspect but is **multi-purpose** — it is also written in the
`tcp_output`/retransmit path (`0x3175a0`, `0x317314`) with a computed value, and
`tcp_sock_recv` *zeroes* it on its normal tail (`0x316d4e`). So it is not cleanly
a fixed establishment-armed 69 s countdown, and I will not claim it is one until
its arm value and re-arm conditions are pinned. Static RE keeps bottoming out on
fields like this whose *live* values decide the outcome. Next step is most likely
**dynamic**: watch `[conn+0x100]`/`[conn+0x16]`/`[conn+0x128]` on the live hub
across a vendor transfer vs ours, or instrument the recv return code — rather than
more static tracing. What *is* firmly established: the RST is the SXUPTP job
teardown reacting to a negative recv, not a self-firing TCP timer.

### RESOLVED 2026-10-13 — the 69 s RST is the SXUPTP "Salc" watchdog

Disassembling the `0x308000` SXUPTP allocation layer found the actual trigger.
`sxuptp_salc_watchdog` (`0x308318`) runs **every SXUPTP service tick** (from the
service loop `0x302e64`) and walks the global queue of in-flight **Salc** records
(`SXUP_ALC` = SXUPTP allocations: the CBW/data/CSW transfer records; queue head
`@0x2f02c0`). For each Salc:

- **resend:** if it has been idle `(now − sa_lasttick[+0x10]) > 1000` ticks and
  has not yet been resent (`sa_resent[+0x0c] != 1`), it **re-sends the record at
  the SXUPTP layer** (`0x31a444`/`0x31ae5c`), resets `sa_lasttick`, sets
  `sa_resent=1`. (This is the real retransmit — at the Salc layer, not TCP; it
  explains why inducing *TCP* retransmits via dnctl did nothing.)
- **timeout → RST:** if the record's age `sa_age[+0x14]` exceeds **`0x176f` =
  5999** (≈ 69 s at the shared ~11.5 ms tick), it logs
  `?SXUP_ALC: T/O![%lx]<%I>` then **`SXUP_ALC: Send RST![%lx](%s)`**, sets
  `sj_graceful[job+0xe0]=1`, and calls `sxuptp_job_teardown_by_devctx`
  (`0x302ae0`) which sets `sj_state[job+4]=3`. The FSM then runs teardown →
  `sxuptp_conn_close` → `tcp_abort_close` → **RST**.

So the `recv`-goes-negative path above is *driven by this*: the watchdog flips
the job to teardown, and the socket then reports the close. The `5999` constant is
the long-sought ~69 s lease, and the literal `Send RST!` string is the
confirmation.

**Still open (now a precise, Salc-level question):** what increments `sa_age`
`[salc+0x14]`, and why the vendor avoids reaching 5999 while we don't. The
increment site is register-indirect (not yet pinned statically). Working
hypothesis: a **persistent, never-retired Salc** (e.g. a standing bulk-IN or
interrupt record created at channel setup) ages out at ~69 s *regardless of other
traffic* — which would explain why idle 1 Hz TUR and continuous bulk both wedge
at the same time. Confirm dynamically by watching the Salc queue / `sa_age` on the
live hub (vendor vs ours), or pin the `sa_age` increment and the condition that
resets/retires the Salc. Symbols: [`ram/symbols.txt`](ram/symbols.txt), SXUPTP
"Salc" section.

### Tier-1 live observability recon (2026-10-13) — what the network exposes

Goal: watch the wedge without opening the hub. Findings:

- **Log pipeline (RE'd):** `printf_log` filters by level (`#`=1 err, `!`=2 warn,
  `?`=3 info, none=4 debug) against `active_log_level` (`0x35f1c2`), then
  `putc_logbuf` fans every char to BOTH the console mux `putc_out` (UART) AND a
  RAM ring buffer (`0x2f620c`). The `SXUP_ALC` lines are level 3/4.
- **Port scan** of 192.168.2.3: only **21 (FTP), 23 (telnet), 80 (HTTP), 19540
  (SXUPTP)**. No debug-console socket → CAKE/DISH/SXUPDEB are **UART-only**.
- **FTP** (root / empty password) logs in but the filesystem is empty — not a log
  source.
- **JCP read-only reports over UDP 19540:** `GET CONTEXT`/`MENU_DATA`/`ENUM_DATA`
  return config/enum data (not runtime state); **`EXEC PRINT DIAGNOSTIC` and
  `PRINT CONFIGDATA` return only an 8-byte empty ack** — their output goes to the
  console/log, not the JCP reply. So the printf ring buffer (and `sa_age`) is
  **not reachable over the network**.
- **Web event log** `/en/mnt/loginfo.htm` (login = empty password) is a separate
  **application-level USB event log** — not the printf buffer — but it timestamps
  session lifetimes with the client IP. **It confirms the wedge black-box:**

  | client | `Host used` → `Host not used` | lifetime |
  |---|---|---|
  | **.50 (our bridge)** | 01:52:30 → 01:53:40 | **70 s** |
  | **.50 (our bridge)** | 02:14:14 → 02:15:24 | **70 s** |
  | .36 (Windows vendor) | 02:11:33 → 02:14:02 | 149 s |
  | .36 (Windows vendor) | 01:57:26 → 02:11:25 | ~14 min |

  Our sessions die at a flat ~70 s (= the 5999-tick Salc lease); the vendor's
  don't — exactly the `SXUP_ALC: Send RST!` path, observed from the network.

**Tier-1 conclusion:** the event log is a usable **zero-hardware wedge oracle**
(precise teardown timestamps + host attribution), good enough to run black-box
experiments on *what extends the `Host used` lifetime* (i.e. what resets/retires
the aging Salc) by varying client behaviour and reading session length back. But
to see `SXUP_ALC: Send RST!` directly, or to watch `sa_age` tick, needs the
**UART (Tier 2)** — where the CAKE kernel debugger's memory-examine can read
`[salc+0x14]` live. Tier 3 (JTAG/SWD) is a pipe dream (no equipment).

## RETRACED 2026-10-13 — the wedge is NOT a TCP-layer timer

> A full fresh trace of the state machine (tcp_set_state, tcp_arm_open_timer, the
> 7→8 handshake, all four per-tick countdowns and their expiry handlers, both jump
> tables) **refutes the `[conn+0x114]` "6000-tick" story that every prior version
> of this doc assumed.** No TCP per-tick timer fires an autonomous ~69 s RST on an
> established connection. The killer is above TCP (SXUPTP job watchdog) or on an
> incoming-segment path — not here.

What the code actually does (all verified this pass, addresses below):

1. **`6000` is loaded at exactly ONE site in the whole image** — `0x318ca8`
   inside `tcp_arm_open_timer`, written only to `[conn+0x114]` as the
   **OPEN / SYN_RCVD watchdog** (6000 ticks). (Image-wide scan for the literal
   `0x1770`: one hit.)
2. **It is disarmed at the 7→8 handshake completion.** The state-7 handler
   `0x319938` branches to `0x319790` when the segment has **ACK set AND
   `[sp+0x2c]≠0`** (the ACK acknowledges the SYN-ACK, i.e. acks ISS+1). There
   `0x3197a6` sets `[conn+0x114]=0`, clears retry `[conn+0xfa]`, loads the retry
   limit into `[conn+0xfb]`, calls the RTO estimator `0x317820`, and
   `set_state(8)`. **Any clean client handshake reaches this — ours does.** So
   `[conn+0x114]` is 0 entering ESTABLISHED; the "69 s = 6000 ticks of 0x114"
   arithmetic never applies in ESTABLISHED.
3. **In ESTABLISHED `[conn+0x114]` is only the retransmit countdown (RTO-scale).**
   When it expires, the in-tick sub-table `@0x37f954` dispatches state 8/9 to
   `0x319214`: if `snd.nxt != snd.una` → `0x319504` (retransmit), **else (nothing
   outstanding) with an open window → `0x3194b8` which just CLEARS
   `[conn+0x114]`/`[conn+0xfa]` and stops — no retransmit, no RST.** So on an
   idle/fully-acked connection the retransmit timer *self-cancels*. The only RST
   from here (`0x3193dc`) needs real outstanding data and `[conn+0xfa] ≥
   [conn+0xfb]` retransmits — which our **zero-retransmit** idle captures never
   produce.
4. **The other per-tick countdowns don't RST an idle ESTABLISHED conn either:**
   - `[conn+0x124]` (keepalive-idle, decremented only in states 8/9): on 0 →
     `tcp_send_keepalive_probe 0x31693c`, which **sends nothing if there is no
     unacked data** and **does not re-arm `[conn+0x124]`** → one-shot no-op.
   - `[conn+0x100]` (decremented every tick): on 0 → `0x31945c` (zero `[conn+0x14]`,
     post job-event `0x3159d0(conn,6)`) or `0x319420` (re-arm via `0x339fa0`) or
     fall through — no RST.
   - `[conn+0x136]` (decremented every tick): on 0 → **RST at `0x319368`** — but
     `[conn+0x136]` is **never armed to a nonzero value** anywhere in the image
     (only *cleared*, at `0x318178` in `tcp_timer_sched`), so this path is dead.

**Conclusion:** the ~68–70 s wedge is not emitted by `tcp_keepalive_tick`. Since
it reproduces on a genuinely idle, zero-retransmit connection, the RST is driven
from **above TCP** — most likely the SXUPTP job FSM hitting a lease/inactivity
timeout and calling `sxuptp_conn_close` (`0x302a44`) to tear the socket (which
does `set_state(1)` + RST) — or an incoming-segment validation path in
`tcp_input`. **Next step: trace the SXUPTP job watchdog** (job state `job[4]` /
`sxuptp_conn_state_machine 0x302fb0`, the conn-side idle field `[conn+0xe4]`, the
job-event state `[conn+0x16]` posted by `0x3159d0`, and the establish hook
`0x317a44`), and enumerate every `sxuptp_conn_close` / `tcp_send_segment(r2=4)`
caller reachable without a prior retransmit.

This supersedes the "Status (2026-10-12)" and TL;DR sections below (kept for the
timer-field RE, which is still accurate — only the *attribution of the RST* was
wrong).

## TL;DR (the wedge) — CORRECTED 2026-10-12 after live ablation (SUPERSEDED by the 2026-10-13 retrace above)

> **The earlier "RTT-samples / paced-bidirectional-shape" model below (struck
> through) was REFUTED by live tests on the healthy hub. The wedge is a FIXED
> timer armed at TCP-connection establishment, ~69 s, that NOTHING we do on the
> connection resets. The difference vs the vendor is at connection SETUP /
> establishment, not traffic shape.**

Live results (direct path, single TCP connection, no reconnect — each wedges at
~68–70 s from connect): continuous bulk write 69.2 s; bulk + 5 s UDP device-list
poll 68.4 s; bulk + READ(10) every 2 writes (hub sent ~40 MB) 68.5 s; bulk +
proper 1 Hz TEST UNIT READY 67.4 s; write 40 s + 6 s fully-idle gap + resume
68.9 s; **pure 1 Hz TUR, no bulk at all, 69.8 s**; full vendor SCSI setup replay
(INQUIRY/READ FORMAT CAPACITIES/READ CAPACITY/MODE SENSE×3/MODE SELECT) then
bulk, 69.0 s. Meanwhile the vendor's 1 GB capture is ONE connection living
446.8 s: idle 1 Hz TUR for the first ~80 s (crossing 69 s) then **~345 s of
continuous 3.2 MB/s bulk, no wedge**. Same 1 Hz-TUR traffic survives for the
vendor and dies for us → the connection itself is treated differently, decided at
setup. Not TCP options either (the user's Win7-Python plain-SYN test also wedged).

Firmware: the RST is emitted at **0x3193dc** — `tcp_send_segment(flags=0x4)` via
`0x316458(r2=4)`, `tcp_set_state(1)`, teardown `0x318130(conn,7)`, after the log.
It is reached when the **`[conn+0x114]` retransmit timer exhausts its retry count
`[conn+0xfb]`** (0x31918a→0x3191c2→0x3193dc); each retry doubles the RTO
`[conn+0x118]` (0x3191cc). So the connection dies when the hub has outstanding
sent data whose RTT/ACK condition is never satisfied for ~69 s — fixed, because
it is set up that way, not driven by our subsequent traffic. The exact
connection-struct field the vendor's establishment sets differently is not yet
pinned (register-indirect snd.una advance + runtime limit); see "Open" below.

~~OLD MODEL (refuted): The RST is the hub's TCP keepalive / retransmit-backoff
firing on the ESTABLISHED connection. The backoff RTO `[conn+0x118]` is kept small
by normal TCP RTT measurement; when RTT samples stop arriving, a periodic
keepalive tick doubles `[conn+0x118]` and, when it crosses a runtime limit, logs
`#TCP:KeepAlive T/O` and sends a RST. Under back-to-back bulk the hub stops taking
usable RTT samples, so the RTO backs off → RST. The vendor's paced, bidirectional
pattern keeps RTT samples flowing.~~ (The keepalive/RTO machinery below is real
and correctly described; what is refuted is that *traffic shape* drives it — pure
idle TUR wedges and continuous vendor bulk survives, so RTT-starvation-by-bulk is
not the cause.)

## TCP connection FSM — `tcp_input` @0x319558

Parses the TCP header at `[conn+0x14]+[conn+0x20]` (sport/dport/seq/ack/window via
`get_le16`/`bswap16`/`get_le32`). Connection state is a **byte at `[conn+0xd6]`**
(set by `tcp_set_state` @0x315c... actually `0x3159ec`). For non-SYN segments it
dispatches on state through a **jump table at `0x0037f98c`, index = state-4**:

| state | handler | meaning |
|------:|---------|---------|
| 7 | 0x319938 | SYN_RCVD — SYN-ACK sent; `[conn+0x90]`=hub ISS |
| 8 | 0x3197e6 | ESTABLISHED-entry (transient; disarms the open timer, then → 9 on first data) |
| 9 | 0x31991e | ESTABLISHED data — just processes the segment (`tcp_ack_process` @0x318204) |
| 2,4 | (arm sites) | opening/half-open/teardown — **arm the 6000 open-timer** |
| 10,11,12,13 | 0x319986/70/aca/a66 | FIN/close states (send ACK/FIN-ACK, set 9/10/11/0xd) |

Handshake completion 7→8: in state 7, an ACK with `recv_ack == [conn+0x90]+1`
(i.e. acking the SYN; computed into the local `[sp+0x2c]=1` at 0x3198fc) branches
0x319956 → 0x319790, which **disarms** the 6000 timer (`[conn+0x114]=0` @0x3197a6)
and `tcp_set_state(8)` (@0x3197dc). The first data segment in state 8 → state 9.

### The 6000 "open/teardown" timer — NOT the wedge

`tcp_arm_open_timer` @0x318c98 stores `[conn+0x114]=6000` (lit @0x318cc4) — a flat
countdown (6000 × 10 ms ≈ 60 s). It is armed only in the opening/half-open/teardown
states (2/4, via the arm sites 0x319980/998/ac4/fa0) and **disarmed on reaching
ESTABLISHED (state 8)**. An active data connection has it disarmed, so this timer
is a half-open/teardown guard, **not** the cause of the sustained-transfer wedge.
(It *was* an early red herring.)

## The actual RST: keepalive / RTO backoff — `tcp_keepalive_tick` @0x3190ec

Invoked per-connection from the periodic timer subsystem (via a callback pointer;
no direct `BL`). Per tick it:

1. `[conn+0x118] <<= 1` (0x3191cc) — exponential backoff; compare to the limit
   `*(0x002f2600)` (runtime-configured; 0 in the static image). If exceeded →
   **T/O path** 0x319478:
   - log `#TCP:KeepAlive T/O %SS-%SS` (string @0x37f818),
   - `tcp_send_segment(conn, flags=0x4)` @0x319494 → **RST**,
   - `tcp_set_state(1)`, then teardown `0x318130(conn,7)`.
2. When the hub's send side is idle (`[conn+0x98]==[conn+0x90]`) and/or send
   window `[conn+0x9c]==0`, it emits a keepalive/persist probe.

So the connection dies when `[conn+0x118]` is allowed to double unchecked for the
limit's worth of ticks.

## What keeps it alive: TCP RTT measurement (Jacobson/Karn)

- **Arm** — `tcp_rtt_arm` @0x31642c, called from the send path: sets
  `t_rtt_active = [conn+0xf9] = 1`, `t_rtseq = [conn+0x104] = [conn+0x90]`
  (snd.una), `t_rtt_start = [conn+0x108] = now` (`0x335210`).
- **Measure** — in `tcp_ack_process` @0x318204 (site 0x3187ce): if
  `[conn+0xf9]` (timing active) and `recv_ack >= [conn+0x104]` (timed seq acked),
  call the **RTO estimator** `0x317820`, which recomputes `[conn+0x118]` (RTT math,
  ×100, clamped between runtime min/max) — **resetting the backoff**.
- A second, `[sp+0x2c]`-gated RTO refresh exists in `tcp_input` at 0x319d5e (same
  `recv_ack==[conn+0x90]+1` condition) — relevant mainly around the handshake.

`[conn+0x90]` (snd.una / `t_rtseq`) is written only by init/setup paths found in
the net region (ISS assignment @0x3176ce and @0x319ece, conn-init @0x315bf2); its
per-ACK advance is done register-indirect inside `tcp_ack_process` and was not
pinned to a single instruction here.

## The RST path and the retransmit/keepalive timers (corrected trace, 2026-10-12)

Per `tcp_keepalive_tick` @0x3190ec, each connection (struct stride 0x1a0) has
several per-tick countdowns, processed only for state `[conn+0xd6] > 3`:

- **`[conn+0x124]`** (0x92<<1): 16-bit keepalive-idle countdown, decremented each
  tick **only in ESTABLISHED (state 8/9)** (0x31913c–0x31915e). On reaching 0 →
  `0x3193d4` → `0x31693c` (send a keepalive **probe**, but only if there is
  unacked data: it compares `[conn+0x90]` snd.una vs `[conn+0x98]`), then continue.
- **`[conn+0x100]`** (0x80<<1): another countdown (0x319160); on 0 → `0x31945c`
  path (checks `[conn+0x14]`, `[conn+0x126]` flags).
- **`[conn+0x114]`** (0x8a<<1): the **retransmit** countdown (0x31918a). On 0 it
  clears `[conn+0xf9]`, increments retry counter `[conn+0xfa]`, and compares it to
  the retry limit `[conn+0xfb]`:
  - retries left → `0x3191c4`: **double the RTO** `[conn+0x118]` (0x3191cc,
    `r3<<1`) vs limit, re-arm, retransmit.
  - retries exhausted → **`0x3193dc` = the RST/teardown** (see TL;DR): set RST
    flag via `0x316458(r2=4)`, copy `[conn+0x98]→[conn+0x94]`, `tcp_set_state(1)`,
    `0x337598`, teardown `0x318130(conn, 7)`.

`tcp_timer_sched` @0x318130 is the timer-wheel arm/cancel helper (`r1`=type: 5 arm,
7 teardown; manages `[conn+0x14]` pending slot and flags at `[conn+0x126]`/0x134/
0x136). Timers are (re)armed through `0x339fa0`.

So the wedge = the **retransmit timer giving up** (~69 s of RTO backoff over
`[conn+0xfb]` tries) on sent data whose ACK condition is never met — OR the
keepalive countdown expiring to a probe that is then retransmit-exhausted. Either
way it is armed at establishment and, per live ablation, **not reset by any
amount of our bulk / reads / TUR / idle / UDP / SCSI-setup activity**.

## RTT/RTO is refreshed ONLY at handshake + keepalive probe — never by data (2026-10-12)

`tcp_rtt_arm` @0x31642c (sets `[conn+0xf9]=1`, `t_rtseq[0x104]=snd.una[0x90]`,
`t_rtt_start[0x108]=now`) has exactly **three callers**, all non-data:
- **0x3176f0** — the SYN send / active-open path (ISS written to 0x90/0x94/0x98, set_state 3→6, `tcp_send_segment(r2=2)`=SYN).
- **0x319f08** — the SYN-ACK path (`tcp_send_segment(r2=0x12)`=SYN-ACK, set_state 7).
- **0x31691e** — inside the keepalive-probe path (near `tcp_send_keepalive_probe` @0x31693c).

**There is no `tcp_rtt_arm` on the ordinary data-send path.** So the hub takes an
RTT sample (and runs the RTO estimator `0x317820`) only at connection setup and
when it sends a keepalive probe — *never* from CSWs / read data / bulk. This is
why no amount or shape of data traffic resets the RTO: by design it can't.

The RTO-reset gate in `tcp_ack_process` @0x3187a6→0x3187ce fires only if **all**:
`[conn+0xf9]` (t_rtt_active) ≠ 0, a local flag `[sp+0x3c]` ≠ 0, and signed
`recv_ack >= t_rtseq[0x104]` (bpl @0x3187c6) → `bl 0x317820`.

`[conn+0x114]` is the 6000-count timer set by `tcp_arm_open_timer` at open (6000
ticks ≈ 69 s) AND the ESTABLISHED retransmit countdown; `tcp_keepalive_tick`
decrements it only when non-zero (0x31918a: `cmp #0; beq skip`). The doc section
above says it is **disarmed (set 0) at the 7→8 handshake transition** (0x3197a6,
gated `recv_ack==[conn+0x90]+1`). Our wedge connection *does* ACK ISS+1
(`ack 93` vs hub ISS 92 in wedge.pcap), so on paper it should be disarmed — yet
we die at ~69 s = exactly 6000 ticks. So the hinge is one of: (a) the 7→8 disarm
does not actually land for us, or (b) `[conn+0x114]` is re-armed to 6000 (not a
small RTO) once in ESTABLISHED and our ACKs never cancel it. Pinning which — the
cancel-on-ACK of `[conn+0x114]` and the exact 7→8 path — is the remaining work.
Timer arm/cancel goes through `tcp_timer_sched` @0x318130 (r1: 5=arm, 7=cancel);
`tcp_ack_process` only calls it (type 7) on its RST paths (0x31889c), not on a
normal in-window ACK — consistent with normal ACKs NOT cancelling `[conn+0x114]`.

## Status (2026-10-12): correlation found, but the "retransmit re-arm" theory is REFUTED

**Observation (robust):** the vendor keeps a connection alive with **delayed ACKs
(~140 ms) that trigger a hub CSW retransmit roughly every poll**; our clients ACK
instantly and never trigger a retransmit. Captures:
`Packet_Dumps/3-minute_idle_flash_drive.pcapng` (vendor idle 192 s, delayed ACK +
hub retransmit every cycle) vs `scratchpad/ours_tur.pcap` (our 1 Hz TUR, instant
ACK, zero retransmits, wedge 70.4 s).

**But a hub retransmit is NOT what re-arms the timer.** Validation (`dnctl` 160 ms
egress delay on the macOS host → our ACKs arrive ~160 ms late → hub retransmits):
our delayed connection `192.168.2.50:62970` took **35 hub-retransmits spread
evenly from 1.4 s to 69.0 s (max gap 2.7 s)** and STILL RST at 70.4 s. If a
retransmit refreshed `[conn+0x114]`, those 35 would have kept it alive. They did
not. (Confounds in that run: the blanket delay also broke our OPEN_WAIT handshake
— many 0.3 s RST'd attach attempts — and the Windows VM's bridged traffic bypasses
macOS dummynet, so the `.36` 258 s survival in that capture is just the normal
driver, not our delay.)

So the delayed-ACK/retransmit is a *correlate* of the vendor's survival, not the
mechanism. The wedge remains the `[conn+0x114]` 6000-tick (~69 s) countdown; what
actually keeps it from completing on the vendor connection is still unknown.

**Narrowed firmware question:** `[conn+0x114]=6000` is set while opening (state
4) and **disarmed at the 7→8 transition** — the state-7 handler (0x319938) jumps
to 0x319790 when the arriving segment has ACK set AND `[sp+0x2c]≠0`
(recv_ack == snd.una+1, i.e. it acks the SYN); 0x3197a6 then zeroes
`[conn+0x114]`, clears retry `[conn+0xfa]`, and `set_state(8)`. Our clean
handshake *does* ACK ISS+1, so this should fire — yet we still die at ~6000
ticks. Either the disarm doesn't actually land for us (state/timing of the
state-7 handler), or `[conn+0x114]` is re-armed to 6000 after ESTABLISHED. Static
RE can't see the live state; next step is dynamic (read the hub's live per-conn
TCP state/timer via its telnet/debug surface) or re-examine the SXUPTP
CONNECT→accept→state-4/7/8 progression for how our connection differs.

## (Historical) Open: what the vendor's establishment does that ours doesn't

Live evidence says the difference is at connection setup, not traffic shape, and
not TCP options (Win7-Python plain SYN wedges). Candidates still to pin by RE:
1. Whether our connection properly completes **7→8→9** and the RTO gets its
   handshake-time refresh (0x319d5e, gated by `recv_ack==[conn+0x90]+1`); if that
   refresh never lands, `[conn+0x118]` may start at a value that backs off to the
   limit in ~69 s regardless of data.
2. The register-indirect **snd.una (`[conn+0x90]`) advance** inside
   `tcp_ack_process` and whether our ACKs satisfy `recv_ack >= [conn+0x104]`
   (t_rtseq) to trigger the RTO-reset estimator `0x317820`. If they never do, the
   RTO is never reset and the retransmit timer always wins at ~69 s.
Both require pinning the snd.una/t_rtseq arithmetic that earlier RE left
register-indirect. The next empirical lever is the client-side handshake (e.g. a
plain SYN with no timestamps/ECN, matching the vendor) — previously deprioritised
but back in scope now that the cause is localized to establishment.

~~OLD working model (refuted — see TL;DR): back-to-back bulk coalesces ACKs and
starves RTT samples, paced bidirectional keeps them flowing.~~

## Key field offsets (per TCP connection struct, stride 0x1a0)

Names assigned by this project (see [`ram/symbols.txt`](ram/symbols.txt) for the
full struct glossary, including the SXUPTP job struct); "?" = unverified.

| offset | name | meaning |
|-------:|------|---------|
| 0x14 | `t_segbuf` | current RX segment buffer (TCP header at `t_segbuf+t_hdroff`) |
| 0x16 | `t_jobevent` | event code posted to the owning SXUPTP job (5/6 seen) |
| 0x20 | `t_hdroff` | TCP-header offset within `t_segbuf` |
| 0x90 | `snd_una` | oldest unacked seq / RTT-timed seq base; = ISS at setup |
| 0x94, 0x98 | `snd_nxt`, `snd_max` | send-seq pointers; = ISS at setup |
| 0x9c | `snd_wnd` | peer's receive window |
| 0xc0 | `rcv_nxt` | next expected receive seq |
| 0xd6 | `t_state` | **connection state byte** (FSM state; jump index = state−4) |
| 0xd7 | `t_prevstate` | previous state (saved by `tcp_set_state`) |
| 0xd8 / 0xdc | `t_rxseq` / `t_rxack` | last received seq / ack |
| 0xec | `t_job` | back-pointer to the owning SXUPTP job |
| 0xe4 (job) | `sj_openwait_to` | OPEN_WAIT idle-timeout (0 = disabled once ACTIVE) |
| 0xf9 | `t_rtt_active` | RTT timing in progress |
| 0xfa / 0xfb | `t_rxtshift` / `t_rxtmax` | retransmit retry counter / limit (`t_rxtshift ≥ t_rxtmax` → RST @0x3193dc) |
| 0x100 | `t_timer_100` | per-tick countdown; expiry posts job-event 6 (0x31945c). **Multi-purpose** (also written by `tcp_output`/retransmit, zeroed by recv tail) — role as a fixed lease not proven |
| 0x104 | `t_rtseq` | sequence being RTT-timed |
| 0x108 | `t_rtt_start` | RTT start timestamp (from `0x335210`) |
| 0x114 | `t_timer_rexmt` | **retransmit countdown** (0x8a<<1); on 0 → retransmit (double `t_rto`) or, retries spent, RST @0x3193dc. **Also the 6000 OPEN watchdog while opening; disarmed at the 7→8 transition.** |
| 0x118 | `t_rto` | **RTO / backoff counter**, doubled per retransmit (0x3191cc); reset by the RTT estimator `0x317820` when an ACK covers `t_rtseq` |
| 0x124 | `t_timer_keepidle` | **keepalive-idle countdown** (0x92<<1); decremented per tick in ESTABLISHED; on 0 → keepalive probe `0x31693c` |
| 0x126 | `t_timerflags` | timer/flags half-word (bits tested by the scheduler @0x318130) |
| 0x128 | `t_flags` | conn flags word: `0x20000` closing (set by `tcp_abort_close`), `0x4000` keepalive-probe pending, bit15 waiter-present |
| 0x134 / 0x136 | `t_closestate` / `t_timer_dead` | close/retry state byte + a per-tick countdown → RST @0x319368 that is **never armed** (dead path) |

## Tooling

Disassembled with capstone (`pip install capstone` in a venv) over
`ram_reconstructed.bin` (load base 0x0, Thumb LE). Branch/BL targets decoded
manually where linear disasm desynced over data/literal pools.

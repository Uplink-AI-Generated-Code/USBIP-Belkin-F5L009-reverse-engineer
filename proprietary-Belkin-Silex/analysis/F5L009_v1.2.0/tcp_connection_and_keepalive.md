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

## TL;DR (the wedge) — CORRECTED 2026-10-12 after live ablation

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

## Open: what the vendor's establishment does that ours doesn't

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

## Key field offsets (per TCP connection struct)

| offset | meaning |
|-------:|---------|
| 0x14 | packet buffer base (TCP header at `[0x14]+[0x20]`) |
| 0x90 | snd.una / RTT-timed seq base (`t_rtseq` source); = ISS at setup |
| 0x94, 0x98 | send-seq pointers (snd.nxt / snd.max); = ISS at setup |
| 0x9c | send window |
| 0xc0 | rcv.nxt |
| 0xd6 | **connection state byte** (FSM state; jump table index = state-4) |
| 0xe4 | idle-timeout for OPEN_WAIT jobs (0 = disabled once active) |
| 0xf9 | `t_rtt_active` (RTT timing in progress) |
| 0xfa / 0xfb | retransmit **retry counter** / retry **limit** (0xfa≥0xfb → RST @0x3193dc) |
| 0x100 | per-tick countdown (0x80<<1); on 0 → 0x31945c |
| 0x104 | `t_rtseq` (sequence being RTT-timed) |
| 0x108 | `t_rtt_start` (timestamp, from `0x335210`) |
| 0x114 | **retransmit countdown** (0x8a<<1); on 0 → retransmit (double 0x118) or, retries spent, RST @0x3193dc. (Also used as the 6000 open-timer while opening; disarmed at ESTABLISHED.) |
| 0x118 | **RTO / backoff counter**, doubled per retransmit (0x3191cc); reset by the RTT estimator `0x317820` when an ACK covers `t_rtseq` |
| 0x124 | **keepalive-idle countdown** (0x92<<1); decremented per tick in ESTABLISHED; on 0 → keepalive probe `0x31693c` |
| 0x126 | timer/flags half-word (bits tested by the scheduler @0x318130) |
| 0x134/0x136 | close/retry state byte + a secondary countdown |

## Tooling

Disassembled with capstone (`pip install capstone` in a venv) over
`ram_reconstructed.bin` (load base 0x0, Thumb LE). Branch/BL targets decoded
manually where linear disasm desynced over data/literal pools.

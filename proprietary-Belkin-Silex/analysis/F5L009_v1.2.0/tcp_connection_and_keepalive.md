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

## TL;DR (the wedge)

The RST is the hub's **TCP keepalive / retransmit-backoff** firing on the
ESTABLISHED connection. The backoff RTO `[conn+0x118]` is kept small by normal
**TCP RTT measurement**; when RTT samples stop arriving, a periodic keepalive tick
**doubles** `[conn+0x118]` each tick and, when it crosses a runtime-configured
limit, logs `#TCP:KeepAlive T/O` and **sends a RST** (TCP flag `0x4`). Under
back-to-back bulk (pure read *or* pure write) the hub stops taking usable RTT
samples, so the RTO backs off to the limit → RST at ~60–70 s. The vendor's
**paced, bidirectional** pattern keeps RTT samples flowing, so its RTO never backs
off. (Confirmed live: `tcpdump` of our own wedge shows the hub ACKing our data
with a healthy non-zero window and then sending a bare RST ~5 ms after a normal
ACK — a clean application-level reset, not flow control.)

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

## Why bulk wedges and the vendor survives (working model)

RTT samples require the hub to time a sent segment and then receive a clean ACK
covering it (Karn: no sample during retransmit / with the pipe kept full). Our
**back-to-back bulk** keeps data in flight and coalesces ACKs, so usable samples
stop → RTO backs off → keepalive RST at the limit (~60–70 s). The vendor's
**paced (~20 ms) bidirectional** 64 KB-write + interleaved-READ(10) + ~1 Hz
TUR pattern produces a steady stream of clean, individually-acked, timeable
exchanges → RTO stays low → no keepalive RST. Empirically, a sustained pure READ
(160 MB @2.12 MB/s) and a sustained pure WRITE both RST at ~68 s; a client-side
paced read also wedges — so the required shape is paced **and** bidirectional, not
pacing alone. The exact minimal shape is best pinned by replaying the vendor's
cadence and ablating it (pacing / reads / TUR) rather than by further static RE of
the register-indirect snd.una + runtime limit.

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
| 0x104 | `t_rtseq` (sequence being RTT-timed) |
| 0x108 | `t_rtt_start` (timestamp, from `0x335210`) |
| 0x114 | 6000 open/teardown countdown timer |
| 0x118 | **RTO / keepalive backoff counter** (doubled per keepalive tick) |
| 0x134/0x136 | close/retry state byte + a secondary countdown |

## Tooling

Disassembled with capstone (`pip install capstone` in a venv) over
`ram_reconstructed.bin` (load base 0x0, Thumb LE). Branch/BL targets decoded
manually where linear disasm desynced over data/literal pools.

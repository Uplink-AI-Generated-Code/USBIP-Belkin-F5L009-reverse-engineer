# SXUPTP protocol — reverse-engineering notes (living document)

Derived statically from the reconstructed F5L009 RAM image
(`analysis/F5L009_v1.2.0/ram_reconstructed.bin`, base `0x0`, Thumb). **Incomplete
and partly inferred** — addresses and claims are updated as RE proceeds.
Confidence is noted per item.

SXUPTP = Silex USB Peripheral/Print Transport Protocol, the proprietary scheme
the device server uses to tunnel USB over IP to the Silex "SX Virtual Link"
client. Three code layers are visible in the firmware:

- **`SXUP_ALC`** — allocation / discovery / keepalive channel (`Salcq` queue,
  "Recv task", "No reply", "T/O"). Likely the UDP discovery + session-allocation
  path.
- **`SXUPTPD`** — the per-connection daemon: `Open(Req) from %I`, job state
  machine (`suj_state -> CLOSEREQ`), `Send RST`. Likely the TCP data channel.
- **`VP_SXUP` / `USBUPTP`** — the USB virtualization layer: endpoint I/O
  (`intr-in`, `Isoc remain data`), device/descriptor handling, sub-driver bind.

## Confirmed so far

### ALC receive framing (from `sub_00308464`, the "Recv task")

The ALC receive loop reads a **4-byte header**, big-endian:

```
offset 0: u16 length    ntohs(); validated == 4   (else "?SXUP_ALC: Recv! Error Len[%d]")
offset 2: u16 rule      ntohs(); the opcode/RuleNo (else "?SXUP_ALC: Recv! Error RuleNo[%x]")
```

- Parsed via `get_le16` (`sub_003362c4`) then `bswap16` (`sub_0033628c`) = `ntohs`.
- Confidence: **high** (read directly).
- In this handler the accepted rule compares against `0x4253`; the full opcode
  set comes from the `SXUPTPD` dispatch (milestone 2). Interpretation of
  `length == 4` vs a version/magic is still open.

### Socket primitives (names provisional)

| Addr | Provisional role | Evidence |
|---|---|---|
| `sub_0031afac` | `recv`/`recvfrom` (hdr) | called with (sock, buf, len=4, …); loops until >0 |
| `sub_0031acd8` | `recv` (body) | reads remaining payload into two buffers |
| `sub_00312f5c` | buffer init/reset | zeroes a buffer struct before each recv |
| `sub_00312fa0` | body parse/commit | called after a valid packet |
| `sub_00334734` | TCB enqueue / send | labeled in core-lib pass |
| `sub_003347d8` | TCB send/flush | labeled in core-lib pass |

Socket context structs referenced: `0x002F01E0`, `0x002F0240` (hold the socket
handle + recv buffer pointer). Tracing their initialization gives the bound
port (milestone 1).

## Open questions (next RE targets)

1. **Ports** — which UDP port the ALC channel binds, which TCP port `SXUPTPD`
   listens on. Hypothesis: Silex uses **19540**; confirm from the socket setup.
2. **Opcode table** — enumerate RuleNo values and their meaning from the
   `SXUPTPD` dispatch at `~0x302xxx` (`Open(Req)` handler).
3. **Job state machine** — the `suj_state` transitions (OPEN/…/CLOSEREQ) and the
   attach handshake a client must perform.
4. **USB transfer encoding** — how `VP_SXUP`/`USBUPTP` frames descriptors, setup
   packets, and bulk/interrupt/isoc data.

## Method notes

- Load `ram_reconstructed.bin` at base `0x0`, Thumb; import
  `analysis/F5L009_v1.2.0/ram/symbols.txt` to get the libc names, then rename
  outward from the SXUPTP strings.
- The SX-2000U2 v2.1.5 image has a richer `USBUPTP` sub-driver layer; once the
  v1.2.0 protocol is understood, diff against SX for the newer message set.

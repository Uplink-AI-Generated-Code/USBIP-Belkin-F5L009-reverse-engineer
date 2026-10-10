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

## Transport map (Milestone 1 — confirmed)

SXUPTP uses **port 19540** (`0x4C54`) on **both TCP and UDP** — matching the IANA
registration of `sxuptp` (TCP+UDP 19540, since 2002). Confirmed in firmware at
three sites that load the constant `0x00004C54`:

| Channel | Transport | Role | Evidence (RAM addr) |
|---|---|---|---|
| Data / "job" | **TCP 19540** | per-connection SXUPTP session (`SXUPTPD`) | accept demux `0x2FF410` (port==19540 → `sub_00302948`); handler `0x302DA6` stores 19540 into conn struct `+0x2C` and logs `Open(Req) from %I` |
| Discovery / ALC | **UDP 19540** | datagram discovery / allocation / keepalive | `0x303090` builds a sockaddr on port 19540 and `sendto`s via `sub_0031AE5C`; `SXUP_ALC` recv task `0x308464` reads datagrams |

The **TCP listener multiplexes by port**: in the accept handler (`0x2FF410`),
port 19540 → SXUPTP (`sub_00302948`), port 80 → HTTP (checked immediately after).
This corroborates the mapping (HTTP is known to be on 80).

### Transport / socket API (provisional names)

| Addr | Role |
|---|---|
| `sub_00302948` | **SXUPTP TCP connection setup/dispatch** (entry for an accepted :19540 conn) — Milestone 2 target |
| `sub_00302924` | SXUPTP connection teardown/helper |
| `sub_0031AE5C` | UDP `sendto` (discovery replies) |
| `sub_0031AFAC` / `sub_0031ACD8` | datagram/stream `recv` |
| `sub_00334B6C` | TCB operation (listen/queue) |
| `sub_00335210` | tick / millisecond timer (used for `*10[msec]` timeouts) |

Connection/job struct (pointed by `r4` in the handler): port at `+0x2C`,
peer-IP/context around `+0x28`, state at `+0x04`.

## Framing & opcodes (Milestone 2 — partial)

### Discovery / ALC opcodes (UDP 19540) — confirmed

Datagram header is `{u16 length, u16 rule}` big-endian (via `ntohs`). The rule is
a **2-character ASCII tag**; two are compared in the discovery code:

| Rule | Hex | Where | Meaning (inferred) |
|---|---|---|---|
| `"BS"` | `0x4253` | `0x308508` (ALC recv task) | broadcast search / discovery request |
| `"BB"` | `0x4242` | `0x3091F8` | discovery/announce variant |

These are the only ASCII-tag comparisons in the SXUPTP region, so the discovery
vocabulary is small. The first field was validated `== 4` for the `"BS"` packet
(a fixed body length for that request).

### Attach / open flow (TCP 19540) — confirmed (overlaps Milestone 3)

`sub_00302948` (entry for an accepted :19540 connection) matches the connection
to a **pre-allocated job**:

- Job table: base `0x2F00A0`, count at `0x2F00C0`, **stride `0xE8`** per job.
- Match criterion: `job[+0]!=0` AND `job[+4]==2` (OPEN_WAIT) AND
  `job[+0x28] == conn[+0x64]` (the device/port id the client asked for).
- On match: job state `[+4] 2→4` (active), bind TCP conn at `job[+0xC]`, set
  socket opts (`sub_0031592C`, `sub_0031A2B8(conn,5)`), log `Open job[%lx/%s]`
  and `Open[%lx] from %I:%d`, then start the data pump (`sub_0030817C` /
  `sub_00303F90`).
- So a client must first get a job into OPEN_WAIT (via UDP discovery/allocation),
  then TCP-connect; the id at `conn+0x64` selects which USB device.

### Message records — partial

Outbound messages are built as ~`0x40`-byte job records (`sub_00303C70`) with a
per-message **sequence/transaction counter** (`sub_00303C00` global, incremented
each message), a timestamp, a connection id at `+0x48`, and a flag at `+0x4C`,
then queued/sent via `sub_003039CC(port, 1, buf+8, 0x40)`.

### TCP data-channel message frame — DECODED (from `sub_0030481C`)

`sub_0030481C` is the SXUPTP message parser on the TCP data channel. It copies a
**24-byte (`0x18`) big-endian header** off the stream (`sub_0032CD2C`) and parses
it with `ntohs`/`ntohl` (`get_le16`+`bswap16` = `0x3362C4`/`0x33628C`; 32-bit via
`0x3362E0`/`0x33629C`).

Wire header (offsets confirmed from the parse order; field *names* inferred):

```
+0x00  u16  type        message type / function
+0x02  u16  tag         transfer tag / handle (inferred)
+0x04  u16  field2      (inferred)
+0x06  u8   flags
+0x07  u8   endpoint    low nibble = EP number; bit7 = direction (IN)
+0x08  u16  field3
+0x0A  ...              (header is 0x18 bytes total)
+0x0C  ...              for a control request: USB SETUP packet (see below)
```

**`type` field** = `(dir << 8) | category` (big-endian u16 at `+0x00`):

- **`dir`** (high byte): `0x00` = request (host→device), `0x80` = response /
  data-IN (device→host). Hence the 0x8001–0x8004 forms.
- **`category`** (low byte) selects the transfer kind. The dispatcher
  (`0x3048F8`+) routes by category; 2/3/4 converge on one data-transfer engine at
  `0x304904`, differing only by minimum header size:

| category | kind | min header | handler / notes |
|---|---|---|---|
| 1 | **control** | — | SETUP at `+0x0C` → `sub_0031EF2C` (confirmed) |
| 2 | **data xfer** (bulk/interrupt) | `0x11` | endpoint `+7`, 32-bit length `+0x0C`; data engine `0x304904` |
| 3 | **data xfer** (bulk/interrupt) | `0x11` | same engine; 2 vs 3 = direction/variant (inferred) |
| 4 | **data xfer, extended** (isoc) | `0x17` | same engine + 6 extra header bytes (per-frame info, inferred) |
| 0 / other | — | — | `#VP_SXUP: Unknown function<%x>` → `-ERR_HDR-` (`sub_0031E414`) |

Confidence: header size, big-endianness, the `dir` bit, and category 1 (control)
are **high**; the bulk/interrupt/isoc *assignment* of 2/3/4 is **inferred** from
the min-header sizes and the `VP_SXUP` endpoint strings (not yet nailed to USB
endpoint types).

The data engine consumes the stream (`sub_0032D098`), decrements a remaining-
length counter, and advances a per-transfer **phase** via `sub_00303674` with
arg **1 / 2 / 3** (= setup / data / status, inferred). Within a transfer the
parser tracks sub-states in `pkt[0]` (`ldrh` values 1–4 / 0x8001–0x8004).

**Control transfer (type 1)** — the body carries a verbatim 8-byte **USB SETUP**
packet at header `+0x0C`, read field-for-field and submitted via
`sub_0031EF2C`:

```
+0x0C u8   bmRequestType
+0x0D u8   bRequest
+0x0E u16  wValue   (BE)
+0x10 u16  wIndex   (BE)
+0x12 u16  wLength  (BE)
```

Confidence: **high** — the `ldrb/ldrb/get_le16/get_le16/get_le32` sequence onto a
setup structure is unmistakable.

**Transfer outcomes** (logged by the `VP_SXUP` endpoint handlers, → USB/IP URB
status): `<SCS>` success, `<STL>` stall, `<NAK T/O>` timeout, `<RETRY>`, `<ERR>`,
plus `Cancel pkt received`. Unknown `type` → logs `#VP_SXUP: Unknown function<%x>`
and replies `-ERR_HDR-` (`sub_0031E414`).

### Key functions (data path)

| Addr | Role |
|---|---|
| `sub_0030481C` | **SXUPTP TCP message parser / dispatcher** |
| `sub_0032CD2C` | copy N bytes off the stream buffer (header/body extract) |
| `sub_0031EF2C` | submit **control** transfer (consumes the SETUP packet) |
| `sub_0031E414` | reject / send `-ERR_HDR-` |
| `sub_00304174` | per-transfer job setup (type 1 path) |

### Still open

- Which of categories 2/3/4 is bulk vs interrupt vs isoc specifically (the
  device routes by the endpoint's own descriptor, so the category may indicate
  direction/phase rather than pipe type) — confirm by reversing the `VP_SXUP`
  endpoint handlers (`0x3050xx` isoc, `0x305Bxx` intr-in) or via a capture.
- The exact data-payload framing after the header for 2/3/4 (how multi-packet
  transfers and short packets are chunked), and category 4's extra 6 header
  bytes (per-frame lengths?).
- The discovery *reply* body (device/port enumeration) the client parses to pick
  a device id (the `conn+0x64` value used at attach).

With the control path and the type model in hand, enough is known to start a
**probe client** (Milestone 5): do UDP discovery, TCP-attach a device, and issue
a control `GET_DESCRIPTOR(device)` — whose round trip would also confirm the
2/3/4 data framing empirically.

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

1. ~~**Ports**~~ — DONE (Milestone 1): TCP+UDP **19540**.
2. **Opcode table** — enumerate RuleNo values and their meaning from the TCP
   connection dispatch `sub_00302948` (accepted :19540 conn) and the `SXUPTPD`
   handler at `~0x302xxx`. ← **next (Milestone 2)**
3. **Job state machine** — the `suj_state` transitions (OPEN/…/CLOSEREQ) and the
   attach handshake a client must perform.
4. **USB transfer encoding** — how `VP_SXUP`/`USBUPTP` frames descriptors, setup
   packets, and bulk/interrupt/isoc data.

## Limits of static RE (read before continuing)

Milestones 1 and the discovery/attach half of 2 came out cleanly because they
hinge on constants and strings. The **TCP USB-transfer framing does not** — it is
dispatched through registered socket callbacks over a job/queue RTOS layer, so
reconstructing the exact wire bytes means statically emulating a callback graph.
That is doable but slow and easy to get subtly wrong.

A **short live packet capture** would resolve it in minutes and is the highest-
leverage next step if a device + Silex client ever become available:
- UDP 19540 broadcast → the `"BS"`/`"BB"` discovery exchange (validates framing).
- One TCP 19540 open + a single control transfer (GET_DESCRIPTOR) → reveals the
  data-channel header and the USB-request encoding directly.

Until then, static RE can continue on the self-contained pieces: the discovery
*reply* format (`sub_003039CC` sender) and the `VP_SXUP` endpoint handlers
(`intr-in`, `Isoc`), building the opcode map incrementally.

## Method notes

- Load `ram_reconstructed.bin` at base `0x0`, Thumb; import
  `analysis/F5L009_v1.2.0/ram/symbols.txt` to get the libc names, then rename
  outward from the SXUPTP strings.
- The SX-2000U2 v2.1.5 image has a richer `USBUPTP` sub-driver layer; once the
  v1.2.0 protocol is understood, diff against SX for the newer message set.

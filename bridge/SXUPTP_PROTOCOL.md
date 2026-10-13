# SXUPTP protocol — reverse-engineering notes (living document)

Derived statically from the reconstructed F5L009 RAM image
(`proprietary-Belkin-Silex/analysis/F5L009_v1.2.0/ram_reconstructed.bin`, base `0x0`, Thumb). **Incomplete
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

## Live device findings (CONFIRMED against hardware)

Validated against the real F5L009 at `192.168.2.3` (MAC `00:1C:DF:11:CB:6D`,
Belkin OUI; host `BK11CB6D`).

- **Open ports**: TCP **21** (FTP), **23** (Telnet/DISH, telnet-negotiates then
  wants a login), **80** (web UI, `Server: JC-HTTPD/1.16.22` — matches RE),
  **19540** (SXUPTP). UDP **19540** bound (RE-confirmed: `socket()`+`bind(0x4C54)`
  in the SXUPTPD init).
- **Attached USB device** (from `/en/status/devstat.htm`): a SONiX **"SI Gaming
  Keyboard"**, **Low Speed** HID, status **"Not Connected"** (available to claim)
  — an ideal simple bridge target (control + one interrupt-IN endpoint).
- **TCP 19540 RSTs in ~0 ms** on connect unless a job is pre-allocated — so the
  UDP control exchange is a hard prerequisite (no TCP-only attach).

### UDP control protocol (port 19540) — framing CONFIRMED

Request starts with a **numeric big-endian `u16` command** (`ntohs(data[0:2])`),
**not** an ASCII tag. Reply framing, observed live:

```
+0x00 u16 command   (echoes the request command)
+0x02 u16 status?   (0 in error replies)
+0x04 u16 ?         (0)
+0x06 u16 length    (body length)
+0x08 u8[length]    body
```

This is the **JCP** protocol (`sub_0032FE14`; firmware logs `?JCP: UNKNOWN JCP`).
`command = ntohs(req[0:2])`, `subcommand = ntohs(req[2:4])`:

| command | meaning |
|---|---|
| 1, 2, 3 | get/set a **named JCP config variable** — ASCII name at `req[4:]`, matched against a name table (`sub_0032FDD0`, table @`0x2F51D8`). Silent if the name is unknown. |
| **4 / subcmd `0x9506`** | **device identity / discovery** (`sub_002FA5D0`) — CONFIRMED live |
| else | `"ERR(NOT SUPPORTED)"` |

### Discovery — WORKING (confirmed byte-for-byte on hardware)

Request: `00 04 95 06` (cmd=4, subcmd=0x9506) to UDP 19540. Reply is 166 bytes:

| offset | field | live value |
|---|---|---|
| `0x00` u16 | reply code | `0x0002` |
| `0x02` u16 | subcmd echo | `0x9506` |
| `0x24` char[16] | model | `"Network USB Hub"` |
| `0x38` u8[6] | **MAC** | `00:1C:DF:11:CB:6D` |
| `0x42` u8[4] | **IP** | `192.168.2.3` |
| `0x48` char | JCP version | `"Ver 2.2.0"` |
| `0x54` char[32] | **attached USB device** | `"SONiX SI Gaming Keyboard"` |
| `0x74` char | hostname | `"BK11CB6D"` |
| `0x84` char[32] | firmware | `"1.2.0"` |

Implemented and verified in `sxuptp/protocol.py` (`pack_identify` /
`parse_identity`) and `sxuptp` discover.

### JCP config command set (commands 1/2/3) — from firmware

The named variables matched by commands 1/2/3 come from a static table
(`sub_0032FF1C` merges it into `0x2F51D8`; source table @`0x0033A4CC`). These are
**config/management** operations, not USB attach:

```
GET CONTEXT        GET MENU_DATA        GET ENUM_DATA      GET EEP_DATA
SET DEFAULT        SAVE EEP_DATA        POLLING            SET IP_ADDR
CHK PASSWORD       EXEC REBOOT SYSTEM   EXEC REBOOT LOADER
EXEC PRINT DIAGNOSTIC    EXEC PRINT CONFIGDATA    EXEC CLEAR EEP_DATA
```

The request carries the ASCII name at `req[4:]`. **Safety:** `EXEC REBOOT *`,
`SET DEFAULT`, `SET IP_ADDR`, `SAVE/CLEAR EEP_DATA` change or wipe device state —
never send these while probing; only `GET *` / `POLLING` are read-only.

**Conclusion:** JCP has no "connect USB device" verb — device attach is handled
by the separate **SXUPTPD** job path, not JCP.

### Attach — IDENTIFIED (full connect flow)

Device attach is the JCP command **`EXEC SCANNER CONNECT`** (release =
**`EXEC SCANNER DISCONNECT`**); firmware logs `JCPD: Recv EXEC SCANNER CONNECT`.
("Scanner" is Silex's legacy term for a USB virtual connection.) USB ports are
named **`scn1`, `scn2`, …** (default `"scn1"`).

Handlers: the JCP command → `sub_002FA478` (parse) → `sub_00302C58` (open). The
request body (parsed by `sub_002FA478`) carries, roughly:

```
u8   flag       (default 1)
u8   mac_len    (default 6)
u8[6] client_MAC
u32  client_IP        (big-endian)
char port_name[]      ASCII, e.g. "scn1" / "scn2" (<=16, default "scn1")
```

`sub_00302C58` then: finds/allocates a job keyed by `port_name` (`job+0x10`),
stores `client_IP`→`job+0x28`, `client_port`→`job+0x2c`, `client_MAC`→`job+0x30`,
resolves the USB device by name (`sub_00306D1C`), and sets job state **1**.

### Full connect sequence (device rescue path)

1. **Discover** — JCP `cmd4/0x9506` → device identity (WORKING).
   (Full per-port device list is via JCP `GET ENUM_DATA`.)
2. **Connect** — JCP `EXEC SCANNER CONNECT` with `port_name` (`scn1`/`scn2`) and
   the client's IP/port/MAC. Device allocates a job (state 1 → **2 OPEN_WAIT**)
   and UDP-replies.
3. **TCP attach** — client connects TCP 19540; the accept handler
   (`sub_00302948`) matches the job by client IP/port → state **4 (active)**.
4. **USB I/O** — the 24-byte SXUPTP data-channel messages (control / data
   categories) carry URBs both ways.
5. **Release** — JCP `EXEC SCANNER DISCONNECT`.

This maps cleanly onto a USB/IP exporter: `usbip attach` → CONNECT + TCP + the
device descriptors; URBs ⇄ SXUPTP type-1..4 messages; detach → DISCONNECT.

### SXUP_ALC keepalive — UDP `:49501`, the data-channel liveness signal (SOLVED)

The hub keeps a data-channel session alive by **pinging UDP `client_ip:49501`
(= `0xC15D`) with the 4 bytes `00 04 42 53` (`{len=4}{"BS"}`, the `SXUP_ALC` tag)
every ~10 s**; the client must **echo it verbatim** to `host:49501` (both ends use
49501). Each echo resets the per-connection "Salc" age; miss ~7 in a row and the
age hits ~5999 ticks (~69 s), the hub logs `SXUP_ALC: Send RST!` and RSTs the TCP
data channel — this is the long-standing ~69 s wedge.

CONFIRMED live: the vendor echoes every ping and lives indefinitely; a client that
doesn't bind 49501 ICMP-rejects each ping and wedges at ~70 s. `SxuptpClient` now
runs a responder (`_start_keepalive()`, daemon thread on `client_ip:49501`,
SO_REUSEPORT) — with it ON a single idle connection survived 150 s, with it OFF it
wedged at 70 s. See
[`../proprietary-Belkin-Silex/analysis/F5L009_v1.2.0/tcp_connection_and_keepalive.md`]
(★ SOLVED section) and `diagnostics/direct-sxuptp/idle_survival_test.py`.

### Device-attach announcement — JCP opcode `0x2908` (CONFIRMED on hardware)

Right after `EXEC SCANNER CONNECT` (and its short `OK` reply), the hub **pushes an
unsolicited UDP packet** to the client with first u16 = **`0x2908`** (previously
"unknown"). It is the device-attach announcement: it carries the **devId** and the
attached device's **USB descriptors**, which is how the client learns the devId
and the device's endpoints. The firmware selects the opcode by connection state
(`sxuptp_announce_opcode` @`0x3040a8`, reads `[job+0x9c]`): **state 1 → `0x2908`**,
state 2 → **`0x29eb`** (a second announcement variant).

Layout (1024-byte payload observed; multibyte fields are **big-endian** — the hub
byte-swaps them, unlike raw USB little-endian):

```
+0x00 u16  opcode            0x2908 (state 1) / 0x29eb (state 2)
+0x02 u8   flag              0x01
+0x03 u8   devId             the transfer handle used on the data channel
+0x04 u8[4]server IP         e.g. 192.168.2.3
+0x40 ...  USB device descriptor (18 bytes: bcdUSB, class, MPS0, idVendor,
                               idProduct, bNumConfigurations, ... — all BE)
+0x80 ...  USB configuration descriptor (config → interface → endpoints;
                               wTotalLength / wMaxPacketSize are BE)
```

Example (Corsair Voyager SliderX1): devId 5, VID:PID `0x1b1c:0x1a15`, interface
class 0x08 (Mass Storage) / 0x06 (SCSI) / 0x50 (BOT), endpoints `0x01` OUT and
`0x82` IN, both bulk 512. Decoded by the Wireshark dissector
([`../tools/wireshark/sxuptp.lua`](../tools/wireshark/sxuptp.lua)) and parsed by
`protocol.parse_announce()`.

**Where it lands and when (CONFIRMED live from 192.168.2.50):** the hub pushes it
to the client's **`:19540` grant socket** (the `client_ip:19540` bind), not the
ephemeral connect socket, a few ms after the connect-init `OK`. The vendor order
is **init → OK → announce → commit → empty reply** — the vendor waits for the
announce before sending the commit. `SxuptpClient` now matches that: it does a
short blocking wait for the announce on the grant socket (`_capture_announce(
wait=1.0)`) **between the OK and the commit**, then commits. Matching this order
makes the hub emit the announce exactly **once** (before commit); sending the
commit first instead makes the hub re-announce after it. (This ordering does NOT
affect the ~69 s wedge — survival is 70 s either way — it is a faithfulness fix
and gives a deterministic devId up front.) The result is exposed as
`client.announce` / `client.dev_id`, so there's no probe sweep (verified: the
announced devId returns the matching VID:PID on a live GET_DESCRIPTOR). A
non-blocking drain after the TCP match is kept as a safety net.

### JCP — confirmed live against the device

Request framing CONFIRMED on hardware: `{u16 command, u16 sub, "NAME\0"[, body]}`
to UDP 19540. The `command` value selects a response class: **1** (e.g.
`GET CONTEXT`) and **3** (e.g. `GET ENUM_DATA`, `EXEC SCANNER CONNECT`) both work;
unknown names → `"ERR(NOT SUPPORTED)"`, recognised-but-empty → `0003 0000 0000
0000`.

Full USB-related JCP command set (recovered from `GET CONTEXT`):

```
GET PORT_NAME        GET USB_PORT_NAME     GET USB_DEVICE_LIST
GET SCANNER PORT_NAME   GET SCANNER_STATUS
EXEC SCANNER CONNECT    EXEC SCANNER DISCONNECT
```

**`GET USB_DEVICE_LIST`** (cmd=1) — WORKING live. 8-byte header, a count byte,
then entries each `devNN\0` + product string + binary attributes. Live:

```
dev01  SONiX SI Gaming Keyboard   (interface 0)
dev02  SONiX SI Gaming Keyboard   (interface 1)
dev03  Corsair Voyager SliderX1
```

So **USB ports are named `devNN`**, not `scn1`. Implemented in
`sxuptp.parse_device_list` / `SxuptpClient.list_devices`.

**`EXEC SCANNER CONNECT`** — attach. Decoded requirements:
- Pre-check `sub_002FA0A0`: body `[0]==1`, `[1]==6`, and `body[2:8]` must equal
  the **device's own MAC** (`memcmp` vs `0x10ED60`; firmware logs
  `JCPsub: CHECK MACADDR OK`). CONFIRMED.
- Resolver `sub_00306650`: matches the port name against the device table
  (names `devNN`). CONFIRMED the names via `GET USB_DEVICE_LIST`.

Tested live with `port_name` `scn1` and `dev01`, correct device MAC + client IP:
command accepted (`0003…`), but **no job allocated** — because the request is a
**fixed-layout template**, not the compact form I sent.

### Why attach needs a template (JCP_EXT dispatch reversed)

The JCP_EXT command table is at `0x33A5C4` (16-byte entries
`{name, len, handler, arg}`). `EXEC SCANNER CONNECT` → handler `0x32FCC8` (the
EXEC trampoline), arg `sub_002FA478` (the real action).

`sub_0032FCC8` parses the request as a **fixed template** ("misp template 39"):
it reads a class field at `req[0:2]` (1 or 3), another at `req[2:4]`, and
parameters at **`req[0x54]` and `req[0x56]`**, and copies templated fields by
`pos`/`len` (logs `JCP: %s X[pos:%x len:%x]`). Only then does it hand a body to
`sub_002FA478`. So `EXEC SCANNER CONNECT` is a **large, fixed-offset structure**
(≥0x58 bytes) — the `{flag,mac,ip,name}` body sits at template offsets, not
immediately after the command name. My compact packet put those bytes in the
wrong place, so the pre-check/parse silently no-op'd.

The template engine itself is **ARM-coded**, reached through the Thumb→ARM
veneer table at `0x339FB8` (`bx pc; mov r8,r8`), and the field positions/lengths
are supplied **by the request** (the client's template), not a fixed firmware
descriptor. So the CONNECT packet is a client-defined templated structure; the
firmware places the `{flag, mac_len=6, device_MAC, client_IP, devNN}` body at the
offsets the client's descriptors specify, and `sub_002FA478` reads it from the
assembled buffer (flag@0, MAC@2, IP@8, name@12).

**Status — attach:** fully understood *mechanically* and in its requirements
(device MAC + a `devNN` port name + client IP; CONNECT → job OPEN_WAIT → TCP
match by client IP → active; release = `EXEC SCANNER DISCONNECT`). The one
remaining unknown is the **exact misp-template wire layout** of the
`EXEC SCANNER CONNECT` request, which is client-defined and ARM-engine-driven.

### `GET SCANNER_STATUS` returns USB descriptors — WORKING (read-only!)

`GET SCANNER_STATUS` (cmd=1, body = `{flag=1, mac_len=6, device_MAC, "devNN"}` or
just the `devNN` name) returns a large reply containing the device's **raw USB
descriptors** — device, configuration, interface(s), endpoints — **without
attaching**. Live example (Corsair "Voyager SliderX1"):

```
DEVICE : idVendor 0x1B1C (Corsair), idProduct 0x1A15, bMaxPacketSize0 64, 1 config
CONFIG : 1 interface, bMaxPower 500 mA
IFACE  : class 0x08 (Mass Storage), sub 0x06 (SCSI), proto 0x50 (Bulk-Only)
EPs    : 0x01 OUT bulk, 0x82 IN bulk
```

**Multi-byte descriptor fields appear big-endian** in the reply (e.g. `bcdUSB`,
`wTotalLength`, `idVendor`) — the bridge must byte-swap them back to the standard
little-endian USB layout. This is exactly the data a USB/IP `OP_REP_DEVLIST` /
descriptor fetch needs, and it is obtainable **read-only** — so the bridge can
enumerate and advertise devices even before the attach handshake is solved.

### Attach — live progress (CONNECT works)

Static insight that unlocked it: the EXEC trampoline `sub_0032FCC8` routes on
`ntohs(req[0:2])` — **`1` = action path** (calls the handler `sub_002FA478`),
`3` = field-copy/response path. Sending `EXEC SCANNER CONNECT` with **`cmd=1`**
and body `{flag=1, mac_len=6, DEVICE_MAC, client_IP, "devNN"}` returns **`OK`**
and **creates a job** (CONFIRMED live). The compact body lands directly (the
pre-check `sub_002FA0A0` MAC compare passes), so no template is needed for the
*request* after all — `cmd=1` was the missing piece.

**Remaining (stateful handshake):** a created job sits in `OPEN_WAIT`; the
`state 1→2` pump sends a UDP *grant* and then a client TCP connect must match by
peer IP. In testing the job did not advance to an attachable state and the TCP
connect still RST'd; the job's callback port is left 0 by `sub_002FA478`, so the
grant routing / exact TCP-match timing is the open issue. A created-but-
unattached job stays **reserved** (new CONNECTs return `NG`) until it times out
or the device is power-cycled — so test attach sparingly.

### Attach — WORKING END-TO-END (confirmed live)

The full attach path now works against the real device:

1. JCP `EXEC SCANNER CONNECT` (**cmd=1**), body `{flag=1, mac_len=6, device_MAC,
   client_IP, "devNN"}` → `OK`, job created (state 1).
2. The SXUPTPD pump advances the job to **state 2 (OPEN_WAIT)** ~0.5 s later and
   it then times out, so the client must **TCP-connect within that window**
   (retry the connect for a few seconds to catch it).
3. The accept handler matches the job by our **peer IP** → state 4 (active) →
   the TCP data channel stays open (no RST).
4. Over that socket the device **parses our 24-byte SXUPTP messages and replies**
   — e.g. a control message gets a `0001 0000 ffff …` response. The channel is
   live and bidirectional.

Implemented as `SxuptpClient.attach(port_name, device_mac, client_ip)`.

**Operational notes:** the OPEN_WAIT slot reserves the device; the pump window is
short (~0.5 s), hence the TCP-connect retry loop.

**Clean slot release — RST, not FIN (RESOLVED).** A matched job (state 4) is only
freed when the connection state machine (`sub_00302FB0`, a jump table on
`job[4]`) reaches **state 3**, whose handler (`0x303138`) closes the connection
and calls **Free job** (`sub_00302924`, which zeroes `job[0]`, the in-use marker
the OPEN_WAIT matcher checks). The state machine sets `job[4]=3` **only when its
`recv()` returns an error** (`0x302fea`: `cmp r4,#0; bge …; else job[4]=3`); a
graceful FIN (recv==0) does not, nor does `EXEC SCANNER DISCONNECT` by itself —
either leaves the slot `NG`. So the client closes the TCP data channel with an
**abortive RST** (`SO_LINGER` 0): recv errors → state 3 → Free job, and the slot
is reusable in ~1 s. Verified live: three imports back-to-back with no reboot.
Jump table (deref'd at `0x3031d4`): state0 `0x302ff4`, 1 `0x3030c4`, 2 `0x303102`,
3 `0x303138` (teardown+Free job), 4 `0x30300a` (active recv/parse).

**Control transfers are asynchronous.** In the parser's control path
(`sub_0030481C` sl==1), after `sub_0031EF2C` submits the USB request it stores a
**completion callback `0x32A735` at `job+0x3C`** and returns — the device then
sends the result in a **follow-up message** when the USB transfer completes. So
the `0001 0000 ffff …` we saw to the first control message is an immediate ack,
and the descriptor data arrives asynchronously afterwards.

A live sweep confirmed the shape: the first control msg → `0001 0000 ffff …`;
immediately sending more messages got empty replies and then closed the channel
(a rapid malformed follow-up disrupts the in-flight async transfer).

**Data-channel control SETUP — exact layout DECODED** (`sub_0030481C` @0x304CA4):
the control body at header `+0x0C` is a **10-byte** structure, not the standard
8-byte USB SETUP:

```
+0x0C u8   bmRequestType
+0x0D u8   bRequest
+0x0E u16  wValue   (big-endian)
+0x10 u16  wIndex   (big-endian)
+0x12 u32  wLength  (big-endian, 32-bit)   <-- not 16-bit
```

(`sub_0031EF2C` is the SETUP builder; the URB is submitted via the ARM veneer
`0x33A008`, and completion is reported via the callback `0x32A735`.)

**Live result with the corrected 10-byte SETUP:** the device parses it and
fills the URB, but the transfer still completes `0x0001 0000 ffff …` — `0xffff`
is a USB-level error/failure, not a framing rejection. The message format is
correct; the device refuses the transfer itself.

### ARM USB submit path — traced to its boundary

The URB submit crosses from the Thumb app into the **ARM** USB host-controller
driver (the device uses a PD720101 OHCI/EHCI controller). The path:

- `sub_0031EF60` builds the URB (`sub_0031EF2C` fills the SETUP) and calls the
  Thumb→ARM veneer at `0x33A008`.
- That veneer lands in ARM at `0x335D80`, which is a **register-indirect call
  table** (`bx r5` / `bx r6` / …) — i.e. the submit is a **dynamic (vtable)
  dispatch** through a function pointer, not a static call.
- A sibling veneer targets `0x4F55DC`, which is **above the 4 MB RAM
  reconstruction** — so part of the ARM USB driver is not even in the captured
  image.

### The `0xffff` decoded, and the provable limit of static RE

Reversing the USBUPTP control completion (`sub_0032A734`) shows `0xffff` is a
**USB control-transfer error** — the firmware logs
`?USBUPTP: (Ctrl)Trans Err[devaddr]-I/F[iface]` or
`?USBUPTP: (Ctrl)Not found DevAddr[...]`. So the transfer reaches the USB proxy
layer and fails there (device-address/interface lookup, or the transfer itself).

Combined with `GET USB_DEVICE_LIST` (`dev01`/`dev02` = the keyboard's two
**interfaces**, `dev03` = the storage), SXUPTP sessions are **per-interface** —
so a device-level `GET_DESCRIPTOR` issued through an interface handle is the
wrong request and errors. The practical bridge model this implies:

- **Descriptors** come from `GET SCANNER_STATUS` (read-only, already working).
- The **data channel** carries **endpoint I/O** (interrupt-IN for the keyboard,
  bulk for the storage) per attached interface — not device-level control.

**Where static RE provably ends:** the USB submit is a *dynamic* dispatch
(`bx r5`-style trampolines at `0x335D80`) into the OO ARM host-controller driver,
and a sibling target (`0x4F55DC`) lies in a region that a 16 MB boot
reconstruction shows is **never populated by the boot scatter-load** — it holds
the uninitialized-RAM fill pattern (`2b56 2d56 2f56…`), not code. That driver
code and the dispatch vtables are installed at **runtime by `main()`**, which a
boot-only emulation cannot run (it needs the full RTOS + USB hardware). So the
exact control/enumeration behavior cannot be recovered by any static
reconstruction — it would require full-system emulation or a client capture.

**Conclusion:** the `0xffff` originates inside the OO ARM USB-host-controller
driver, reached by dynamic dispatch, whose code is runtime-installed and absent
from every static artifact.
Resolving it statically would require (a) reconstructing more RAM (>0x400000) and
(b) following runtime vtables into the HC driver and the port/enumeration state
machine — a large effort whose likely answer (the device needs a client-driven
**reset/enumeration** before control transfers) is exactly what a short capture
of SX Virtual Link's data-channel session would show directly. This is the
efficient finish for the last gap.

### How to finish attach (what a capture must show)

Pure static RE has reached its efficient limit here. A single capture of the
real **SX Virtual Link** client connecting one device (UDP 19540) yields the
whole packet. From the capture we need:

1. the full `EXEC SCANNER CONNECT` request bytes (to read the template header +
   field descriptors around offsets `0x54`/`0x56` and where the body lands);
2. the device's UDP reply (the OPEN_WAIT grant);
3. the first bytes the client sends on the TCP 19540 data channel after connect.

With those three, the remaining codec work is small — everything else
(discovery, enumeration, data-channel framing, control SETUP, disconnect) is
already decoded and, for discovery/enumeration, confirmed working live.

### Remaining detail

The exact byte offsets within the `EXEC SCANNER CONNECT` body and the JCP
request framing (how the command name `req[4:]` and body are laid out on the
wire) still need pinning for a first live attempt; most of the body is decoded
above. A live attempt is reversible (DISCONNECT) and uses the device's normal
function, but is state-changing, so it should be crafted carefully (and paired
with a DISCONNECT) rather than fuzzed.

Discovery works, but the command that moves a job to `OPEN_WAIT` (so TCP 19540
accepts the data channel) is still unidentified — it is likely a JCP **set** on a
named variable (command 2/3) whose name table wasn't captured in our RAM snapshot
(registered after emulation stopped). Candidates to reverse next: the JCP var
names, or trace what sets a job's state field to 2. Fuzzing the live `set` path
risks changing device state, so this wants care or a capture.

> **Correction:** the earlier `"BS"`/`"BB"` ASCII tags came from the separate
> `SXUP_ALC` code path and are **not** the UDP-19540 control command format;
> live testing showed that socket uses numeric commands. A good example of
> hardware validation correcting a static-RE inference.

## Cross-validation with daeken/pybelkusb (2009 capture-based decode)

An independent 2009 decode (from packet captures, no firmware) agrees with this
firmware-based RE on every point we had, and **supplies the data-channel transfer
fields our static analysis couldn't reach** (they live in runtime-installed OO
driver code). Two methods, 16 years apart, converging.

Confirmed identical: port 19540; discovery `00 04 95 06` → `00 02 95 06` with
MAC@0x38, name@0x24, IP@0x42, version@0x48, serial@0x74; `GET USB_DEVICE_LIST`
with `devXX` nodes + `80 81` marker + VID/PID; `EXEC SCANNER CONNECT` body
`01 06` + hub MAC + client IP + node string.

**What it adds — the data-channel transfer framing (the `0xffff` fix):**

- Control-IN (22-byte request, big-endian):
  `[0:2]=0001 [2:4]=seq [4:6]=0002 [6:8]=devId<<8 [8:10]=0201 [10:12]=0008`
  then `[12]=bmRequestType [13]=bRequest [14:16]=wValue [16:18]=wIndex
  [18:20]=0000 [20:22]=wLength`. **NOTE `[4:6]=0002` for reads (pybelkusb's own
  code wrongly used `0001`; the real driver uses `0002` — see the "FIRST REAL USB
  TRANSFER" section). `devId` sits at `[6]`.**
- Control-OUT: prefix `8001`, field0 `0003`, payload appended.
- Bulk-OUT: prefix `8003`, body `>HHBBHLH` {`0003`→`(devId<<8)|02`, ep, `01`,
  `8040`, `0`, len} + payload.
- Bulk-IN: prefix `0003`, direction field `(devId<<8)|0x83`; reply data after a
  10-byte header.

**Connect is two UDP messages**: first `00 01 00 01 EXEC SCANNER CONNECT:` …,
then a `00 03 00 01` variant ending `03 02 00`. The **devId** is then read from a
reply (pybelkusb: "byte 3 of the next reply"). Also notes the connect **only
worked from a different client IP** than the device's — relevant since our Mac is
the hub's gateway (`192.168.2.1`).

Implemented in `sxuptp.protocol`: `control_read` / `control_write` / `bulk_read`
/ `bulk_write`.

## Live attach with the faithful (pybelkusb) connect — blocked by the gateway IP

Replicating pybelkusb's exact two-step connect (prefix `00 01 00 01`,
`EXEC SCANNER CONNECT:` with colon, `\0LT\0` + padding + `02`, then the
`00 03 00 01` packet) against the live hub:

- cmd1 returns `OK`; cmd3 returns an empty `0003…`; TCP attaches fine.
- **No devId announcement** arrives on the `:19540` socket (pybelkusb reads the
  devId from `byte[3]` of that reply).
- The control read returns `0001 <seq> ffff 0000 0000` for every devId tried —
  the device *processes* it (it echoes our sequence number) but the USB transfer
  errors (`(Ctrl)Trans Err`).

This matches pybelkusb's note that the connection **only worked from a client IP
different from the hub's own gateway**. Here the Mac is the hub's Internet-Sharing
gateway/DHCP server (`192.168.2.1`), i.e. we are connecting *as* the gateway —
exactly the case that fails. The Mac has no other `192.168.2.x` address and an
alias needs root, so the next step is operator action:

```
sudo ifconfig bridge100 alias 192.168.2.50 255.255.255.0
```

Then re-run the faithful test with client IP `192.168.2.50` (both as the body IP
and the socket source). If pybelkusb's observation holds, the devId announcement
should appear and the control transfer should return the device descriptor.

## ✅ FIRST REAL USB TRANSFER (CONFIRMED live, 2026-10-10)

From the non-gateway alias `192.168.2.50`, a control GET_DESCRIPTOR(device)
returned a genuine 18-byte USB device descriptor over the TCP data channel:

```
request : 00 01 00 04 00 02 04 00 02 01 00 08 80 06 01 00 00 00 00 00 00 12
reply   : 00 01 00 04 00 00 00 00 00 12 | 12 01 00 02 00 00 00 08 45 0c 03 86 00 02 01 02 00 01
          type  seq  stat _    size=18  | <device descriptor: VID:PID = 0C45:8603, SONiX>
```

Two things had to be right (firmware-confirmed causes — see the field-by-field
breakdown below, since an initial guess about field `+0x04` was wrong):

1. **Correct devId (USB device address).** The device is resolved from the byte
   at wire offset `+0x06` by `sub_0031F368` (device-address table walk; firmware
   strings `DevAddr : 0x%ox`, `ohci: ep not found`). A devId that does not
   resolve is exactly the `0xffff` status we kept getting for handles 3/1/2. The
   `:19540` announcement did not arrive on the capture socket in our setup, so
   the client sweeps candidate devIds with GET_DESCRIPTOR until one returns
   `STATUS_OK`. A CONNECT on node `dev01` (Corsair) yielded the working handle
   **devId=4** (a SONiX keyboard) — the devId is a transport/address handle and
   does **not** equal the `devNN` index.

2. **Client IP must not be the hub's gateway.** From `192.168.2.1` (the Mac's
   Internet-Sharing gateway) CONNECT returns `NG`; from the `192.168.2.50` alias
   it returns `OK` and the OPEN_WAIT→TCP match succeeds.

**Correction — the `+0x04` = `0x0002` field is NOT a cause.** The official driver
puts `0x0002` at `+0x04` for reads (`0x0003` for writes) and pybelkusb hardcoded
`0x0001` there, so this looked like the fix. But the firmware message parser
(`sub_0030481C`) only *stores* the `+0x04` and `+0x08` half-words (`strh [r6,#4]`
/ `strh [r6,#8]`) and never reads them; the reply reuses `+0x04` for the
completion status. Our earlier "it mattered" observation was confounded — a
preceding `devId=8` timeout had stalled that TCP channel, so `devId=4` looked
like it failed under `0x0001` when the channel was simply dead. We still send
`0x0002` to stay byte-identical to the real driver, but it is cosmetic. (So the
ARM USB-host-controller "provable limit" analysis was not overturned by a magic
constant; the blockers were the devId and the client IP.)

### What each header field does (confirmed in `sub_0030481C` / `sub_0031F368`)

| wire | value | firmware behaviour |
|---|---|---|
| `+0x00` type | `(dir<<8)\|category` | category dispatched @`0x3048f8` (1=control→`0x304c96`; 2/3=data engine→`0x304904`; 4=ext; else `-ERR_HDR-`); dir sign-bit @`0x304a22` sets IN/OUT |
| `+0x02` | seq/tag | stored, echoed in the reply |
| `+0x04` | `0002`/`0003` | **write-only** (`strh [r6,#4]`); reply overwrites with status — cosmetic |
| `+0x06` | devId | **USB device address**, looked up by `sub_0031F368`; miss → `0xffff` |
| `+0x07` | endpoint | EP# = low nibble, bit7 = IN (`ands #0xf`) |
| `+0x08` | `0201` | **write-only** (`strh [r6,#8]`) — cosmetic |
| `+0x0A` | `0008` | not consumed on the control path (SETUP starts at `+0x0C`) |
| `+0x0C` | SETUP (10B) | `bmReq,bReq,wValue(BE),wIndex(BE),wLength(BE u32)` → serialized to a real 8-byte USB SETUP by `sub_0031EF2C` (32-bit wire wLength truncated to USB's 16-bit) |

Control path requires ≥ 22 bytes (`cmp r4,#0x15; bgt` @`0x304c9e`), matching the
22-byte frame. The reply is the 10-byte header + `size` data bytes.

**Reply framing (CONFIRMED):** 10-byte header `type(2) seq(2) status(2) _(2)
size(2)`, then `size` data bytes. `status` `0x0000`=OK, `0xffff`=failed. Bulk
replies use the same 10-byte header (`parse_control_reply` handles both).

Implemented and self-tested in `sxuptp.protocol` (`control_read` now sends
`0x0002`; `parse_control_reply`; `pack_connect_init`/`pack_connect_commit`/
`pack_disconnect`) and driven by `SxuptpClient.attach()` + `control_transfer()`.
CLI: `python3 -m bridge.sxuptp.probe getdesc 192.168.2.3 --client-ip 192.168.2.50`.

## ⚠️ Interrupt (HID) endpoints — enumerate but input not yet delivered

Control and bulk work; **interrupt-IN input (keyboard keypresses) does not flow
yet**, and the cause is a firmware mechanism we have mapped but not activated.

What was confirmed live (SONiX keyboard `0c45:8603`, devId 4, with the user
actively pressing keys):
- It **enumerates fully** — a real Linux kernel registered the keyboard +
  consumer-control + system-control HID interfaces, correct low speed.
- **No key report is ever delivered** under any client behaviour tried: fast
  re-polling of the interrupt endpoint (`bulk_read` on `0x81` and `0x82`, 100
  polls/30s), a single armed read then listen, and listening on **all three
  sockets** (TCP data channel + UDP `:19540` grant + UDP session) for 30s. Zero
  bytes on every channel. Sending SET_CONFIGURATION, SET_IDLE, SET_PROTOCOL and
  SET_INTERFACE first changed nothing.

Firmware model (from the disassembly):
- Interrupt IN is **queue-based and async**, not request/response. A data-channel
  read for an interrupt endpoint is dispatched (`sb==2` at `0x3042e0`) to a
  handler (`0x304574`) that only **checks a per-endpoint queue**; if empty it logs
  `?VP_SXUP: Intr-IN canncel<NoData>` and unlinks the waiter (`0x3374b0`) — it
  does **not** submit a USB poll. So client reads never start polling.
- A background **interrupt class driver** is registered at init
  (`sub_0030775x`): an ops table of 6 handlers at the literal pool `0x307880`
  — `0x305d58`, `0x30411c`, submit `0x305e20` (the `(Pin)/(Pout)` poll + `Res_Que
  Insert`), complete `0x305b74`, `0x3072c0`, `0x30409c` — plus a buffer and a
  task (`sub_003201E0`/`sub_0032AB5C`). Endpoint poll interval is `ep[0x34]`
  (`PollIntvl`).
- So some **activation** (the class driver's open/probe, or an explicit SXUPTP
  "open interrupt pipe" message) must run to make the firmware start submitting
  USB interrupt INs to the device and buffering reports into the queue for our
  job. That trigger is the missing piece; nothing we send reaches it.

### USB host side (EHCI) — confirms the mechanism

The keyboard is **low speed**, so its interrupt endpoint is polled by **EHCI as a
periodic QH with split transactions** (strings `!EHCI: Periodic split recv err`,
`ehci: intrq not found`, `!EHCI: Interrupt Task No QH`). Tracing it:

- Submitting an interrupt transfer — `ehci_intr_submit` (`0x325cb0`) — **looks up
  an existing QH** (`0x3206bc`) and registers a per-transfer completion callback
  at `qh+0xc4`/`+0xc8`, then signals the EHCI interrupt task; if no QH exists it
  logs `ehci: intrq not found` and returns `-1`.
- The QH itself is get-or-created by the EHCI open-pipe (`~0x324540`, logs
  `?EHCI: Got QHCB`), which allocates a QH control block and links it into the
  periodic frame list (`PERIODICLISTBASE`).
- On completion the chain reaches `0x305d58`, which allocates a queue node,
  `memcpy`s the report, and enqueues it (`0x337428`) for a client read to drain.

So the full report path is: **open interrupt pipe (QH) → submit interrupt
transfer (register callback) → hardware polls (periodic split) → completion
enqueues the report → client read dequeues it.** Our `bulk_read` only does the
last step (dequeue) against a queue that is never filled, because nothing we send
reaches the **submit/open** path (`0x305e20` → `0x325cb0` / `0x324540`).

### Conclusion & the precise capture target

Everything but **one client message** is understood end to end. In the capture of
the official driver doing keyboard I/O, look for the **`C>D` message the driver
sends that our client does not**, appearing **before** any key reports — that is
the "open/submit interrupt pipe" message (it routes to `0x305e20`, not the
`bulk_read` queue-read `0x304574`). Its framing (type/field at `+0x04`/endpoint)
is all we need; after that, the `D>C` size-≤8 replies are the HID reports. The
`decode_sxuptp_pcap.py` tool flags both. Alternative (no capture): keep tracing
the data pump (`0x306xxx` callers of `0x3041e0`) and the class-driver open path.

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

### Reply builders (device → host)

- **Discovery reply (UDP 19540)**: the datagram handler `sendto`s (`sub_0031AE5C`)
  a buffer at `session+0x24`, **max `0x400` (1024) bytes**, to the requester's
  address (local port forced to 19540). The buffer is assembled as a **stream of
  typed fields** by `sub_003039CC`, which dispatches a field-type selector `0..5`
  through a 6-entry table at `0x37B798`:

  | field type | encoder does | likely content |
  |---|---|---|
  | 2 | append string at `session+0x184` (strncpy) | device/product name |
  | 1 | append string at `session+0x1C4` | second name/model string |
  | 3 | typed value (switch on sub-type `[rec+8]`) | numbers / enums |
  | 4 | conditional field from `[sess+0x10]` | optional field |
  | 5 | timestamp delta (`now - job+0xD0`) | uptime / age |
  | 0 | terminator / error (-1) | end |

  So the discovery reply is a **typed-field record of cached device info**, not a
  fixed struct. The specific field order/ids (and which advertise the device ids
  used at attach) are data-driven — the remaining item best confirmed by a
  capture.

- **OPEN reply & data replies (TCP 19540)**: built as ~`0x40`-byte message
  records with a **per-message sequence counter** (`sub_00303C70`, counter from
  `sub_00303C00`) and sent through the same path. They **reuse the 24-byte header
  format** decoded above, so the client parses them with the same `unpack` —
  `dir=0x80` marks them as responses. Confidence: framing **high**; exact OPEN
  reply field values **inferred**.

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
  `proprietary-Belkin-Silex/analysis/F5L009_v1.2.0/ram/symbols.txt` to get the libc names, then rename
  outward from the SXUPTP strings.
- The SX-2000U2 v2.1.5 image has a richer `USBUPTP` sub-driver layer; once the
  v1.2.0 protocol is understood, diff against SX for the newer message set.

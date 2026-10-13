# `usbip` — USB/IP exporter (Milestone 6)

Exposes the Belkin hub's USB devices to a Linux `usbip` client by bridging
USB/IP (TCP 3240) to the reverse-engineered SXUPTP data channel
([`../sxuptp`](../sxuptp)). Pure stdlib.

## Run

```sh
# --client-ip MUST be a NON-gateway IP on the hub's subnet (see ../sxuptp).
python3 -m bridge.usbip.server 192.168.2.3 --client-ip 192.168.2.50
```

Then on a Linux client:

```sh
usbip list   -r <server-host>          # lists 1-1, 1-2, 1-3
usbip attach -r <server-host> -b 1-1   # imports the device
```

## Modules

- `protocol.py` — USB/IP wire encode/decode: OP_REQ/REP_DEVLIST, OP_REQ/REP_IMPORT,
  USBIP_CMD/RET_SUBMIT, USBIP_CMD/RET_UNLINK. Self-test: `python3 -m bridge.usbip.protocol`.
- `backend.py` — `Device`: attaches over SXUPTP, reads descriptors for the IMPORT
  reply, and maps `USBIP_CMD_SUBMIT` to SXUPTP transfers.
- `server.py` — threaded TCP-3240 server; one connection = one imported device.

## Status

| Piece | State |
|---|---|
| USB/IP protocol encode/decode + self-test | **passing** |
| Device enumeration (DEVLIST / startup inventory) | **working live** (1-1 Corsair, 1-2/1-3 SONiX) |
| IMPORT → SXUPTP attach + descriptor read | **wired; drives the real attach** |
| Control (ep0) SUBMIT → SXUPTP control transfer | **working live** |
| End-to-end IMPORT + CMD_SUBMIT (GET_DESCRIPTOR) | **working live** — a Python USB/IP client round-tripped an 18-byte device descriptor through the full stack |
| Bulk IN/OUT endpoints | **working live** — large reads chunked at a 512-aligned size; short packet (reply < requested) ends the transfer |
| Device speed | **auto-derived** from the descriptors (512-byte endpoint → high speed; EP0 maxpacket 8 → low speed; else full) so the vhci doesn't clamp maxpacket |
| `usbip attach` from a real Linux client | **VERIFIED** (mass storage) — a stock Linux `usbip` kernel client attached `1-1`, enumerated it high-speed (Corsair Voyager, serial AALPK8GRLXFLWAX0), mounted its exFAT filesystem read-only, and read files. 4 MB read at ~2.6 MB/s, no errors. See CLIENT.md. |
| HID keyboard (`1-2`/`1-3`) enumeration | **working live** — the kernel registered the SONiX SI Gaming Keyboard (low speed) with its keyboard + consumer-control + system-control HID interfaces (`input1/2/3`). |
| **Interrupt-IN input delivery** | **NOT working yet** — key reports do not flow. The firmware *blocks* an idle interrupt-IN (no reply until data, unlike bulk's request/response), and our synchronous `bulk_read` path gets no report even with HID init + a key pressed, and the hub RSTs the connection after ~5–6 interrupt reads. Needs RE of how the firmware handles interrupt endpoints (likely a different data-channel category and/or an async multi-URB server). Mass storage works because it is strict request/response. |

## Operational caveats (learned against hardware)

- **Shared sockets are mandatory.** The hub keys a session to the client's
  `(IP, source-port)`. `GET USB_DEVICE_LIST` and every CONNECT must go out the
  **same** UDP socket, and a socket must stay bound on `(client_ip, 19540)` to
  receive the OPEN_WAIT grant that advances the job. The server keeps both
  persistent (`Hub._session`, `Hub._grant`) and passes them into
  `SxuptpClient.attach(..., udp=, bc=)`. A CONNECT from a different port than the
  list never advances to OPEN_WAIT (symptom: `could not match the OPEN_WAIT
  window`). This is why the exporter holds one session for its whole life.
- **Slot release (resolved).** A CONNECT reserves the device slot. `EXEC SCANNER
  DISCONNECT` alone does not free it, and a graceful TCP FIN does not either —
  the firmware's connection state machine only frees the job (state 3 ->
  `sub_00302924` "Free job") when its `recv()` returns an **error**. So the
  client closes the TCP data channel with an **abortive RST** (`SO_LINGER` 0),
  which releases the slot in ~1s. Attach/detach now cycles with **no reboot**
  (verified: three imports back-to-back). The HTTP reboot (empty-password login
  at `/en/login/login.htm`, then GET `/en/reset/exec.htm`) is now only needed if
  a client dies without RST-closing.
- **devId vs node (resolved).** The SXUPTP transfer handle (devId) is a USB
  device address, not the `devNN` index, and the hub does not announce it (the
  OPEN_WAIT grant never arrives on `:19540` here). It is now resolved by matching
  the device descriptor's **VID:PID** against the value `GET USB_DEVICE_LIST`
  reports for each node (`client.find_dev_id(want_vid, want_pid)`); importing
  `1-1` correctly returns the Corsair (`1b1c:1a15`). Two devices with identical
  VID:PID (the two keyboards) are given distinct handles via `exclude`
  (`Hub.exclude_for`). A hub with two indistinguishable devices of the same
  VID:PID that also expose no usable discriminator could still be assigned in the
  wrong order, but serials differ in the device list (`L21M0`/`L21M1`) if finer
  matching is ever needed.
- **The hub queues interrupt reports.** Once an interrupt-IN endpoint has been
  read, the hub banks every report the device sends and hands the backlog out
  one per poll. So `ChannelMux` keeps polling even when no URB is queued (else
  the backlog just waits in the hub) and, on the next URB, drops banked reports
  older than `_REPORT_FRESH` (keeping the newest). Replaying that history broke
  serial ports: a PL2303's old DCD on/off status flaps hang up a freshly opened
  `-clocal` tty.
- **Serial testing with socat 1.8.** `socat …,b9600` leaves the port at **speed 0**
  (B0), so the driver drops DTR/RTS; over a null-modem cable that is the peer's
  DCD, which hangs up the peer's tty. Use `ispeed=9600,ospeed=9600` (add
  `clocal=1` if the reader should ignore the peer's carrier altogether).

## Debugging

`USBIP_TRACE=1` logs to stderr every URB-phase command from the kernel and every
reply we send (per busid, timestamped, first data bytes), plus `ChannelMux`
interrupt polls and the hub's replies:

```sh
USBIP_TRACE=1 python3 -m bridge.usbip.server 192.168.2.3 --client-ip 192.168.2.50 2> trace.log
```

## Next

1. Try a real Linux `usbip attach` (the Python client validates the wire
   protocol, but a kernel client mounting the flash drive is the real proof).
2. Handle bulk transfers larger than 0xffff per request if needed (the builder's
   length field is 16-bit; `bulk_in` already chunks requests).

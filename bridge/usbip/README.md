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
| Bulk / interrupt endpoints | **working live** — a Mass-Storage Bulk-Only INQUIRY (CBW→data→CSW) round-tripped on the Corsair (bulk OUT 0x01 / IN 0x82), returning vendor `Corsair`, product `Voyager SliderX1`, CSW status 0 |
| `usbip attach` from a real Linux client | not yet tried (no Linux client here); the wire protocol is validated by the Python client |

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

## Next

1. Try a real Linux `usbip attach` (the Python client validates the wire
   protocol, but a kernel client mounting the flash drive is the real proof).
2. Handle bulk transfers larger than 0xffff per request if needed (the builder's
   length field is 16-bit; `bulk_in` already chunks requests).

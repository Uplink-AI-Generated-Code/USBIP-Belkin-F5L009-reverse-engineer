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
| Bulk / interrupt endpoints | **stubbed** — return a stall (`-EPIPE`); see TODO in `backend.py` |
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
- **Slot reservation.** A CONNECT reserves the device slot. `EXEC SCANNER
  DISCONNECT` is acknowledged (`OK`) but does **not** free it — a new CONNECT
  returns `NG` until the hub reboots. The hub can be rebooted over HTTP (empty-
  password login at `/en/login/login.htm`, then GET `/en/reset/exec.htm`), which
  takes ~10s. One attach session per reboot for now; clean release is still to
  reverse.
- **devId vs node (known bug).** The SXUPTP transfer handle (devId) is currently
  resolved by a sweep and is not equal to the `devNN` index — importing `1-1`
  (Corsair) returned a handle whose descriptor is a SONiX keyboard (`0c45:8603`).
  The devId should come from the OPEN_WAIT grant (byte 3) so each node maps to
  its own device; capturing it reliably is the next correctness fix
  (`backend.attach` / `client.find_dev_id`).

## Next

1. Confirm a live `usbip attach` returns the device and enumerates (needs a
   power-cycled hub).
2. Wire bulk/interrupt (`sx.bulk_read`/`bulk_write`) so data transfers work
   (flash-drive storage, keyboard input).
3. Reverse the clean slot-release so attach/detach cycles don't need a power-cycle.

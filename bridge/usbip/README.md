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
| Control (ep0) SUBMIT → SXUPTP control transfer | **implemented** (same path proven in `../sxuptp`) |
| Bulk / interrupt endpoints | **stubbed** — return a stall (`-EPIPE`); see TODO in `backend.py` |
| End-to-end `usbip attach` live | **pending a device power-cycle** (see below) |

## Operational caveats (firmware-confirmed)

- **Slot reservation.** A CONNECT reserves the device slot. `EXEC SCANNER
  DISCONNECT` is acknowledged (`OK`) but does **not** free the reservation in
  testing — a new CONNECT returns `NG` until the hub is **power-cycled**. So one
  `usbip attach` per device per power-cycle for now. Releasing the slot cleanly
  (what the vendor driver does on detach) is the next thing to reverse.
- **devId vs node.** The SXUPTP transfer handle (devId) is resolved by a sweep
  and is not equal to the `devNN` index; a CONNECT on `dev01` has returned a
  handle belonging to another device. Tightening the node↔devId binding is a
  follow-up (see `backend.find_dev_id`).

## Next

1. Confirm a live `usbip attach` returns the device and enumerates (needs a
   power-cycled hub).
2. Wire bulk/interrupt (`sx.bulk_read`/`bulk_write`) so data transfers work
   (flash-drive storage, keyboard input).
3. Reverse the clean slot-release so attach/detach cycles don't need a power-cycle.

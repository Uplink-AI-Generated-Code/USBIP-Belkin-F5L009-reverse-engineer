# `sxuptp` — SXUPTP probe client (Milestone 5)

A Python implementation of the reverse-engineered SXUPTP protocol, far enough to
probe a device. Pure stdlib. See [`../SXUPTP_PROTOCOL.md`](../SXUPTP_PROTOCOL.md)
for the RE this is based on and the per-field confidence levels.

## Modules

- `protocol.py` — wire encoding/decoding. The **CONFIRMED** parts: port 19540,
  the discovery header `{u16 len, u16 rule}`, the 24-byte data-channel header,
  the `type = (dir<<8)|category` model, and the control **SETUP** packet. Has a
  self-test (`python3 -m bridge.sxuptp.protocol`).
- `client.py` — `SxuptpClient`: `discover()` (UDP broadcast), `connect()`,
  `control_transfer()`, and `attach()` (**not yet implemented** — the OPEN
  request body is still unknown).
- `probe.py` — CLI.

## Usage

```sh
# No hardware needed — print the exact bytes we'd send:
python3 -m bridge.sxuptp.probe --dry-run

# Against a device on the LAN:
python3 -m bridge.sxuptp.probe discover                 # UDP 'BS' broadcast
python3 -m bridge.sxuptp.probe getdesc 192.168.1.50     # attach + GET_DESCRIPTOR
```

## Status — what works vs. what's stubbed

| Piece | State |
|---|---|
| Port 19540, discovery/control framing, SETUP | **implemented, matches RE** |
| `protocol` round-trip self-test | **passing** |
| `discover()` (JCP cmd4/0x9506) | **working, confirmed on live device** — returns parsed model/MAC/IP/USB-device/fw |
| `attach()` | **NotImplementedError** — OPEN request body unknown |
| `control_transfer()` response length | **inferred** (assumes `wLength` data back) |
| Tested against hardware | **discovery: yes** (192.168.2.3); attach/transfers: not yet |

## What unblocks the rest

`attach()` and the discovery-reply parser are the two gaps. Both are "client
sends X, device replies Y" shapes that a **single short packet capture** (or a
live device to poke with `discover`/`getdesc`) would resolve immediately. Until
then the framing is exercised via `--dry-run` and the self-test.

Next (Milestone 6): wrap this in a USB/IP server so `usbip attach` works — the
control path already maps cleanly onto `USBIP_CMD_SUBMIT`.

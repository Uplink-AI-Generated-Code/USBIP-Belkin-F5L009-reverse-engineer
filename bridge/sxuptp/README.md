# `sxuptp` — SXUPTP probe client (Milestone 5)

A Python implementation of the reverse-engineered SXUPTP protocol, far enough to
probe a device. Pure stdlib. See [`../SXUPTP_PROTOCOL.md`](../SXUPTP_PROTOCOL.md)
for the RE this is based on and the per-field confidence levels.

## Modules

- `protocol.py` — wire encoding/decoding. The **CONFIRMED** parts: port 19540,
  the discovery header `{u16 len, u16 rule}`, the 24-byte data-channel header,
  the `type = (dir<<8)|category` model, and the control **SETUP** packet. Has a
  self-test (`python3 -m bridge.sxuptp.protocol`).
- `client.py` — `SxuptpClient`: `discover()`, `list_devices()`,
  `scanner_status()`, `attach()` (two-step CONNECT + TCP OPEN_WAIT match),
  `find_dev_id()`, `control_transfer()`, and `disconnect()`.
- `probe.py` — CLI.

## Usage

```sh
# No hardware needed — print the exact bytes we'd send:
python3 -m bridge.sxuptp.probe --dry-run

# Against a device on the LAN:
python3 -m bridge.sxuptp.probe discover                 # JCP identity broadcast
python3 -m bridge.sxuptp.probe devlist 192.168.2.3      # GET USB_DEVICE_LIST
# attach + GET_DESCRIPTOR. --client-ip MUST be a non-gateway IP on the subnet:
python3 -m bridge.sxuptp.probe getdesc 192.168.2.3 --client-ip 192.168.2.50
```

## Status — what works

| Piece | State |
|---|---|
| Port 19540, discovery/control framing, SETUP | **implemented, matches RE** |
| `protocol` round-trip self-test (incl. live-captured bytes) | **passing** |
| `discover()` (JCP cmd4/0x9506) | **CONFIRMED live** — parsed model/MAC/IP/USB-device/fw |
| `list_devices()` / `scanner_status()` | **CONFIRMED live** |
| `attach()` (2-step CONNECT + TCP match) | **CONFIRMED live** (devId announced or swept) |
| `control_transfer()` (GET_DESCRIPTOR) | **CONFIRMED live** — returned a real 18-byte device descriptor |
| Tested against hardware | **yes** (192.168.2.3, 2026-10-10) |

### The two fixes that unlocked transfers (firmware-confirmed)
1. The **devId must resolve**. The firmware looks up the USB device by the byte
   at wire offset `+0x06` (`sub_0031F368`); a devId that doesn't resolve returns
   `status=0xffff`. The client sweeps for the working handle (devId=4 here).
2. The client IP **must not be the hub's gateway**. From the gateway the CONNECT
   returns `NG`; from a non-gateway alias it returns `OK` and the data channel
   opens.

(We also send `0x0002` at header `+0x04` to match the official driver, but the
firmware stores that field without reading it — it is cosmetic, not a cause of
the earlier `0xffff`. See `../SXUPTP_PROTOCOL.md` for the field-by-field RE.)

Next (Milestone 6): wrap this in a USB/IP server so `usbip attach` works — the
control path already maps cleanly onto `USBIP_CMD_SUBMIT`, and bulk/interrupt
builders (`bulk_read`/`bulk_write`) are in place for the data endpoints.

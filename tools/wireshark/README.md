# SXUPTP Wireshark dissector

`sxuptp.lua` dissects **Silex SXUPTP** (USB-over-IP) as used by the Belkin F5L009
"Network USB Hub" and Silex SX-2000U2, on TCP+UDP port **19540**. Protocol details
were reverse-engineered in this repo — see
[`bridge/SXUPTP_PROTOCOL.md`](../../bridge/SXUPTP_PROTOCOL.md) and
[`proprietary-Belkin-Silex/analysis/F5L009_v1.2.0/`](../../proprietary-Belkin-Silex/analysis/F5L009_v1.2.0/).

## What it decodes

- **UDP 19540 — JCP control**
  - `IDENTIFY/DISCOVER` (cmd 4 / sub 0x9506) request, and the reply fully decoded
    (model, MAC, IP, JCP version, attached USB device, hostname, firmware).
  - Named JCP verbs (`GET USB_DEVICE_LIST`, `EXEC SCANNER CONNECT/DISCONNECT`, …)
    with command class and body; generic reply header `{cmd,status,_,len,body}`.
- **TCP 19540 — data channel** (stream-reassembled)
  - Request types: `CONTROL-IN/OUT`, `BULK-IN/OUT`, `INTERRUPT-IN`, with
    seq, devId, endpoint, `0x8000|wMaxPacketSize`, transfer length, interval.
  - USB **SETUP** decode on control messages (bmRequestType/bRequest/wValue/
    wIndex/wLength, big-endian as the firmware packs them; GET_DESCRIPTOR type).
  - 10-byte transfer **replies** (status OK/FAIL, size, data).
  - USB mass-storage **BOT**: SCSI **CBW** (`USBC`) on bulk-OUT with the SCSI
    opcode named, and **CSW** (`USBS`) on bulk-IN replies with pass/fail status.

Direction (request vs reply) is taken from the port direction, so capture both
halves of the conversation.

## Install

Copy into your Wireshark personal Lua plugins folder
(**Help ▸ About Wireshark ▸ Folders ▸ Personal Lua Plugins**), then reload
(**Analyze ▸ Reload Lua Plugins**, or Ctrl/Cmd-Shift-L).

Or load it ad hoc without installing:

```bash
wireshark -X lua_script:tools/wireshark/sxuptp.lua
tshark    -r capture.pcapng -X lua_script:tools/wireshark/sxuptp.lua
```

If the device uses a non-default port, edit `SXUPTP_PORT` at the top of the script
(or add the port via **Decode As… ▸ SXUPTP**).

## Notes / limits

- SXUPTP header integers are big-endian; the USB payloads inside (CBW/CSW,
  descriptors) keep their native little-endian order, and the dissector reads
  each accordingly.
- A few header slots are vendor constants the firmware stores but ignores
  (`field0` = 0x0002/0x0003, the `0x0201`/`0x0008` control constants); they're
  shown as-is and not over-interpreted.
- Fields marked INFERRED in `SXUPTP_PROTOCOL.md` may need revisiting as RE
  proceeds; tested against live F5L009 captures and the bridge's own encoder.

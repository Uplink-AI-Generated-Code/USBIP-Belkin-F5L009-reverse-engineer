# SXUPTP Wireshark dissector

`sxuptp.lua` dissects **Silex SXUPTP** (USB-over-IP) as used by the Belkin F5L009
"Network USB Hub" and Silex SX-2000U2, on TCP+UDP port **19540**. Protocol details
were reverse-engineered in this repo — see
[`bridge/SXUPTP_PROTOCOL.md`](../../bridge/SXUPTP_PROTOCOL.md) and
[`proprietary-Belkin-Silex/analysis/F5L009_v1.2.0/`](../../proprietary-Belkin-Silex/analysis/F5L009_v1.2.0/).

## What it decodes

- **UDP 19540 — JCP control** (symmetric port; request/reply decided by content)
  - `IDENTIFY/DISCOVER` (cmd 4 / sub 0x9506) request, and the reply fully decoded
    (model, MAC, IP, JCP version, attached USB device, hostname, firmware).
  - Named JCP verbs (`GET USB_DEVICE_LIST`, `EXEC SCANNER CONNECT/DISCONNECT`, …);
    the `SCANNER CONNECT/DISCONNECT` **body** is decoded (flag, device MAC, client
    IP, port name).
  - **Replies**: `GET USB_DEVICE_LIST` → entry count + each `devNN` port/product;
    `OK`/empty ("no-change") replies; generic `{cmd,status,gen,len,body}` header.
  - **`0x2908` / `0x29eb` device-attach announcement** (the hub's push after
    `EXEC SCANNER CONNECT`): devId, server IP, and the embedded USB **device** and
    **configuration** descriptors (VID/PID, interface class, endpoints) — decoded
    big-endian as the firmware re-encodes them.
- **TCP 19540 — data channel** (stream-reassembled)
  - Request types: `CONTROL-IN/OUT`, `BULK-IN/OUT`, `INTERRUPT-IN`, with
    seq, devId, endpoint, `0x8000|wMaxPacketSize`, transfer length, interval.
  - USB **SETUP** decode on control messages (bmRequestType/bRequest/wValue/
    wIndex/wLength, big-endian as the firmware packs them; GET_DESCRIPTOR type).
  - 10-byte transfer **replies** (status OK/FAIL, size, data).
  - USB mass-storage **BOT**: SCSI **CBW** (`USBC`) on bulk-OUT with the SCSI
    opcode named, and **CSW** (`USBS`) on bulk-IN replies with pass/fail status.
- **Salc-resend heuristic** — flags a data-channel message that repeats a
  `(direction, seq)` already seen on that stream, i.e. the SXUPTP "Salc" watchdog
  re-sending an unacked transfer record. Adds generated fields
  `sxuptp.salc.resend` / `sxuptp.salc.resend_of` and an expert **Note**. This is
  the behaviour that correlates with surviving the ~69 s wedge (see the RE docs),
  so it's worth watching vendor-vs-ours. A genuine resend rides a *new* TCP
  segment (not a TCP-layer retransmission), so it reaches the dissector; the
  key is direction-specific, so a normal request/reply pair that shares a seq is
  **not** flagged.

Direction (request vs reply) is taken from the port direction, so capture both
halves of the conversation.

## Coloring rules

`sxuptp.colorfilters` makes the wedge and SXUPTP traffic pop in the packet list:
RST on 19540 (**red** — the wedge), Salc resend (**amber**), transfer/CSW FAIL
(**pink**), identify (**blue**), CBW/CSW (**green**), control SETUP (**yellow**),
other SXUPTP (**grey**). Load via **View ▸ Coloring Rules ▸ Import…**. It
references `sxuptp.*` fields, so load the dissector first.

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

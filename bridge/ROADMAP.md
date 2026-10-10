# SXUPTP → USB/IP bridge — roadmap

Goal: rescue the Belkin F5L009 (Silex SX-2000U2) by writing a Linux daemon that
speaks the device's proprietary **SXUPTP** protocol and re-exports its USB
devices as a standard **USB/IP** server, so any machine can `usbip attach` them.

```
F5L009  ──SXUPTP/IP──▶  bridge daemon  ──USB/IP (TCP 3240)──▶  usbip client(s)
                        ├─ SXUPTP client  (the hard, to-be-RE'd half)
                        └─ usbip server   (documented protocol)
```

Approach: **static RE** of the firmware, now cross-checked against the **live
device** at 192.168.2.3 (no client/capture available). Target: a **usbipd-style
exporter**.

## What we already have

- `fw_codec.py`, decoded + unpacked images, and **reconstructed RAM images** for
  both firmwares (`analysis/*/ram_reconstructed.bin`, base 0, Thumb).
- Labeled C runtime (`analysis/*/ram/symbols.txt`) — `printf`, `strcpy`,
  `bswap16`/`ntohs`, `get_le16`, etc. — which makes the protocol handlers
  readable.
- The SXUPTP code located in the image: the `SXUP_ALC` recv task (~`0x308464`),
  the `SXUPTPD` connection handler (~`0x302xxx`), and the `VP_SXUP`/`USBUPTP`
  USB-transfer layer.

## Knowledge gap (what this project must produce)

A complete **SXUPTP protocol spec**: framing, opcode/"RuleNo" set, the
discovery/attach handshake, the per-endpoint transfer encoding (control / bulk /
interrupt / isochronous), and session ("job") lifecycle. See
[`SXUPTP_PROTOCOL.md`](SXUPTP_PROTOCOL.md) (living document).

## Milestones

1. ~~**Transport map**~~ — **DONE**: SXUPTP = **port 19540** on **TCP** (data/
   `SXUPTPD`, accept-demuxed at `0x2FF410` → `sub_00302948`) and **UDP**
   (discovery/ALC). Matches IANA `sxuptp` 19540. See `SXUPTP_PROTOCOL.md`.
2. ~~**Framing & opcodes**~~ — **DONE**: discovery opcodes (`"BS"`/`"BB"`), the
   TCP attach/open flow, and the 24-byte data-channel header with its type model
   `(dir<<8)|category` (1=control w/ USB SETUP; 2/3/4 = data engine). See
   SXUPTP_PROTOCOL.md.
4. (started) **USB transfer encoding** — control fully decoded; categories 2/3/4
   identified and routed to one data engine (bulk/interrupt/isoc assignment still
   inferred). Remaining: exact payload chunking + endpoint-type mapping.
3. ~~**Attach handshake**~~ — IDENTIFIED: JCP `EXEC SCANNER CONNECT` (port name
   `scn1`/`scn2` + client IP/port/MAC) -> job OPEN_WAIT -> TCP attach -> active;
   release = `EXEC SCANNER DISCONNECT`. Needs exact body offsets for a live try.
5. (started) **Protocol library** — `bridge/sxuptp/` implements the confirmed
   framing (port, discovery, 24-byte header, control SETUP) with a passing
   self-test and a `--dry-run` probe. Stubbed: `attach()` (OPEN body unknown) and
   discovery-reply parsing — need a device/capture.
6. **usbip server** — implement the USB/IP server side (OP_REQ_DEVLIST,
   OP_REQ_IMPORT, USBIP_CMD_SUBMIT/RET_SUBMIT) and wire URBs ⇆ SXUPTP.
7. **Bring-up** — `usbip list`/`attach` against the bridge; iterate on a real
   device. (First hardware-in-the-loop step; until here everything is offline.)

## Risks / unknowns

- Isochronous support (webcams/audio) is the hardest to get right and may come
  last; bulk/interrupt (printers, storage, HID) should work earlier.
- Static RE may leave gaps that only a live capture resolves; if a device is
  available later, a short capture would validate/close them quickly.
- Nothing is verified against hardware until milestone 7; no bricking risk on the
  host side (the bridge is userspace), but treat device-side writes cautiously.

## Layout

```
bridge/
├── ROADMAP.md            this file
├── SXUPTP_PROTOCOL.md    living protocol spec (RE findings)
└── sxuptp/               (future) Python SXUPTP client + usbip server
```

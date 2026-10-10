# SXUPTP → USB/IP bridge — roadmap

Goal: rescue the Belkin F5L009 (Silex SX-2000U2) by writing a Linux daemon that
speaks the device's proprietary **SXUPTP** protocol and re-exports its USB
devices as a standard **USB/IP** server, so any machine can `usbip attach` them.

```
F5L009  ──SXUPTP/IP──▶  bridge daemon  ──USB/IP (TCP 3240)──▶  usbip client(s)
                        ├─ SXUPTP client  (the hard, to-be-RE'd half)
                        └─ usbip server   (documented protocol)
```

Approach chosen: **static reverse engineering** of the firmware (we have both
images fully reconstructed), no live packet capture. Target: a **usbipd-style
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
2. **Framing & opcodes** — fully decode the packet header and enumerate the
   RuleNo/opcode set from the `SXUPTPD` dispatch. (ALC header already known:
   `u16 len, u16 rule`, big-endian.)
3. **Attach handshake** — reverse `?SXUPTPD: Open(Req)`, the `suj_state` job
   state machine (OPEN → … → CLOSEREQ), and what a client must send to claim a
   device.
4. **USB transfer encoding** — reverse `VP_SXUP`/`USBUPTP`: how USB descriptors,
   control setup packets, and bulk/interrupt/isoc data map onto SXUPTP messages.
   This is the crux for URB translation.
5. **Protocol library** — implement the SXUPTP client in Python (fast to iterate)
   as `bridge/sxuptp/`, validated against the spec.
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

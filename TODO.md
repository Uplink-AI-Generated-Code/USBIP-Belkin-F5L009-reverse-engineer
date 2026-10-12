# TODO

## Investigations
1. **Device unplug behavior** — ANSWERED from the capture ("...media keys and
   unplugging..."): when an attached device is physically unplugged, the hub
   CLOSES the data-channel TCP connection(s) with a FIN (one per node) and the
   device disappears from GET USB_DEVICE_LIST. On replug it reappears in the list
   and the driver RE-ATTACHES (it polls the list ~every 5s; there is no push
   notification — reconnect is triggered by the device returning to the list).
   Bridge follow-up: on the SXUPTP channel closing, cleanly surface a USB/IP
   disconnect (close the 3240 connection so the kernel detaches) instead of just
   erroring pending URBs; optionally auto-reattach when the device returns.
2. **Windows driver recovery from a hung reservation** — STILL OPEN. The capture
   has a "request to use a device connected to another computer" action, but the
   device was NOT actually held by another host, so no contention/steal protocol
   was exercised (the request just attached normally; no distinct packets seen).
   Needs a real scenario: device reserved by host A, then host B requests it.
3. **exFAT-path early wedge (~160 KB)** — STILL OPEN, separate from the ~68s
   connection RST. A full-bridge write to the exFAT partition drops very early
   (~160 KB), long before the ~68s keepalive wall and not fixed by reconnect.
   Raw/large-sequential writes to the unformatted partition are fine (128MB via
   the bridge, 256MB direct, both past 68s with reconnect). The exFAT drop is on
   the metadata / scattered-small-write path. NOT being worked yet — investigate
   later (candidate: small-transfer cadence or FS-metadata interleave triggering
   an early hub-side drop distinct from the keepalive timer).

## Bridge follow-ups (lower priority)
- Consumer/media keys (ep0x82): DONE and routed correctly. The hub delivers ep82
  reports only on the dev03 node's channel, so the bridge now opens a secondary
  channel to dev03 for ep82 (see backend _open_secondary / ChannelMux). The
  capture confirms the keys DO emit on ep82 (mute 0x00e2, vol± 0x00e9/ea,
  play/pause 0x00cd, next/prev 0x00b5/b6). FINAL STEP: a live press test to
  confirm event2 (Consumer Control) fires end to end through the bridge.
- Graceful unplug -> USB/IP disconnect + optional auto-reattach (see #1).
- Serial adapters (FTDI 0403:6001, PL2303 067b:2303): WORKING. async bulk +
  FTDI-flood throttle + unlink guard + the uint16 seq-wrap fix. Both enumerate,
  bind ftdi_sio/pl2303, and pass a full kernel loopback (bidirectional + 1000-byte
  sustained) with no detach. The earlier "0 bytes / intermittent detach" was the
  seq overflow (reader died past seq 65535) plus a test-harness issue (shifting
  ttyUSB<->chip mapping across reboots; must hold the ports open so DTR/RTS stay
  asserted and a reader is ready). The kernel ftdi_sio open sequence was in fact
  relayed faithfully (byte-identical to a known-good manual init).
  Minor: ~2 bytes can be lost at the very start of a stream (RX startup race:
  first bytes arrive before the first bulk-IN URB is outstanding) — cosmetic, no
  mid-stream loss; could pre-arm a read on open if it ever matters.
- Interrupt OUT endpoints (not yet supported; HID keyboards don't need it).
- Try a real multi-device session (keyboard + flash + the serial loopback pair)
  for concurrency behavior.

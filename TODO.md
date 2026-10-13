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
3. **exFAT-path early wedge (~160 KB)** — RESOLVED (verified 2026-10-13). The
   early drop no longer reproduces. Linux usbip kernel client (Arch container), exFAT
   partition mounted read-write: ~8.3 MB written (40 files 8-316 KB + one 8 MB
   file, ~50x past the old failure point), all 41 sha256 sums matched after a
   full unmount/remount; a 400-small-file metadata stress (mkdir/cp/mv/rm) was
   intact after remount. No dmesg errors, no resets, no read-only remount.

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
- Multi-device concurrency — DONE (2026-10-13). Four devices imported at once
  (flash HS, composite keyboard LS incl. Consumer-Control, PL2303 + FTDI FS) and
  driven simultaneously for 30 s via the Linux usbip client: ~80 MB flash reads +
  serial writes to both ports + 399 key / 77 media events, no resets/errors, all
  4 alive after. Concurrent multi-device works (host-level keepalive covers all
  channels); see bridge/usbip/CLIENT.md "What to watch for" #2.

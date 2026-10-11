# TODO

## Investigations
1. **Device unplug behavior** — determine what the hub/SXUPTP does when an
   attached USB device is physically unplugged from the hub mid-session (how it
   signals the client, whether the job/slot is freed, how our bridge should
   surface it as a USB/IP disconnect).
2. **Windows driver recovery from a hung reservation** — send a reservation
   (CONNECT) and leave it stuck, then from the Windows driver check whether it
   can cancel/clear someone else's hung reservation (the case our RST release
   can't handle). If it can, capture how — that's a no-reboot recovery path.

## Bridge follow-ups (lower priority)
- Consumer/media keys (ep0x82): export the keyboard's 2nd interface via its own
  node (dev03) + channel as a separate device, so the media/system keys work too.
  The keys (interface0/ep81, dev02) already work; see the single-interface rewrite
  in backend.attach(). Needs resolving dev03's devId and pairing the two nodes.
- Interrupt OUT endpoints (not yet supported; HID keyboards don't need it).
- Reduce idle interrupt-read request accumulation on the dedicated channel
  (reader abandons a submit every ~30s idle; fine in active use).
- Try a real multi-device session (keyboard + flash + the serial adapters now
  plugged in) for concurrency behavior.

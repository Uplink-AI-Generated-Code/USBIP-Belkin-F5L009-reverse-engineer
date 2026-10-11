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
- Interrupt OUT endpoints (not yet supported; HID keyboards don't need it).
- Reduce idle interrupt-read request accumulation on the dedicated channel
  (reader abandons a submit every ~30s idle; fine in active use).
- Try a real multi-device session (keyboard + flash + the serial adapters now
  plugged in) for concurrency behavior.

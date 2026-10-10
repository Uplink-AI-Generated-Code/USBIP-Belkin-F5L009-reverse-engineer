# tools

## `decode_sxuptp_pcap.py` — decode a capture of SXUPTP traffic

Decodes a packet capture of UDP+TCP port 19540 using this project's
reverse-engineered framing (JCP, control/bulk/interrupt requests, 10-byte-header
replies). Built to crack the **one unsolved piece**: how the official driver
activates interrupt (HID) polling so keyboard/mouse input flows (see the
interrupt section of [`../SXUPTP_PROTOCOL.md`](../SXUPTP_PROTOCOL.md)).

```sh
python3 bridge/tools/decode_sxuptp_pcap.py capture.pcap --hub 192.168.2.3
```

It labels each message by direction (`C>D` client→device, `D>C` device→client),
flags any request to an **interrupt endpoint** (`0x81/0x82/0x83`) and any `D>C`
reply of **size 1–8 with status OK** (candidate HID report).

## How to capture the official driver driving the keyboard

The goal is a capture of the **vendor software** (Silex "SX Virtual Link" /
Belkin "Network USB Hub Control Center") connecting the keyboard and delivering
keystrokes — that traffic contains the interrupt-activation message(s) we don't
yet send, plus the key-report messages.

1. Put a machine running the vendor software on the **same L2 network as the
   hub** (the Windows VM bridged onto the hub's subnet). It must reach the hub
   at its IP (e.g. `192.168.2.3`).
2. Start a capture filtered to the hub, **saved as classic pcap** (not pcapng):
   - Windows + Wireshark: capture the adapter, display filter `tcp.port==19540 ||
     udp.port==19540`, then **File → Export Specified Packets → “Wireshark/tcpdump
     … - pcap”**.
   - Or on the Mac if it routes the traffic: `sudo tcpdump -i bridge100 -s0 -w
     kbd.pcap 'port 19540'`.
3. In the vendor software: **connect the keyboard**, then **press and release a
   few distinct keys** (e.g. a, b, c), wait a second between them, then
   **disconnect**. Keep it short — a few seconds of key activity is plenty.
4. Stop the capture, save the pcap, and run the decoder on it.

In the decoded output, look for:
- a **`C>D` request to `ep 0x81`** (or a control/JCP message) that the driver
  sends which our client does **not** — that is the interrupt "arm"/activation;
- the following **`D>C` size-8 replies** that appear only after you pressed keys
  — those are the HID reports, and their exact framing tells us how to read them.

Send me the decoder output (or the pcap) and I can implement the interrupt path.

# Belkin F5L009 "Network USB Hub" — USB/IP bridge & reverse-engineering

The **Belkin F5L009 Network USB Hub** (a rebranded **Silex SX-2000U2** USB device
server) shares USB devices over the network using Silex's proprietary **SXUPTP**
transport. Its vendor software is abandonware — the control centre can't even
connect to devices from Windows 10 on — so the hardware was headed for the
e-waste pile.

This repo rescues it. It contains:

1. **A working SXUPTP → USB/IP bridge** — reverse-engineered from the wire and the
   firmware, it re-exports the hub's devices as standard [USB/IP](https://docs.kernel.org/usb/usbip_protocol.html),
   so the hub works again on any modern Linux (and, via a container, macOS).
2. **A full reverse-engineering of the Silex `.VUP` firmware** — an encode/decode
   tool plus a static + dynamic (emulated-boot) analysis of both firmware images.

Everything here was derived from the device and its firmware — no vendor
documentation of SXUPTP or the `.VUP` format is known to exist.

## The bridge (what rescues the hub)

[`bridge/`](bridge/) is a pure-Python (stdlib-only) USB/IP server that speaks
SXUPTP to the hub on one side and the standard USB/IP wire protocol to a Linux
`vhci_hcd` client on the other:

```
usbip client ── TCP 3240 ──▶ bridge.usbip.server ── UDP/TCP 19540 (SXUPTP) ──▶ hub ──▶ USB device
```

Run the exporter (point it at the hub IP, from a non-gateway IP on the hub's
subnet), then attach from any Linux client:

```sh
python3 -m bridge.usbip.server 192.168.2.3 --client-ip 192.168.2.50
# on the client:
usbip list   -r <bridge-host>
usbip attach -r <bridge-host> -b 1-1
```

No separate Linux box needed — Docker Desktop's kernel has `vhci_hcd` built in;
see [`bridge/usbip/CLIENT.md`](bridge/usbip/CLIENT.md) for the container recipe.

### Verified working, end-to-end against hardware

| Device | Transfer types | Status |
|---|---|---|
| Corsair flash drive | control + **bulk** | mounts & reads files |
| SONiX keyboard — keys & F-keys | control + **interrupt** (ep81) | live typing, n-key rollover |
| SONiX keyboard — media/consumer keys | **interrupt** on a 2nd node (ep82) | volume / mute / play / track keys |
| FTDI + Prolific USB-serial | control + **bulk** (async) | bidirectional + sustained loopback |

Isochronous IN (webcam) is plumbed through end to end — the kernel's `vhci_hcd`
accepts the ISO URBs and the hub delivers camera data — but the hub only passes a
fraction of the stream (see [`bridge/usbip/CLIENT.md`](bridge/usbip/CLIENT.md)), so
video does not yet assemble into whole frames. Hard-won details that make it work:

- **Attach handshake** — a two-step UDP `EXEC SCANNER CONNECT` then a race to
  match the brief TCP `OPEN_WAIT` window; the slot is freed by an **abortive RST**
  close (no reboot needed). Concurrent nodes each need their own ephemeral CONNECT
  socket. See [`bridge/SXUPTP_PROTOCOL.md`](bridge/SXUPTP_PROTOCOL.md).
- **Uniform framing** — every data-channel reply is a 10-byte header + payload,
  replies echo the request `seq` **out of order**, and `seq` is a `uint16` (must
  wrap, or long sessions crash).
- **Composite devices are split across nodes** — a device's interfaces appear as
  separate hub nodes (keyboard keys on one, media keys on another), each on its
  own channel; the bridge presents them as one USB device.
- **Async endpoints via a channel mux** — interrupt and serial-RX bulk reads park
  with no data, so a reader thread demuxes replies by `seq` and completes URBs
  asynchronously, keeping the keyboard crisp and the serial link responsive.

Bridge layout:

```
bridge/
├── SXUPTP_PROTOCOL.md   the reverse-engineered SXUPTP wire protocol
├── ROADMAP.md           design notes / status
├── sxuptp/              SXUPTP client: discovery, attach, control/bulk/interrupt, ChannelMux
├── usbip/               USB/IP server: wire protocol, device backend, CLIENT.md recipe
└── tools/               decode_sxuptp_pcap.py — annotate SXUPTP packet captures
```

Unplugging a device (or rebooting the hub) now detaches it cleanly on the client — the
server drops the USB/IP connection when the hub closes the channel — and the device can be
imported again once it is back. See [`TODO.md`](TODO.md) for remaining work (reservation-steal,
isochronous throughput).

## The firmware tooling

The vendor firmware and everything derived from it live under
[`proprietary-Belkin-Silex/`](proprietary-Belkin-Silex/), kept separate from the
bridge. `fw_codec.py` is pure-Python (stdlib only) and handles both firmware
images (run from inside that directory):

```sh
cd proprietary-Belkin-Silex
python3 fw_codec.py selftest                       # verify against both fixtures
python3 fw_codec.py decrypt F5L009_v1.2.0.bin out.dec.bin
python3 fw_codec.py encrypt out.dec.bin out.bin    # symmetric (XOR)
python3 fw_codec.py unpack  F5L009_v1.2.0.bin dir/ # -> flat image.bin + manifest.json
python3 fw_codec.py pack    dir/ rebuilt.bin       # rebuild container, fix checksums
python3 fw_codec.py recompute in.bin out.bin       # rebuild checksums after edits
```

`selftest` verifies decrypt↔encrypt round-trips byte-for-byte, the record
checksum chain, the ARM reset-vector sanity check, and rejection of malformed
images — green on both firmware files.

### The `.VUP` format, in brief

A `.VUP` image is a variable-length header (magic `.VUP`, length-prefixed device
and version strings, record count) followed by a chain of records. Each record
has a 12-byte big-endian header (`checksum, type, seq, flags, addr_lo, length`)
and XOR-obfuscated data; the key cycles through `C3 F3 BC 8A CC E5 D7 9F` by
`(seq-1) % 8`. Three checksum layers protect it (per-record backward chain, a
seed echo, and a whole-file checksum). Full details in
[`FORMAT.md`](proprietary-Belkin-Silex/FORMAT.md); **how the format and the XOR
key were discovered** (methodology, with reproducible evidence) is in
[`DISCOVERY.md`](proprietary-Belkin-Silex/DISCOVERY.md).

## The firmware analysis

Each firmware was decoded, unpacked to a flat ARM image, and then **booted under
emulation** (Unicorn) to reconstruct the post-boot RAM image, because the flash
image is only a bootstrap that scatter-copies the real application into RAM and
jumps to it in Thumb mode. See each product's `ram_reconstruction.md`.

```
proprietary-Belkin-Silex/
├── F5L009_v1.2.0.bin                Belkin firmware (test fixture)
├── SX-2000U2_v2.1.5.bin            Silex firmware (test fixture)
├── fw_codec.py                     .VUP encode/decode/repack tool
├── FORMAT.md                       the .VUP container specification
├── DISCOVERY.md                    how the format + XOR key were reverse-engineered
└── analysis/
    ├── CROSS_VERSION_DIFF.md       v1.2.0 vs v2.1.5
    ├── F5L009_v1.2.0/
    │   ├── report.md, vectors.txt, entry.asm, records.csv
    │   ├── strings.txt, strings_xref.txt, functions.txt
    │   ├── boot_trace.md           reset → MMU/cache → RAM copy → jump
    │   ├── ram_reconstruction.md   how the RAM image was emulated out
    │   ├── ram_reconstructed.bin   4 MB post-boot image (load at base 0, Thumb)
    │   ├── management_and_flash.md telnet/web/JCP admin surface + flash/update path
    │   ├── ram_main.thumb.asm, ram_strings.txt
    │   └── ram/                    Thumb analysis of the RAM image
    │       ├── report.md, functions.txt, strings.txt, strings_xref.txt
    │       ├── hot_functions.thumb.asm
    │       ├── core_libs.md        labelled C runtime (printf/strcpy/memset/…)
    │       └── symbols.txt         Ghidra/IDA-importable names
    └── SX-2000U2_v2.1.5/           same layout
```

### Key firmware findings
- **Entry**: flash runs at exec base `0x01020000`; reset `0x01020480` sets up the
  MMU/cache and scatter-copies the app into RAM, then jumps to Thumb `main`
  (F5L009 `0x002F959C`, SX-2000U2 `0x0008B8D8`).
- **App stack**: `JC-HTTPD/1.16.22` web server (11-language admin UI), DHCP/BOOTP,
  `silex FTP daemon`, UPnP, NetBIOS, the SXUPTP USB-over-IP transport, and a
  `DISH` debug shell.
- **Management**: telnet in as `root` with no password; the web admin accepts an
  empty password; the hub reboots over HTTP (`/en/reset/exec.htm`) to clear a
  stuck slot. See [`management_and_flash.md`](proprietary-Belkin-Silex/analysis/F5L009_v1.2.0/management_and_flash.md).
- **Shared codebase**: F5L009 and SX-2000U2 are the same Silex program; the C
  runtime maps `0x00336xxx ↔ 0x000D8xxx`. The main v1.2.0→v2.1.5 change is an
  expanded USB sub-driver framework. See the cross-version diff.

## Contents

| Path | What it is |
|---|---|
| [`bridge/`](bridge/) | SXUPTP → USB/IP bridge (the rescue) |
| [`bridge/SXUPTP_PROTOCOL.md`](bridge/SXUPTP_PROTOCOL.md) | The reverse-engineered SXUPTP wire protocol |
| [`bridge/usbip/CLIENT.md`](bridge/usbip/CLIENT.md) | Linux / Docker USB/IP client recipe |
| `Packet_Dumps/` | SXUPTP captures used to reverse the protocol |
| [`proprietary-Belkin-Silex/`](proprietary-Belkin-Silex/) | Vendor firmware + everything derived from it (below) |
| [`…/fw_codec.py`](proprietary-Belkin-Silex/fw_codec.py) | Encode/decode/repack tool for `.VUP` images (+ self-test) |
| [`…/FORMAT.md`](proprietary-Belkin-Silex/FORMAT.md) | The reverse-engineered `.VUP` container specification |
| [`…/DISCOVERY.md`](proprietary-Belkin-Silex/DISCOVERY.md) | How the `.VUP` format & XOR key were discovered (methodology) |
| `…/F5L009_v1.2.0.bin`, `…/SX-2000U2_v2.1.5.bin` | Firmware images (test fixtures) |
| [`…/analysis/`](proprietary-Belkin-Silex/analysis/) | Static + dynamic analysis of both images |
| [`TODO.md`](TODO.md) | Remaining bridge work |

## Reproducing

- **Bridge**: needs the hub on the network and a Linux USB/IP client (or the
  Docker recipe in [`bridge/usbip/CLIENT.md`](bridge/usbip/CLIENT.md)). The
  protocol modules have stdlib-only self-tests: `python3 -m bridge.sxuptp.protocol`
  and `python3 -m bridge.usbip.protocol`.
- **Firmware** (everything under `proprietary-Belkin-Silex/`): the committed
  `.bin` files are the only required inputs; all `analysis/` artifacts regenerate
  with `fw_codec.py` plus Capstone (disassembly) and Unicorn (boot emulation). Two
  large, regenerable outputs are git-ignored: `analysis/*/disasm_full.asm` and
  `*.unpacked/`.

## Scope & caveats

- The bridge talks to real hardware; the firmware reconstruction is **static/
  offline** — no image here has been flashed, which carries real bricking risk.
- The firmware `.bin` files are vendor firmware (© Belkin / silex technology),
  included for interoperability and analysis.
- Analysis labels range from high confidence (unambiguous instruction shapes) to
  inferred; confidence is noted in each document.
```

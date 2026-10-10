# Attaching the hub's USB devices from a Linux client

The exporter (`python3 -m bridge.usbip.server`) speaks the real USB/IP wire
protocol on TCP 3240, so a stock Linux `usbip` client can import the Belkin hub's
devices as if a normal `usbipd` were serving them. **Our server replaces
`usbipd`** — the Linux box only needs the `usbip` *client* command and the
`vhci-hcd` kernel module. Nothing USB/IP needs to run on the Mac besides our
server.

```
 Linux client  ──TCP 3240 (USB/IP)──▶  Mac: bridge.usbip.server  ──UDP/TCP 19540 (SXUPTP)──▶  Belkin F5L009 ──USB──▶ devices
   vhci-hcd                                 (this repo)                                            192.168.2.3
```

## 0. On the Mac: start the exporter

```bash
cd /path/to/Belkin_F5L009_USB_IP_Hub
python3 -m bridge.usbip.server 192.168.2.3 --client-ip 192.168.2.50
```

It prints the exported devices and listens on `0.0.0.0:3240`:

```
[usbip] hub 192.168.2.3 mac=001cdf11cb6d; devices:
         1-1  Corsair Voyager SliderX1
         1-2  SONiX SI Gaming Keyboard
         1-3  SONiX SI Gaming Keyboard
[usbip] listening on 0.0.0.0:3240 (usbip attach -r <host> -b 1-1)
```

`--client-ip` must be a non-gateway alias on the hub's subnet (see the main
README). Note the **Mac's own LAN address** reachable from the Linux box — call
it `$MAC` below (e.g. `192.168.1.50`); it is *not* `192.168.2.x`, which is the
private hub network. If the Mac has a firewall, allow inbound TCP 3240.

> **Port 3240 must be free.** Any other USB/IP daemon on the Mac (e.g.
> `usbipd-mac` installed via Homebrew) also binds 3240; stop it first (its
> presence shows up as `OSError: [Errno 48] Address already in use`, and a
> client that connects anyway gets import `status=1` from the wrong daemon). Or
> run ours elsewhere with `--port <n>` and pass `tcp:$MAC:<n>` style targets —
> but stock `usbip` assumes 3240, so stopping the other daemon is simplest.

## 1. On the Linux client: install the tool and load the module

The client command and modules ship with the kernel's "usbip" userspace.

- Debian/Ubuntu: `sudo apt install usbip` *(or `linux-tools-generic` +
  `linux-tools-$(uname -r)`)*
- Fedora/RHEL: `sudo dnf install usbip-utils`
- Arch: `sudo pacman -S usbip`

Load the client-side virtual host controller:

```bash
sudo modprobe vhci-hcd
```

(You do **not** need `usbip-host`/`usbipd` on the client — that's the server
side, which our Python server provides.)

## 2. List what the hub exports

```bash
usbip list -r $MAC
```

Expected:

```
Exportable USB devices
======================
 - $MAC
        1-1: Corsair:unknown product (1b1c:1a15)
           : /sys/devices/usbip/1-1
           : (Defined at Interface level) (00/00/00)
        1-2: SONiX:unknown product (0c45:8603)
           : ...
        1-3: SONiX:unknown product (0c45:8603)
           : ...
```

(The VID:PID come from the hub's device list. `usbip` may print "unknown
product" because it resolves names from its local `usb.ids`, not from the
device — that's cosmetic.)

## 3. Attach a device

Start with the flash drive (`1-1`), the easiest to verify:

```bash
sudo usbip attach -r $MAC -b 1-1
```

Check it took:

```bash
usbip port          # shows the vhci port and the imported device
dmesg | tail -20    # kernel enumerating the new USB device
lsusb | grep 1b1c   # 1b1c:1a15 Corsair
lsblk               # the flash drive appears as /dev/sdX
```

Then mount it like any USB stick:

```bash
sudo mount /dev/sdX1 /mnt   # replace sdX1 with the real partition from lsblk
ls /mnt
sudo umount /mnt
```

The keyboards (`1-2`, `1-3`) attach the same way and appear as input devices
(`/dev/input/event*`, visible in `dmesg` and `lsusb`).

## 4. Detach when done

```bash
usbip port                         # note the port number, e.g. 00
sudo usbip detach -p 00
```

Detaching closes the TCP connection; our server RST-closes the SXUPTP channel,
which frees the hub slot (no reboot needed), so you can re-attach immediately.

## What is proven vs. what to watch for

**Proven live** (via the bundled Python probe and direct SXUPTP tests): device
enumeration, IMPORT, control transfers (GET_DESCRIPTOR, SET_CONFIGURATION), and
bulk IN/OUT (a Mass-Storage INQUIRY round-tripped on the Corsair), plus clean
slot release across repeated attach/detach.

**Not yet exercised with a real kernel client** — if attach or I/O misbehaves,
likely suspects, in order:

1. **Reported speed.** The server advertises *full speed* for every device; the
   Corsair is actually high speed (`bcdUSB 2.10`, 64-byte EP0). If the vhci
   rejects or mis-drives it, set the device's `speed` to `SPEED_HIGH` in
   `server.Hub.devlist()` / `backend.Device.attach()` (the `UsbipDevice.speed`
   field). This is the most probable first issue.
2. **Large bulk reads.** Bulk was verified with a 36-byte INQUIRY. Larger reads
   are chunked to the 16-bit SXUPTP length field (`client.bulk_in`); mass-storage
   data phases should work but haven't been tested at size.
3. **Isochronous is not implemented** (webcams/audio won't work). Mass storage
   and HID (keyboards) use control/bulk/interrupt only, which are implemented.
4. **One device at a time** is the safe assumption: the server shares a single
   SXUPTP session socket and serializes attaches. Importing a second device
   while one is attached is untested.
5. **Client IP must stay non-gateway** on the Mac side; if the alias is lost
   (e.g. after toggling Internet Sharing) attaches fail until it's re-added.

## Quick alternative without the kernel (sanity check)

To exercise the full server path without a Linux box, run the bundled Python
USB/IP client against the server from anywhere that can reach TCP 3240:

```bash
python3 -m bridge.usbip.testclient 127.0.0.1 1-1   # IMPORT + GET_DESCRIPTOR round-trip
```

(That is how the stack above was validated end-to-end.)

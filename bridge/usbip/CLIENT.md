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

## Verified with a real Linux kernel

A stock Linux `usbip` client **attached `1-1` and mounted the flash drive**: the
kernel enumerated it at high speed (Corsair Voyager, serial `AALPK8GRLXFLWAX0`),
usb-storage bound it as `/dev/sda`, the GPT/exFAT partition `sda1` was read, it
mounted read-only, and files were read back. A 4 MB read ran at ~2.6 MB/s with no
I/O errors or resets. Control, bulk IN/OUT, device-speed, and clean slot release
are all exercised by this path.

### No Linux box? Use Docker (how the above was verified)

Docker Desktop's LinuxKit kernel has `vhci_hcd` built in, so a privileged
container is a real `usbip` client reaching the Mac via `host.docker.internal`:

```bash
docker run -d --name usbiptest --privileged archlinux sleep infinity
docker exec usbiptest pacman -Sy --noconfirm usbip        # standalone usbip-utils
docker exec usbiptest usbip list   -r host.docker.internal
docker exec usbiptest usbip attach -r host.docker.internal -b 1-1
docker exec usbiptest sh -c 'mknod /dev/sda b 8 0; mknod /dev/sda1 b 8 1; \
    pacman -Sy --noconfirm exfatprogs util-linux; \
    mount -o ro /dev/sda1 /mnt && ls -la /mnt'
```

(Arch is used because Ubuntu/Alpine tie `usbip` to a kernel-version package;
Arch ships it standalone. The container needs `--privileged` for `/sys` access to
the vhci. `/dev/sda*` nodes may need `mknod` since the container's `/dev` is
minimal.)

## What to watch for

1. **Isochronous is not implemented** (webcams/audio won't work). Mass storage
   and HID (keyboards) use control/bulk/interrupt only, which are implemented.
2. **One device at a time** is the safe assumption: the server shares a single
   SXUPTP session socket and serializes attaches. Importing a second device
   while one is attached is untested.
3. **Client IP must stay non-gateway** on the Mac side; if the alias is lost
   (e.g. after toggling Internet Sharing) attaches fail until it's re-added.
4. **Port 3240** must be free of any other `usbipd` (see the note above).

## Quick alternative without the kernel (sanity check)

To exercise the full server path without a Linux box, run the bundled Python
USB/IP client against the server from anywhere that can reach TCP 3240:

```bash
python3 -m bridge.usbip.testclient 127.0.0.1 1-1   # IMPORT + GET_DESCRIPTOR round-trip
```

(That is how the stack above was validated end-to-end.)

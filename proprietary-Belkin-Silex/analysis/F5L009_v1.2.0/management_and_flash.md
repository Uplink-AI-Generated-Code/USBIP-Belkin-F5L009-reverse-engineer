# F5L009 management surface & flash/update mechanism

Deep-RE notes on the device's control/management surface and how it reflashes
itself. Addresses are in the reconstructed RAM image (load base `0x0`); see
[`report.md`](report.md) and [`ram_reconstruction.md`](ram_reconstruction.md).

## 1. Management / control surface

### Telnet (TCP 23) — `root`, empty password

`TELNETD` serves a menu console (banner `Belkin Network USB Hub Ver 1.2.0 TELNET
server. / Copyright (C) 2007 Belkin International, Inc.`). Login is **username
`root`, empty password** (prompt: `'root' user needs password to login.` →
`password:` → just press Enter). The telnet session struct holds an **admin flag
at `+0x14`**; privileged menu items check it (`ldr r3,[session+0x14]; cmp #0; beq`
at `0x32f65a`) and otherwise print `You must login as an administrator.`
(`0x383eb0`). Logging in as `root` sets that flag.

**It is a pure configuration/status menu — NOT a Unix shell and NOT a debug
console.** There is no view of live TCP/socket state, per-connection timers,
retransmit counters, or the SXUPTP/USB job table — the deepest status it exposes
is an IP summary plus a USB device *count* (see `96 → 1` below). So telnet cannot
be used to inspect the data-channel connection state behind the ~69 s RST
([`tcp_connection_and_keepalive.md`](tcp_connection_and_keepalive.md)).

Complete menu tree (mapped live 2026-10-13, read-only; nothing committed).
`99` = Back/Exit at every level; selecting a scalar opens a value editor:

```
level.1 (main)   Please select(1 - 99)?
  1 : Configure General ............................ level.2
        1 : Change root Password        : "*******"      (free-text editor)
        2 : LAN Interface               : AUTO           (enum: 1 AUTO, 2 10 HALF,
                                                           3 10 FULL, 4 100 HALF, 5 100 FULL)
  2 : Configure TCP/IP ............................. level.2
        1 : DHCP/BOOTP                  : ENABLE         (toggle)
        2 : IP Address                  : 0.0.0.0        [static; SET IP_ADDR is destructive]
        3 : Subnet Mask                 : 0.0.0.0
        4 : Default Gateway             : 0.0.0.0
        5 : IP Filter Configuration ................... level.3
              1 : IP Filter Mode        : DENY
              2..9 : Filter #0..#3 Start/End Address : 0.0.0.0   (4 allow/deny ranges)
        6 : Network PnP                 : ENABLE
        7 : Host Name                   : "BK11CB6D"
        8 : WINS ...................................... level.3
              1 : Primary WINS Server   : 0.0.0.0
              2 : Secondary WINS Server : 0.0.0.0
              3 : NetBIOS Scope ID      : ""
        9 : mDNS                        : ENABLE
       10 : mDNS Service Name           : "BK11CB6D"
 96 : Display Status ................................ (submenu)
        1 : system   -> read-only dump:
              TCP/IP status: IP address (DHCP flag), Subnet Mask, Gateway addr,
                             DHCP Server, Lease time (sec)
              USB status:    Number of Device: N   (physical devices; a composite
                             keyboard that enumerates as two devNN nodes counts once)
 97 : Reset Settings to Defaults ..................... [DESTRUCTIVE — avoid]
 98 : Restart Device Server .......................... [reboot]
 99 : Exit
```

Editor behavior (probed on LAN Interface, re-selecting the current value → no
change): an enumerated field prints its options and `Please select(1 - N)?`; a
free-text field prompts for a string. **An empty line (Enter) keeps the current
value and returns to the parent menu**, and out-of-range input is rejected with
`Data out of range.` — so a field can be opened and backed out of non-
destructively. (Config writes to EEPROM are the destructive JCP ops listed below;
avoid committing IP/DHCP/password changes.)

**No hidden telnet commands.** The TCP/23 menu has no undocumented backdoor
command; the only gating is the admin flag (above), which merely hides
privileged items until `root` login. Two caveats: (1) the firmware string table
carries `Configure NetWare`, `Configure AppleTalk`, and `Configure SNMP`
(`0x0035a959`/`0x0035a99b`/`0x0035aa1f`) menu entries that are compiled-in but
**suppressed** on this build (never shown in the live menu). (2) The CREAM
platform's interactive debug shells — `DISH` (Debugging shell 2.5.0), `CAKE`
(kernel debugger), `SXUPDEB`, `USBDEB`, `OHCIDEB`, `EHCIDEB`, `HeDEB`, `TCPDEB` —
are a powerful command surface but reached over the **physical UART console**
(ARM-mode low-level driver via veneer `0x00339fa0`), **not** over network telnet.

### Web (HTTP 80) — empty-password login, template engine
Login posts `login_password` to `/en/login/login.htm` (empty password works;
auth is session/IP-based). Pages are rendered by a server-side template engine
using `<j mlword:NNNN>` (localized strings), `<j ctx_hidn:...>`, `<j machin>`,
etc. Known endpoints (`/en/...`):

| path | purpose |
|---|---|
| `login/login.htm` | login (POST `login_password`) |
| `mnt/sysinfo.htm` | system info |
| `mnt/adpass.htm` | change root password |
| `mnt/reset.htm` → `reset/exec.htm` | **reboot** (GET exec = HTTP 202, ~10 s) |
| `factory/exec.htm` | **factory reset** [destructive — avoid] |
| `mnt/loginfo.htm` | event log |
| `mnt/update.htm` → `print/exec.htm` | **firmware update** (multipart upload) |

#### Hidden `/en/debug/` tree — UNAUTHENTICATED live USB inventory
An unlinked, **English-only** debug UI exists under `/en/debug/` (no `debug/` dir
in any of the other 13 locale trees — the signature of leftover developer
tooling). It is not reachable from `top.htm`/`menu.htm` and is backed by live
handler code (the "Debug Page" body at RAM `0x0033bd37`/`0x0033c314`), not static
files. **Confirmed live 2026-10-13 against `192.168.2.3:80`, served with NO login
at all** (not merely empty-password — the pages sit outside the normal frameset
auth path):

| path | serves |
|---|---|
| `debug/index.htm`, `debug/menu.htm` | debug landing / nav (HTTP 200) |
| `debug/devinfo.htm` | **live device table**: renders `dmax = N` + `dev = Array(...)` of the currently-attached slot numbers |
| `debug/device1.htm` … `device23.htm` | per-slot **full USB descriptor dump** (`device24+` → 404, matching the 23-slot ceiling) |

`deviceN.htm` prints the raw descriptor for whatever is in slot N: speed,
address, `idVendor`/`idProduct`, `iManufacturer`/`iProduct` strings, and the full
config/interface/endpoint descriptors (an unpopulated slot returns an empty
cell). Live example (slot 4): `idVendor=0x0C45 idProduct=0x8603 [SONiX] [SI
Gaming Keyboard]`, two INTR interfaces on EP 0x81/0x82 — the composite HID split.
**Security impact:** anyone who can reach port 80 can read the live USB device
inventory and descriptors without authenticating.

### JCP — system/config command set (table @ `0x33A4CC`)
JCP (`sub_0032FE14`) dispatches an ASCII command name against a table. The
system/config table has 14 entries `{name, 0, handler, template}`; `GET *` use
handler `0x32fbc9`, the `EXEC *` trampoline is `0x32fcc9`:

```
GET CONTEXT   GET MENU_DATA   GET ENUM_DATA   GET EEP_DATA      (read-only dumps)
SET DEFAULT          [destructive]      SAVE EEP_DATA
POLLING              SET IP_ADDR [destructive]   CHK PASSWORD
EXEC REBOOT SYSTEM / REBOOT LOADER      [reboot]
EXEC PRINT DIAGNOSTIC / PRINT CONFIGDATA   (read-only reports)
EXEC CLEAR EEP_DATA  [destructive]
```
The runtime var table `0x2F51D8` is built from this source at boot
(`sub_0032FF1C`). (The separate USB/scanner JCP set used by the bridge —
`GET USB_DEVICE_LIST`, `GET SCANNER_STATUS`, `EXEC SCANNER CONNECT/DISCONNECT`,
identify `cmd4/0x9506` — is documented in [`../../bridge/SXUPTP_PROTOCOL.md`].)

## 2. Flash & firmware-update mechanism

### Flash hardware — memory-mapped AMD/Spansion-command-set NOR
The firmware executes in place from a parallel **NOR flash mapped at
`0x01000000`** (reset vector `0x01020480`; the application/`.VUP` payload lives
at flash offset `0x20000` = VA `0x01020000`, matching the image's exec base).

Command primitive `sub_002F7504(offset, value)` writes a flash command: in x16
mode (`mode_global == 2`) `strh value,[base+offset]`, else a word write at
`base + offset*2`. The reset/read sequence `sub_002F752C` issues the classic
**two unlock cycles + command**:

```
[base+0xAAA] = 0xAA
[base+0x554] = 0x55
[base+0xAAA] = 0xF0        ; 0xF0 = reset to read mode
```

These are the standard AMD/Spansion unlock-cycle addresses (`0xAAA`/`0x554` in
byte addressing), so erase uses `0x80`+`0x30` and program uses `0xA0` with the
same unlock prefix. Completion is detected by **toggle-bit polling** — DQ6/DQ7
with a DQ5 error/timeout check and a ~10000 spin bound (`sub_002F7568`, consts
`0x40`/`0x80`/`0x20`/`0x2710`). Sector erase walks the chip geometry
(`sub_002F77xx`, logs `%lx:Erase`, `Erase flash memory...`).

A software interlock `unlock flash` (`sub_002F7B8C`) just sets an in-RAM
enable flag (`strb #1`) that the write path checks — a guard against stray
writes, not a hardware unlock.

### Update flow (`.VUP` → flash → loader)
1. Web `update.htm` uploads the `.VUP` file (multipart POST to `print/exec.htm`).
2. The handler validates it (the `.VUP` container is fully decoded — see
   [`../../fw_codec.py`](../../fw_codec.py) and [`../../FORMAT.md`](../../FORMAT.md):
   magic `".VUP"`, 12-byte BE record headers, XOR key schedule, checksum chain).
3. It `unlock flash`s, **erases** the application sectors and **programs** the
   decoded image at flash `0x20000`, polling toggle bits; `Firmware update
   failed` on error.
4. `EXEC REBOOT LOADER` hands control to the bootloader (`Loader is ready` /
   `Loader is ready and executing`), which brings up the new image.

**Implication:** the fully-decoded `.VUP` format plus this write path means a
custom/patched image could be built with `fw_codec.py` and flashed through the
normal web update — the recompute-checksums mode already produces a container the
validator accepts. (Not attempted; noted for completeness.)

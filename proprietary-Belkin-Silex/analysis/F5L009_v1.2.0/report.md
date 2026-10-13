# Static analysis — image.bin

> Software component inventory / provenance (what the firmware is built from —
> Silex CREAM platform + a BSD-derived TCP/IP stack): [`components.md`](components.md).

## Disassembly coverage / roadmap

The RE so far is a deliberate vertical slice: the SXUPTP ↔ TCP ↔ USB **data
path** (for the bridge and the ~69 s wedge), plus flash, boot, and the
management/JCP surface. By function count that is **~90 of ~1,630 app functions
named (~5–6 %)** in the RAM image; the rest is identified by strings but not
disassembled.

| Area | Status |
|---|---|
| TCP connection/timer stack (`0x315000–0x31a300`) | **mapped** (see `tcp_connection_and_keepalive.md`) |
| SXUPTP job FSM + "Salc" record manager (`0x302000–0x308500`) | **mapped** (incl. the wedge watchdog `0x308318`) |
| USB core transfer + EHCI/OHCI open paths | partial (open/intr only; most of the HC driver untouched) |
| Flash / firmware update, boot/reset, JCP, telnet menu | **mapped** (`management_and_flash.md`, `boot_trace.md`) |
| Web UI + template engine (`<j mlword>`, 11 languages) | **untouched** — largest unexplored chunk (~647 string hits) |
| HTTP server (`JC-HTTPD/1.16.22`) | untouched |
| DHCP/BOOTP/RARP client | untouched (~291 hits) |
| NetBIOS/WINS, mDNS, UPnP, FTPD, SNMP, AppleTalk/PAP, SMTP, LPR/RAW/IPP | untouched |
| IGMP/ICMP/ARP IP-aux | untouched |

None of the untouched areas is on the USB-over-IP data path. The block most
likely to matter next for the wedge (`0x308000`) has now been done; the dense
unnamed `0x330000` block is mostly C-runtime/networking helpers.

- Exec base **0x01020000**, size **0x6e9a0** (453024 bytes)
- Flat image from Network USB Hub v1.2.0, 940 records
- Reset/entry: **0x01020480** (file off 0x480)
- 3586 ASCII strings; 18 with code xrefs
- 1523 candidate functions (10 push-lr prologues, 1516 BL targets)
- Most-called routine: sub_01021020 (6 call sites)

## Vector targets

- Reset: 0x01020480
- Undef: 0x00335cf4
- SWI/SVC: 0x00335b54
- Prefetch Abort: 0x00335c94
- Data Abort: 0x00335cc4
- (reserved): 0x00000000
- IRQ: 0x00335bc8
- FIQ: 0x00335c64

## Notable strings

### identity
- ` "Network USB Hub Control`
- ` Belkin`
- ` Network USB Hub Control`
- `(214-silex FTPD supported commands(RFC959`
- `Belkin`
- `Belkin Internatio`
- `Copyright (C) 2007 Belkin International, Inc.`
- `Network USB Hub`
- `silex`

### net/proto
- ` DHCP/BOOT`
- ` HTTP/1.1`
- ` TELNET`
- `!-- UPnP`
- `!FTPD-P`
- `!HTTPD:`
- `#UPNP-`
- `(214-silex FTPD supported commands(RFC959`
- `-upnp-`
- `:s="http:/`
- `<META HTTP-EQUIV="Conte`
- `>http://www.b`
- `?TCPMAIN:B`
- `BOOTP`
- `DHCP/BOOT`
- `DHCP/BOOTP`
- `DHCP/BOOTP `
- `DhcpEn`
- `HTTP 1.0/`
- `HTTPD:Po`
- `ID scope NetBIOS`
- `META HTTP-EQUIV`
- `META HTTP-EQUIV="`
- `META HTTP-EQUIV="C`
- `NOTIFY * HTTP/1.1`
- `NetBIOS`
- `NetBIOS `
- `NetBIOS Scope ID`
- `NetBIOS-Bereichs-ID`
- `Scope ID NetBIOS`
- `TCP#9100`
- `TCP/`
- `TCP/IP `
- `TCPTERM`
- `UPNP`
- `UPNPD:UUID`
- `UPnPEr`
- `VPFTPLDR:G`
- `_http`
- `hemas-upnp-org`

### debug/diag
- ` Debugg`
- ` ERROR!`
- ` debug`
- `<?xml version="1.0"?>`
- `Debug P`
- `ERROR`
- `ErrorCount`
- `MSG_DEBUG`
- `Rx BUFF Error(`
- `debugger V`
- `ng EEPROM...`


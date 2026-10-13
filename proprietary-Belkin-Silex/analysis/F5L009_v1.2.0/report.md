# Static analysis — image.bin

> Software component inventory / provenance (what the firmware is built from —
> Silex CREAM platform + a BSD-derived TCP/IP stack): [`components.md`](components.md).

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


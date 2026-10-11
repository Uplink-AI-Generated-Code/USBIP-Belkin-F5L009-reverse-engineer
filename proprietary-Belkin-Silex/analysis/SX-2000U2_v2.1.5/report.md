# Static analysis — image.bin

- Exec base **0x01020000**, size **0x74a60** (477792 bytes)
- Flat image from SX-2000U2 v2.1.5, 991 records
- Reset/entry: **0x01020480** (file off 0x480)
- 3653 ASCII strings; 21 with code xrefs
- 1520 candidate functions (9 push-lr prologues, 1514 BL targets)
- Most-called routine: sub_01021020 (6 call sites)

## Vector targets

- Reset: 0x01020480
- Undef: 0x000d7b90
- SWI/SVC: 0x000d7a50
- Prefetch Abort: 0x000d7b50
- Data Abort: 0x000d7b70
- (reserved): 0x00000000
- IRQ: 0x000d7aac
- FIQ: 0x000d7b30

## Notable strings

### identity
- `(214-silex FTPD supported commands(RFC959`
- `Copyright (C) 2005-2008 silex technology, Inc.`
- `SX-2000U2`
- `silex`
- `silex techn`

### net/proto
- ` HTTP/1.1`
- ` TCP`
- ` TELNET`
- `!-- UPnP`
- `!FTPD-P`
- `!HTTPD:`
- `!TELNETD:Op`
- `#UPNP-`
- `(214-silex FTPD supported commands(RFC959`
- `-upnp-`
- `2>HTTP 1.0/<!JCI-ERR`
- `:s="http:/`
- `<META HTTP-EQUIV="Conte`
- `>http://www.`
- `?TCP`
- `BOOTP`
- `DHCP`
- `DHCP/BOOTP`
- `HTTP`
- `HTTPD:Po`
- `META HTTP-EQUIV`
- `META HTTP-EQUIV="`
- `NOTIFY * HTTP/1.1`
- `NetBIOS Scope ID`
- `SNMP`
- `TCP#9100`
- `TCP/`
- `TCP/I`
- `TCP/IP `
- `TCPTERM`
- `TELNET`
- `Telnet`
- `UPNP`
- `UPNPD:UUID`
- `UPnPEr`
- `_http`
- `a DHCP/BOOT`
- `hemas-upnp-org`
- `http://`
- `http://www.`

### debug/diag
- ` Debugg`
- ` Error`
- ` debug`
- `<?xml version="1.0"?>`
- `DEBUG`
- `Debug P`
- `ERROR`
- `ErrorCount`
- `Rx BUFF Error(`
- `debugger V`
- `em debug`
- `ng EEPROM...`


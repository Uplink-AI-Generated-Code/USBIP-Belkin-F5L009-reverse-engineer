# F5L009 v1.2.0 — software component inventory / provenance

What the firmware is built from, identified from embedded banners, copyright
strings, and distinctive log/format strings in `ram_reconstructed.bin` (see
[`report.md`](report.md) for the raw string dump). Short version: the image is
**overwhelmingly Silex's own "CREAM" platform**; the only part with clear
well-known lineage is the TCP/IP stack, whose *algorithms* are textbook 4.4BSD
but which has been rewritten/wrapped by Silex (not a drop-in named library).

## Silex-proprietary core (NOT third-party libraries)

| component | evidence | role |
|---|---|---|
| **CREAM kernel** (RTOS) v3.1 | `Cream/3.1,UPnP/1.0,UPnPNULL/1.0`; `CREAM Version :` | the operating system / scheduler |
| **CAKE** | `'CAKE' CREAM Kernel debugger Ver 1.4.2` | kernel debugger |
| **DISH** | `'DISH' Debugging shell Version 2.5.0`; `- Restarting DISH.` | debug shell |
| **SXUPDEB** | `'SXUPDEB' SXUPTP debugger Ver 0.0.1` | SXUPTP-layer debug console |
| **SXUPTP** | (the USB-over-IP transport this project targets) | Silex USB peripheral transport; "Salc" allocation/transfer-record manager @0x308000 |

No third-party RTOS signatures are present anywhere — no ThreadX, Nucleus,
µC/OS, eCos, FreeRTOS, VxWorks, RTX, embOS, or KADAK AMX. CREAM/CAKE/DISH are
Silex-internal names.

## TCP/IP stack — 4.4BSD-derived, Silex-wrapped

The one subsystem with recognizable well-known lineage. The reverse-engineered
structures are classic **4.4BSD TCP** (`TCB`, `snd.una`/`rcv.nxt`,
`t_rtt_active`/`t_rtseq`, the Jacobson RTT/RTO estimator, Karn's algorithm,
keepalive/retransmit backoff — see [`tcp_connection_and_keepalive.md`]). It is
wrapped with Silex's own conventions and logging:

- custom printf conversions: `%I` (IP addr), `%M` (MAC), `%SS` (socket IP:port), `%SA`
- control-block names `TCB`/`UCB`/`ICB`/`MACB`, subsystem tag `!TCPMAIN:`
- messages such as `#TCP:KeepAlive T/O %SS-%SS`, `#TCP:ReTransmit T/O %SS-%SS`,
  `#TCP:Recv RST %SS-%SS`, `!IP:Bad version(%d) from %M`

It is **not lwIP and not uIP** (entirely different idioms), and it carries no
version banner to match against a specific named port — it reads like a
from-the-textbook BSD port maintained by Silex. "Well-known" only in the
algorithmic sense.

## Network services / app layer — all Silex's own (no SDK banners)

| service | evidence | notes |
|---|---|---|
| DHCP/BOOTP/RARP client | `!DHCP:*`, `?DHCP:*`, `!TCPMAIN:Sending RARP request.` | custom |
| HTTP server | banner **`JC-HTTPD/1.16.22`**; `?HTTPD:`/`!HTTPD:Bad request %s`, `HTTP/1.1` | Silex "JC" HTTP server, versioned (not boa/GoAhead/appweb) |
| FTP server | `215 silex FTP daemon.`, RFC959/RFC2428 subset | custom (print-spooler + `syslog`/`flash` virtual FS — see [`ftp_server.md`](ftp_server.md)) |
| Telnet server | `Copyright (C) 2007 Belkin International, Inc.` banner | config/status menu (see [`management_and_flash.md`]) |
| UPnP | `silex-jp:device:NullDevice:1`, `UPnPNULL/1.0` | Silex's own — **not** Intel Portable SDK / libupnp / pupnp |
| mDNS | mDNS config strings | custom — **no** mDNSResponder/Bonjour/dns-sd strings |
| SNMP | `Configure SNMP`, `SNMP` | present; no net-snmp/ucd-snmp banner |
| NetBIOS/WINS | `WINS`, `NetBIOS Scope ID` | custom |
| AppleTalk | `AppleTalk Protocol`, `appledouble` | Mac-printing support; Silex's own |

## Notably ABSENT (checked, not found)

No zlib/inflate/deflate, no libpng/JPEG decoder (only the MIME string
`image/jpeg`), no OpenSSL/mbedTLS/PolarSSL/wolfSSL/MatrixSSL, no expat/libxml,
no BusyBox/Linux/U-Boot/RedBoot, no net-snmp. No compiler/toolchain banner
(stripped; 2007-era ARM Thumb, so likely ARM ADS/RVCT).

## Relevance to the ~69 s data-channel RST

A BSD-derived TCP means the stack should follow documented BSD semantics, which
reinforces the finding in [`tcp_connection_and_keepalive.md`] that an autonomous
~69 s RST is **not** normal TCP behaviour — the teardown is driven by Silex's own
SXUPTP job layer on top of the stack, not by the BSD TCP machinery.

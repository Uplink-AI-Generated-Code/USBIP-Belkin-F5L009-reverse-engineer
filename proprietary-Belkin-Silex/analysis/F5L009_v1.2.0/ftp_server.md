# F5L009 FTP server (silex FTPD, TCP 21)

Deep-RE notes on the FTP daemon that listens on port 21 of the F5L009. It is
**not documented in any Belkin F5L009 literature** because it is not a product
feature of the hub at all — it is a vestigial component inherited wholesale from
silex's **print-server** platform (the same binary ships on the SX-2000U2, see
[`../CROSS_VERSION_DIFF.md`](../CROSS_VERSION_DIFF.md)). On the F5L009 it is
repurposed as a tiny **virtual filesystem** fronting three internal nodes:
a discard sink, the **system log**, and the **firmware flash region**. There is
no general file storage behind it, which is why a casual `root`/empty login
"logs in but the filesystem is empty."

All addresses are in the reconstructed-RAM image (`ram_reconstructed.bin`, load
base `0x0`, Thumb). Symbols added to [`ram/symbols.txt`](ram/symbols.txt).

## 1. Identity & banners

| string | addr | meaning |
|---|---|---|
| `220 Belkin Network USB Hub Ver 1.2.0 FTP server.` | assembled @ `0x30ad40` | connect greeting (`ftp_send_greeting`) |
| `215 silex FTP daemon.` | `0x37d8f0` | `SYST` reply — reveals the silex lineage |
| `214-silex FTPD supported commands(RFC959 subset + RFC2428):` | `0x35eab0` | `HELP` |
| `215-This product was developped by:` + staff names | `0x35eb8c` | silex easter-egg (`SITE`/`STAT` staff list) |

Login: `USER` → `331 Password required.`, any `PASS` → `230 User Logged in.`
(there is a `530 Login incorrect.` path but the default config accepts the
anonymous/`root` login — authentication is effectively open).

Advertised command set (`HELP`, `0x35eac8`..):

```
LIST NLST STOR STOU APPE XCWD CWD  XPWD PWD  XCUP CDUP
USER PASS TYPE PORT PASV ABOR SYST STAT HELP NOOP QUIT
SITE MODE STRU EPRT EPSV
```

Note there is **no `DELE`, `RNFR/RNTO`, `MKD`, `RMD`** — consistent with a
fixed, synthetic namespace rather than a real writable filesystem.

## 2. The virtual filesystem — every path the parser traverses

Path resolution is `ftp_resolve_path` (`0x30a8d0`, renamed from `sub_0030a8d0`).
It takes the session object, a path string, and an out-slot, and walks **one
component at a time**. The current directory is held at `session+0xb8`.

The component grammar it recognises is small and fully enumerable:

| component | resolves to | handler path |
|---|---|---|
| `/` or `\` (leading) | **root directory node** `ftp_root_node` (`0x33a6b4`, flags `0x30000`) | sets out-slot = `0x33a6b4` |
| `.` | current node (no move) | — |
| `..` | parent node = `[node+8]` | — |
| any other name | looked up via `node_find_by_name` (`0x30f8b4`), then `node_find_or_default` (`0x30f978`) | copies ≤ `0x1f` chars, stops at `/` or `\` |

Names resolve against **`ftp_node_table`** (`0x33a654`), an array of 24-byte
(`0x18`) records, each laid out as:

```
+0x00  char*  name
+0x04  char*  "@"+name          ; alternate / mount token
+0x08  void*  parent (0 = root) ; followed by ".."
+0x0c  u32    flags             ; access bits (see §3)
+0x0e  u16    id                ; secondary match key for node_find_by_type
+0x14  u16    type
```

Because `node_find_by_name` **pre-increments** (`r4 += 0x18` *before* the first
compare), the head record is a sentinel that is never returned by name. The
three populated records are:

| record | name | flags | name-resolvable? | role |
|---|---|---|---|---|
| `0x33a654` | `null`  | `0x30022` | **no** (list head / sentinel) | `/dev/null`-style **write-only discard sink**; also assigned directly by the dispatcher, not via name |
| `0x33a66c` | `syslog`| `0x30011` | **yes** | **read-only** node → `RETR syslog` streams the device **system log** (see §4) |
| `0x33a684` | `flash` | `0x20`    | **yes** | **write** node → feeds the firmware overwrite path (`VPFTPLDR`, see §5) |

So the complete set of traversable paths is:

```
/              -> root directory (LIST shows: null, syslog, flash)
.              -> current dir
..             -> parent
/syslog        -> system log            (readable)
/flash         -> firmware flash region (writable; dangerous)
/null          -> discard sink          (listed, write sink; not name-resolvable)
<anything else> -> ftp_default_job (0x2f1120), the current print-job node
                   (NULL when the hub is idle -> "550 Unknown printer.")
```

**Interesting ones to check:** `syslog` (info disclosure, §4) and `flash`
(unauthenticated firmware write, §5). `null` and the default-job fallback are
inert on an idle hub.

`LIST`/`NLST` (`ftp_cmd_list`, `0x30aa0c`) emits `total 0` then one line per
node via `ftp_format_list_perms` (`0x30a9ac`), which turns the flag word into a
`d---------`-style permission string (bit `0x11` → `r`, bit `0x22` → `w`). Every
entry is reported as a zero-byte `nobody nobody` pseudo-file dated
`Jan 1 1970` (`0x37dda0`), confirming there is no real directory metadata.

## 3. STOR / RETR semantics (a print spooler, not a file store)

`STOR`/`STOU`/`APPE` → `ftp_cmd_stor` (`0x30b5bc`):

1. `ftp_resolve_path` the target name to a node.
2. If the node has no backing object (`[node+8]==0`) → `550 Unknown printer.`
3. Check the write bit in the node flags (`0x20`); if clear → `550 Permission
   denied.`
4. `150 Open data connection.`, accept the data channel, then **spool the
   uploaded bytes as a print job** — it stores job fields (`+0xbc` source,
   `+0xc0` device, type `3`, state at `+0x22`), calls the spooler at
   `0x32b4dc`, and logs `!FTPD:STOR(%s) from %SA`.

`RETR` → `ftp_cmd_retr` (`0x30b690`): same resolve + `550 Unknown printer.` /
`550 Permission denied.` guards, then opens the data connection and streams the
node's contents, logging `!FTPD:RETR(%s) from %SA`.

The print-job framing strings (`* Printer :`, `* From :`, `* File name :`,
`* User name :`, and the `jfilter` PostScript header `%!PS-Adobe-2.0`,
`0x35ec70`..`0x35ed74`) confirm uploads to a printer node are wrapped as print
jobs — the FTP front-end to the same LPD path named by the
`PORT1..PORT4 FTP/LPD Banner` config strings. On the F5L009 no printer is wired
into this path, so those nodes stay empty; only `syslog`/`flash` carry data.

## 4. `syslog` — downloadable system log

`syslog` (`0x33a66c`, flags `0x30011` = read bit set, no write bit) is a
**read-only** node in the root directory. Because it resolves by name, it can be
pulled straight off the device:

```
ftp 192.168.2.3            # USER root, empty PASS
ftp> binary
ftp> get syslog            # RETR syslog
```

It streams the device's **system message log** — the same text that the
`printf_log` pipeline (`0x336f24`) emits: level-tagged lines
(`#`=err `!`=warn `?`=info, else debug), e.g. the `SXUP_ALC`/`#TCP` lease and
keepalive diagnostics, `EEP:Stats[...]`, `Excepion code:` / `RESTART` records,
and the `!FTPD:…` connection events. This is genuinely useful for the
keepalive/wedge investigation in
[`tcp_connection_and_keepalive.md`](tcp_connection_and_keepalive.md).

> **Cross-reference / correction.** [`ram/symbols.txt`](ram/symbols.txt) and
> the Tier-1 recon note previously concluded the printf ring buffer was *not*
> reachable over the network (JCP `EXEC PRINT DIAGNOSTIC`/`CONFIGDATA` return an
> empty ack; the web `loginfo.htm` is a separate app-level USB-event log).
> `RETR syslog` on port 21 is a **distinct, previously-unnoticed network path**
> to the system log. It should be captured and compared against the UART
> console output to confirm whether it exposes the full `0x2f620c` ring (and
> therefore `sa_age`/`Salc` lease state) without opening the hub.
>
> **Not captured in this session:** the device lives on the LAN
> (`192.168.2.3`); this analysis ran in a cloud container with no route to that
> subnet, so `RETR syslog` timed out. Run the `get syslog` above on a host on
> the hub's network and drop the capture next to this file (e.g.
> `syslog_capture.txt`) to document the exact contents.

## 5. `flash` — firmware overwrite node (`VPFTPLDR`)

`flash` (`0x33a684`, flags `0x20` = write) is the FTP face of the silex
firmware loader, `vpftpldr_init` (`0x2fb3a0`): it allocates `FTPLDRBUF`, logs
`Loader port init.` and `VPFTPLDR:Get %lx Used[ %lx / %lx ]`, and feeds the
`Farmware overwrite` (sic) flash-program path. This is the FTP counterpart to
the web `update.htm` → `.VUP` mechanism documented in
[`management_and_flash.md`](management_and_flash.md): an image uploaded via
`STOR flash` lands in `FTPLDRBUF` and the loader overwrites application flash at
`0x20000`. Combined with the open login this is an **unauthenticated firmware
write** surface and should be treated as the primary security concern of this
daemon.

## 6. Renamed symbols

Added to [`ram/symbols.txt`](ram/symbols.txt):

| addr | name | was |
|---|---|---|
| `0x0030a8d0` | `ftp_resolve_path` | `sub_0030a8d0` |
| `0x0030a9ac` | `ftp_format_list_perms` | `sub_0030a9ac` |
| `0x0030aa0c` | `ftp_cmd_list` | `sub_0030aa0c` |
| `0x0030ad40` | `ftp_send_greeting` | — |
| `0x0030b594` | `ftp_cmd_stru` | `sub_0030b594` |
| `0x0030b5bc` | `ftp_cmd_stor` | `sub_0030b5bc` |
| `0x0030b690` | `ftp_cmd_retr` | `sub_0030b690` |
| `0x0030f8b4` | `node_find_by_name` | `sub_0030f8b4` |
| `0x0030f93c` | `node_find_by_type` | `sub_0030f93c` |
| `0x0030f978` | `node_find_or_default` | `sub_0030f978` |
| `0x0030f9cc` | `node_set_default` | `sub_0030f9cc` |
| `0x002fb3a0` | `vpftpldr_init` | `sub_002fb3a0` |
| `0x0033a654` | `ftp_node_table` (data) | — |
| `0x0033a6b4` | `ftp_root_node` (data) | — |
| `0x002f1120` | `ftp_default_job` (data) | — |

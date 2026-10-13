--
-- sxuptp.lua -- Wireshark/tshark dissector for Silex SXUPTP (USB-over-IP), TCP+UDP 19540
--
-- SXUPTP = Silex USB Peripheral/Print Transport Protocol, as used by the Belkin
-- F5L009 "Network USB Hub" and Silex SX-2000U2. Reverse-engineered in this repo;
-- see proprietary-Belkin-Silex/analysis/F5L009_v1.2.0/ and bridge/SXUPTP_PROTOCOL.md.
-- All SXUPTP header integers are BIG-endian (firmware uses ntohs/ntohl); the USB
-- payloads inside (CBW/CSW/descriptors) keep their native USB LITTLE-endian order.
--
-- Two transports on port 19540:
--   * UDP  = JCP control (discovery / identify / config / SCANNER CONNECT|DISCONNECT)
--   * TCP  = the data channel (control / bulk / interrupt URBs, 10-byte replies)
--
-- Install: copy to your Wireshark "Personal Lua Plugins" folder
--   (Help > About Wireshark > Folders), or run:
--     wireshark -X lua_script:tools/wireshark/sxuptp.lua
--     tshark    -X lua_script:tools/wireshark/sxuptp.lua -O sxuptp
-- If your SXUPTP runs on a non-default port, edit SXUPTP_PORT below.
--
local SXUPTP_PORT = 19540

-- Wireshark port_type enum (epan/address.h): PT_TCP = 2, PT_UDP = 3
local PT_TCP, PT_UDP = 2, 3

local sxuptp = Proto("sxuptp", "Silex SXUPTP (USB-over-IP)")

----------------------------------------------------------------------
-- lookup tables
----------------------------------------------------------------------
local DATA_TYPE = {   -- data-channel first u16 (dir bit 0x8000 = host->device)
  [0x0001] = "CONTROL-IN (read)",
  [0x8001] = "CONTROL-OUT (write)",
  [0x0002] = "INTERRUPT-IN",
  [0x0003] = "BULK-IN (read)",
  [0x8003] = "BULK-OUT (write)",
}
local CAT_NAME = { [1] = "control", [2] = "interrupt", [3] = "bulk" }

local USB_REQ = {  -- standard bRequest
  [0]="GET_STATUS", [1]="CLEAR_FEATURE", [3]="SET_FEATURE", [5]="SET_ADDRESS",
  [6]="GET_DESCRIPTOR", [7]="SET_DESCRIPTOR", [8]="GET_CONFIGURATION",
  [9]="SET_CONFIGURATION", [10]="GET_INTERFACE", [11]="SET_INTERFACE", [12]="SYNCH_FRAME",
}
local USB_DESC = { [1]="DEVICE",[2]="CONFIG",[3]="STRING",[4]="INTERFACE",
  [5]="ENDPOINT",[6]="DEVICE_QUALIFIER",[7]="OTHER_SPEED_CONFIG",[0x29]="HUB" }

local SCSI_OP = {
  [0x00]="TEST_UNIT_READY", [0x03]="REQUEST_SENSE", [0x12]="INQUIRY",
  [0x15]="MODE_SELECT(6)", [0x1a]="MODE_SENSE(6)", [0x1b]="START_STOP_UNIT",
  [0x1e]="PREVENT_ALLOW_REMOVAL", [0x23]="READ_FORMAT_CAPACITIES",
  [0x25]="READ_CAPACITY(10)", [0x28]="READ(10)", [0x2a]="WRITE(10)",
  [0x2f]="VERIFY(10)", [0x35]="SYNCHRONIZE_CACHE", [0x5a]="MODE_SENSE(10)",
  [0x9e]="READ_CAPACITY(16)/SAI", [0xa8]="READ(12)", [0xaa]="WRITE(12)",
}
local CSW_STATUS = { [0]="PASSED", [1]="FAILED", [2]="PHASE_ERROR" }

local JCP_CLASS = {   -- UDP first u16 (request command / reply code)
  [1]="JCP get/set (class 1)", [2]="JCP (class 2)", [3]="JCP get/set (class 3)",
  [4]="IDENTIFY/DISCOVER", [0x0002]="reply", [0x0064]="SCANNER DISCONNECT",
}

----------------------------------------------------------------------
-- fields
----------------------------------------------------------------------
local f = sxuptp.fields
-- common / data-channel
f.d_type   = ProtoField.uint16("sxuptp.type", "Type", base.HEX, DATA_TYPE)
f.d_dir    = ProtoField.string("sxuptp.dir", "Direction")
f.d_cat    = ProtoField.uint8 ("sxuptp.category", "Category", base.DEC, CAT_NAME)
f.d_seq    = ProtoField.uint16("sxuptp.seq", "Seq / tag")
f.d_field0 = ProtoField.uint16("sxuptp.field0", "Field0 (cosmetic)", base.HEX)
f.d_devid  = ProtoField.uint8 ("sxuptp.devid", "devId (USB address)", base.DEC)
f.d_ep     = ProtoField.uint8 ("sxuptp.ep", "Endpoint", base.HEX)
f.d_mps    = ProtoField.uint16("sxuptp.mps", "0x8000|wMaxPacketSize", base.HEX)
f.d_xferlen= ProtoField.uint32("sxuptp.xferlen", "Transfer length")
f.d_interval=ProtoField.uint16("sxuptp.interval", "Interval (ms)")
-- reply
f.r_status = ProtoField.uint16("sxuptp.status", "Status", base.HEX, {[0]="OK",[0xffff]="FAIL"})
f.r_size   = ProtoField.uint16("sxuptp.size", "Data size")
f.data     = ProtoField.bytes ("sxuptp.data", "Data")
-- USB SETUP (control)
f.s_bmreq  = ProtoField.uint8 ("sxuptp.setup.bmRequestType", "bmRequestType", base.HEX)
f.s_breq   = ProtoField.uint8 ("sxuptp.setup.bRequest", "bRequest", base.DEC, USB_REQ)
f.s_wval   = ProtoField.uint16("sxuptp.setup.wValue", "wValue", base.HEX)
f.s_widx   = ProtoField.uint16("sxuptp.setup.wIndex", "wIndex", base.HEX)
f.s_wlen   = ProtoField.uint16("sxuptp.setup.wLength", "wLength", base.DEC)
-- SCSI BOT
f.scsi_tag = ProtoField.uint32("sxuptp.scsi.tag", "CBW/CSW tag", base.HEX)
f.scsi_op  = ProtoField.uint8 ("sxuptp.scsi.op", "SCSI opcode", base.HEX, SCSI_OP)
f.scsi_dlen= ProtoField.uint32("sxuptp.scsi.dlen", "CBW data length")
f.scsi_res = ProtoField.uint32("sxuptp.scsi.residue", "CSW residue")
f.scsi_st  = ProtoField.uint8 ("sxuptp.scsi.status", "CSW status", base.DEC, CSW_STATUS)
-- JCP (UDP)
f.j_cmd    = ProtoField.uint16("sxuptp.jcp.cmd", "Command / code", base.HEX, JCP_CLASS)
f.j_sub    = ProtoField.uint16("sxuptp.jcp.sub", "Subcommand", base.HEX)
f.j_name   = ProtoField.string("sxuptp.jcp.name", "JCP verb")
f.j_rstat  = ProtoField.uint16("sxuptp.jcp.status", "Reply status", base.HEX)
f.j_rlen   = ProtoField.uint16("sxuptp.jcp.len", "Reply length")
f.j_body   = ProtoField.bytes ("sxuptp.jcp.body", "Body")
-- identity reply decoded fields
f.id_model = ProtoField.string("sxuptp.id.model", "Model")
f.id_mac   = ProtoField.string("sxuptp.id.mac", "MAC")
f.id_ip    = ProtoField.string("sxuptp.id.ip", "IP")
f.id_ver   = ProtoField.string("sxuptp.id.version", "JCP version")
f.id_usb   = ProtoField.string("sxuptp.id.usb", "Attached USB device")
f.id_host  = ProtoField.string("sxuptp.id.host", "Hostname")
f.id_fw    = ProtoField.string("sxuptp.id.firmware", "Firmware")

----------------------------------------------------------------------
-- helpers
----------------------------------------------------------------------
local function is_to_hub(pinfo) return pinfo.dst_port == SXUPTP_PORT end

local function cstr(tvb, off)  -- NUL/printable-terminated ASCII at off
  local n = tvb:len()
  if off >= n then return "", 0 end
  local e = off
  while e < n do
    local b = tvb(e,1):uint()
    if b == 0 or b < 0x20 or b > 0x7e then break end
    e = e + 1
  end
  if e == off then return "", 0 end
  return tvb(off, e-off):string(), e-off
end

----------------------------------------------------------------------
-- SCSI CBW/CSW inside bulk payloads (USB mass-storage, little-endian)
----------------------------------------------------------------------
local function dissect_scsi(tvb, tree, pinfo)
  if tvb:len() < 4 then return end
  local sig = tvb(0,4):string()
  if sig == "USBC" and tvb:len() >= 31 then          -- Command Block Wrapper
    local op = tvb(15,1):uint()
    local st = tree:add(sxuptp, tvb(0,31), "SCSI CBW")
    st:add_le(f.scsi_tag,  tvb(4,4))
    st:add_le(f.scsi_dlen, tvb(8,4))
    st:add(f.scsi_op, tvb(15,1))
    local cdblen = tvb(14,1):uint()
    if cdblen > 0 and cdblen <= 16 then st:add(tvb(15, math.min(cdblen,16)), "CDB") end
    pinfo.cols.info:append(string.format("  CBW %s", SCSI_OP[op] or string.format("op 0x%02x", op)))
    return
  end
  if sig == "USBS" and tvb:len() >= 13 then           -- Command Status Wrapper
    local stn = tvb(12,1):uint()
    local st = tree:add(sxuptp, tvb(0,13), "SCSI CSW")
    st:add_le(f.scsi_tag, tvb(4,4))
    st:add_le(f.scsi_res, tvb(8,4))
    st:add(f.scsi_st, tvb(12,1))
    pinfo.cols.info:append(string.format("  CSW %s", CSW_STATUS[stn] or "?"))
  end
end

----------------------------------------------------------------------
-- data channel (TCP)
----------------------------------------------------------------------
-- Return total message length at `off`, or nil if more bytes are needed.
local function data_msg_len(tvb, off, to_hub)
  local avail = tvb:len() - off
  if to_hub then
    if avail < 2 then return nil end
    local t = tvb(off,2):uint()
    local cat = t % 256
    if cat == 1 then                       -- control, 22-byte header
      if avail < 22 then return nil end
      if t == 0x8001 then return 22 + tvb(off+20,2):uint() end   -- +payload (wLength)
      return 22
    elseif cat == 3 then                   -- bulk, 18-byte header
      if avail < 18 then return nil end
      if t == 0x8003 then return 18 + tvb(off+16,2):uint() end   -- +payload (len16)
      return 18
    elseif cat == 2 then                   -- interrupt, 18-byte header
      return 18
    else
      return nil                            -- unknown request type
    end
  else                                      -- reply: 10-byte header + size
    if avail < 10 then return nil end
    return 10 + tvb(off+8,2):uint()
  end
end

local function dissect_data_msg(tvb, pinfo, tree, to_hub)
  local t = tvb(0,2):uint()
  local tname = DATA_TYPE[t] or string.format("type 0x%04x", t)
  local sub = tree:add(sxuptp, tvb(), "SXUPTP " .. (to_hub and "request" or "reply") .. ": " .. tname)
  sub:add(f.d_type, tvb(0,2))
  sub:add(f.d_dir, tvb(0,0), to_hub and "host -> hub" or "hub -> host")
  sub:add(f.d_cat, tvb(1,1), t % 256)
  sub:add(f.d_seq, tvb(2,2))

  if not to_hub then                         -- 10-byte reply header + data
    sub:add(f.d_field0, tvb(4,2))            -- actually status slot; show both
    sub:add(f.r_status, tvb(4,2))
    sub:add(f.r_size, tvb(8,2))
    local size = tvb(8,2):uint()
    pinfo.cols.info:append(string.format("reply %s seq=%d size=%d%s",
      tname, tvb(2,2):uint(), size, tvb(4,2):uint()==0xffff and " FAIL" or ""))
    if size > 0 and tvb:len() >= 10 then
      local dtvb = tvb(10, math.min(size, tvb:len()-10))
      sub:add(f.data, dtvb)
      dissect_scsi(dtvb:tvb(), sub, pinfo)   -- CSW on bulk-IN replies
    end
    return
  end

  -- request
  local cat = t % 256
  sub:add(f.d_field0, tvb(4,2))
  sub:add(f.d_devid, tvb(6,1))
  sub:add(f.d_ep, tvb(7,1))
  pinfo.cols.info:append(string.format("%s seq=%d dev=%d ep=0x%02x",
    tname, tvb(2,2):uint(), tvb(6,1):uint(), tvb(7,1):uint()))

  if cat == 1 then                            -- control: SETUP at +0x0C
    local bm, br = tvb(12,1):uint(), tvb(13,1):uint()
    local setup = sub:add(sxuptp, tvb(12,10), "USB SETUP")
    setup:add(f.s_bmreq, tvb(12,1))
    setup:add(f.s_breq, tvb(13,1))
    setup:add(f.s_wval, tvb(14,2))            -- SXUPTP SETUP fields are big-endian
    setup:add(f.s_widx, tvb(16,2))            --   (firmware packs >BBHHI, not USB LE)
    setup:add(f.s_wlen, tvb(20,2))
    local note = USB_REQ[br] or string.format("req 0x%02x", br)
    if br == 6 then
      local dt = tvb(14,1):uint()             -- descriptor type = high byte of BE wValue
      note = note .. " " .. (USB_DESC[dt] or string.format("0x%02x", dt))
    end
    pinfo.cols.info:append("  " .. note)
    if t == 0x8001 and tvb:len() > 22 then    -- control-OUT payload
      sub:add(f.data, tvb(22))
    end
  elseif cat == 3 then                        -- bulk
    sub:add(f.d_mps, tvb(10,2))
    sub:add(f.d_xferlen, tvb(16,2))
    if t == 0x8003 and tvb:len() > 18 then     -- bulk-OUT payload
      local dtvb = tvb(18)
      sub:add(f.data, dtvb)
      dissect_scsi(dtvb:tvb(), sub, pinfo)     -- CBW on bulk-OUT
    end
  elseif cat == 2 then                        -- interrupt
    sub:add(f.d_mps, tvb(10,2))
    sub:add(f.d_interval, tvb(12,2))
    sub:add(f.d_xferlen, tvb(16,2))
  end
end

local function dissect_tcp(tvb, pinfo, tree)
  local to_hub = is_to_hub(pinfo)
  local off = 0
  local n = tvb:len()
  while off < n do
    local mlen = data_msg_len(tvb, off, to_hub)
    if mlen == nil then
      -- need more bytes; ask for reassembly
      pinfo.desegment_offset = off
      pinfo.desegment_len = DESEGMENT_ONE_MORE_SEGMENT
      return n
    end
    if off + mlen > n then
      pinfo.desegment_offset = off
      pinfo.desegment_len = (off + mlen) - n
      return n
    end
    dissect_data_msg(tvb(off, mlen):tvb(), pinfo, tree, to_hub)
    off = off + mlen
  end
  return n
end

----------------------------------------------------------------------
-- JCP control (UDP)
----------------------------------------------------------------------
local function dissect_identity_reply(tvb, tree, pinfo)
  -- cmd4/0x9506 reply, fixed offsets (see SXUPTP_PROTOCOL.md)
  if tvb:len() < 0x86 then return false end
  local id = tree:add(sxuptp, tvb(), "IDENTIFY reply")
  local function s(field, off) local v = cstr(tvb, off) if v ~= "" then id:add(field, tvb(off, #v), v) end return v end
  local model = s(f.id_model, 0x24)
  if tvb:len() >= 0x3e then
    local mac = {}
    for i=0,5 do mac[#mac+1] = string.format("%02x", tvb(0x38+i,1):uint()) end
    id:add(f.id_mac, tvb(0x38,6), table.concat(mac, ":"))
  end
  if tvb:len() >= 0x46 then
    id:add(f.id_ip, tvb(0x42,4), string.format("%d.%d.%d.%d",
      tvb(0x42,1):uint(), tvb(0x43,1):uint(), tvb(0x44,1):uint(), tvb(0x45,1):uint()))
  end
  s(f.id_ver, 0x48); local usb = s(f.id_usb, 0x54); s(f.id_host, 0x74); local fw = s(f.id_fw, 0x84)
  pinfo.cols.info:append(string.format("IDENTIFY: %s / %s / fw %s", model, usb, fw))
  return true
end

local function dissect_udp(tvb, pinfo, tree)
  local n = tvb:len()
  if n < 2 then return 0 end
  local root = tree:add(sxuptp, tvb(), "SXUPTP JCP")
  local to_hub = is_to_hub(pinfo)
  local cmd = tvb(0,2):uint()

  if to_hub then                              -- request
    root:add(f.j_cmd, tvb(0,2))
    if n >= 4 then root:add(f.j_sub, tvb(2,2)) end
    if cmd == 4 then
      pinfo.cols.info:append("IDENTIFY/DISCOVER request")
    else
      local name = (n > 4) and cstr(tvb, 4) or ""
      if name ~= "" then
        root:add(f.j_name, tvb(4, #name))
        pinfo.cols.info:append("JCP: " .. name)
      else
        pinfo.cols.info:append(string.format("JCP cmd=0x%04x", cmd))
      end
    end
    return n
  end

  -- reply
  if n >= 4 and tvb(2,2):uint() == 0x9506 then
    root:add(f.j_cmd, tvb(0,2))
    root:add(f.j_sub, tvb(2,2))
    dissect_identity_reply(tvb, root, pinfo)
    return n
  end
  -- generic reply header {cmd, status, resv, length, body}
  root:add(f.j_cmd, tvb(0,2))
  if n >= 4 then root:add(f.j_rstat, tvb(2,2)) end
  if n >= 8 then
    local blen = tvb(6,2):uint()
    root:add(f.j_rlen, tvb(6,2))
    if blen > 0 and n >= 8 then
      local body = tvb(8, math.min(blen, n-8))
      root:add(f.j_body, body)
      local txt = cstr(tvb, 8)
      if txt ~= "" then pinfo.cols.info:append("JCP reply: " .. txt)
      else pinfo.cols.info:append(string.format("JCP reply len=%d", blen)) end
    else
      pinfo.cols.info:append("JCP reply (empty / no-change)")
    end
  end
  return n
end

----------------------------------------------------------------------
-- entry
----------------------------------------------------------------------
function sxuptp.dissector(tvb, pinfo, tree)
  if tvb:len() == 0 then return 0 end
  pinfo.cols.protocol = "SXUPTP"
  pinfo.cols.info:clear()
  if pinfo.port_type == PT_UDP then
    return dissect_udp(tvb, pinfo, tree)
  else
    return dissect_tcp(tvb, pinfo, tree)
  end
end

local udp_table = DissectorTable.get("udp.port")
local tcp_table = DissectorTable.get("tcp.port")
udp_table:add(SXUPTP_PORT, sxuptp)
tcp_table:add(SXUPTP_PORT, sxuptp)

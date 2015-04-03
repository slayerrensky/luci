local uci = require "luci.model.uci".cursor()
local sys = require "luci.sys"
local util = require "luci.util"
local ip = require "luci.ip"

m = Map("bebox", translate("Config Wireless"), translate("Set a neu SSID and Wirelss Key and validate with you password."))
d = m:section(TypedSection, "bebox", "User Configuration")
a = d:option(Value, "passwort", "User Password"); a.optional=false; a.rmempty = false;

return m


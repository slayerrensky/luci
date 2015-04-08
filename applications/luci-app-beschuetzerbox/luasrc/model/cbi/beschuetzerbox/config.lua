local uci = require "luci.model.uci".cursor()
local sys = require "luci.sys"
local util = require "luci.util"
local ip = require "luci.ip"

m = Map("bebox", translate("Config Wireless"), translate("Set configurations for the customer."))
d = m:section(TypedSection, "bebox", "User Configuration")
a = d:option(Value, "password", "User Password"); a.optional=false; a.rmempty = false;

return m


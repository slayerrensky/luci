local uci = require "luci.model.uci".cursor()
local sys = require "luci.sys"
local util = require "luci.util"
local ip = require "luci.ip"

m = Map("cbi_file", translate("First Tab Form"), translate("Please fill out the form below")) -- cbi_file is the config file in /etc/config
d = m:section(TypedSection, "info", "Part A of the form")  -- info is the section called info in cbi_file
a = d:option(Value, "name", "Name"); a.optional=false; a.rmempty = false;  -- name is the option in the cbi_file

function cbi_configure(device)
        local configure = n:taboption(device, Flag, device .. "_config", translate("Configure this interface"),
                translate("Note: this will set up this interface for mesh operation, i.e. add it to zone 'freifunk' and enable olsr."))
end


return m

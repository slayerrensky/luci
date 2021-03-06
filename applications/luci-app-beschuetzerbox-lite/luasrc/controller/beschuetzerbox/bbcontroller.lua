module("luci.controller.beschuetzerbox.bbcontroller", package.seeall)  --notice that new_tab is the name of the file new_tab.lua
 
function index()

        local uci = require "luci.model.uci".cursor()
        local page

        -- Frontend
        page          = node()
        page.lock     = true
        page.target   = alias("bebox")
        page.subindex = true
        page.index    = false

        page          = node("bebox")
        page.title    = _("Konfiguration")
        page.target   = alias("bebox", "index")
        page.order    = 5
        page.setuser  = "nobody"
        page.setgroup = "nogroup"
        --page.i18n     = "freifunk"
        page.index    = true

        page          = node("bebox", "index")
        page.target   = template("beschuetzerbox/index")
        page.title    = _("Übersicht")
        page.order    = 10
        page.indexignore = true

        page          = node("bebox", "config")
        page.target   = template("beschuetzerbox/status")
        page.title    = _("Konfiguration")
        page.order    = 20
        page.i18n     = "base"
        page.setuser  = false
        page.setgroup = false

	-- Frondand http get Functions
	page = entry({"bebox", "config", "commit_wireless"}, call("commit_wireless"), nil)
        page.leaf = true
	page = entry({"bebox", "config", "commit_password"}, call("commit_password"), nil)
        page.leaf = true
	page = entry({"bebox", "config", "commit_setup"}, call("commit_setup"), nil)
        page.leaf = true

	if nixio.fs.access("/etc/config/dhcp") then	
		page = entry({"bebox", "config", "get_dhcp"}, call("lease_status"), nil)
	        page.leaf = true
	end

	local has_wifi = false

        uci:foreach("wireless", "wifi-device",
                function(s)
                         has_wifi = true
                         return false
                end)

        if has_wifi then
                page = entry({"bebox", "config", "wireless_status"}, call("wifi_status"), nil)
                page.leaf = true
	end
	-- Frontand

        entry({"bebox", "index", "zeroes"}, call("zeroes"), "Testdownload")
	entry({"bebox", "config", "status"}, template("beschuetzerbox/status"),"Status", 50)
	entry({"bebox", "config", "wireless_set"}, template("beschuetzerbox/wireless_set"),"Wireless", 50)
	entry({"bebox", "config", "password_set"}, template("beschuetzerbox/password_set"),"Passwort", 60)
	entry({"bebox", "config", "setup_set"}, template("beschuetzerbox/setup_set"),"Einrichten", 80)
	
	-- Backand
	entry({"admin", "bebox"}, firstchild(), "Beschuetzerbox", 30).dependent=false
	entry({"admin", "bebox", "config"}, cbi("beschuetzerbox/config"), "Config", 1)

end


function zeroes()
        local string = require "string"
        local http = require "luci.http"
        local zeroes = string.rep(string.char(0), 8192)
        local cnt = 0
        local lim = 1024 * 1024 * 1024

        http.prepare_content("application/x-many-zeroes")

        while cnt < lim do
                http.write(zeroes)
                cnt = cnt + #zeroes
        end
end

function commit_wireless(ssid, key, password)
        luci.http.prepare_content("text/plain")
        a = string.format("wifiuserset.sh '%s' '%s' '%s'",ssid, key, password)
        local util = io.popen(a)
        if util then
                while true do
                        local ln = util:read("*l")
                        if not ln then break end
                        -- luci.http.write(a)
                        luci.http.write(ln)
                        luci.http.write("\n")
                end

                util:close()
        end
        -- luci.http.write(a)
        -- luci.http.write("\n")

end


function commit_password(newpass, oldpass)
        luci.http.prepare_content("text/plain")
        a = string.format("passwordset.sh '%s' '%s'",newpass, oldpass)
        local util = io.popen(a)
        if util then
                while true do
                        local ln = util:read("*l")
                        if not ln then break end
                        -- luci.http.write(a)
                        luci.http.write(ln)
                        luci.http.write("\n")
                end

                util:close()
        end
        -- luci.http.write(a)
        -- luci.http.write("\n")

end

function commit_setup(hostname ,fastd, key2, ipaddr, password )
        luci.http.prepare_content("text/plain")
        a = string.format("setupset.sh '%s' '%s' '%s' '%s' '%s' ",hostname, fastd, key2, ipaddr, password)
        local util = io.popen(a)
        if util then
                while true do
                        local ln = util:read("*l")
                        if not ln then break end
                        -- luci.http.write(a)
                        luci.http.write(ln)
                        luci.http.write("\n")
                end

                util:close()
        end
end

function lease_status()
        local s = require "luci.tools.status"

        luci.http.prepare_content("application/json")
        luci.http.write('[')
	luci.http.write_json(s.dhcp_leases())
	luci.http.write(']')

end

function wifi_status(devs)
        local s    = require "luci.tools.status"
        local rv   = { }

        local dev
        for dev in devs:gmatch("[%w%.%-]+") do
                rv[#rv+1] = s.wifi_network(dev)
        end

        if #rv > 0 then
                luci.http.prepare_content("application/json")
                luci.http.write_json(rv)
                return
        end

        luci.http.status(404, "No such device")
end


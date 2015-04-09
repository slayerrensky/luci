module("luci.controller.beschuetzerbox.bbcontroller", package.seeall)  --notice that new_tab is the name of the file new_tab.lua
module("luci.tools.status", package.seeall)

local uci = require "luci.model.uci".cursor()
 
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
        page.title    = _("Beschuetzerbox")
        page.target   = alias("bebox", "index")
        page.order    = 5
        page.setuser  = "nobody"
        page.setgroup = "nogroup"
        --page.i18n     = "freifunk"
        page.index    = true

        page          = node("bebox", "index")
        page.target   = template("beschuetzerbox/index")
        page.title    = _("&Uuml;ebersicht")
        page.order    = 10
        page.indexignore = true

        page          = node("bebox", "config")
        page.target   = template("beschuetzerbox/config")
        page.title    = _("Config")
        page.order    = 20
        page.i18n     = "base"
        page.setuser  = false
        page.setgroup = false

	page = entry({"bebox", "config", "commit_wireless"}, call("commit_wireless"), nil)
        page.leaf = true
	page = entry({"bebox", "config", "commit_password"}, call("commit_password"), nil)
        page.leaf = true

        entry({"bebox", "index", "zeroes"}, call("zeroes"), "Testdownload")
	entry({"bebox", "config", "wireless_set"}, template("beschuetzerbox/wireless_set"),"Wireless", 50)
	entry({"bebox", "config", "password_set"}, template("beschuetzerbox/password_set"),"Passwort", 60)
	
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
        a = string.format("wifiuserset.sh %s %s %s",ssid, key, password)
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
        a = string.format("passwordset.sh %s %s",newpass, oldpass)
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


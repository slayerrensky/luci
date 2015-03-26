module("luci.controller.beschuetzerbox.bbcontroller", package.seeall)  --notice that new_tab is the name of the file new_tab.lua
 
function index()

        local uci = require "luci.model.uci".cursor()
        local page

        -- Frontend
        page          = node()
        page.lock     = true
        page.target   = alias("freifunk")
        page.subindex = true
        page.index    = false

        page          = node("freifunk")
        page.title    = _("Freifunk")
        page.target   = alias("freifunk", "index")
        page.order    = 5
        page.setuser  = "nobody"
        page.setgroup = "nogroup"
        page.i18n     = "freifunk"
        page.index    = true

        page          = node("freifunk", "index")
        page.target   = template("beschuetzerbox/index")
        page.title    = _("Overview")
        page.order    = 10
        page.indexignore = true

        page          = node("freifunk", "status")
        page.target   = template("beschuetzerbox/wireless")
        page.title    = _("Wireless")
        page.order    = 20
        page.i18n     = "base"
        page.setuser  = false
        page.setgroup = false

	page = entry({"freifunk", "status", "diag_ping"}, call("diag_ping"), nil)
        page.leaf = true

        entry({"freifunk", "status.json"}, call("jsonstatus"))
        entry({"freifunk", "index", "zeroes"}, call("zeroes"), "Testdownload")
	entry({"freifunk", "status", "wireless_set"}, cbi("beschuetzerbox/wireless"),"Set Wifi", 50)


entry({"beschuetzerbox", "bbcontroller"}, firstchild(), "Beschuetzerbox", 30).dependent=false  --this adds the top level tab and defaults to the first sub-tab (tab_from_cbi), also it is set to position 30

entry({"beschuetzerbox", "bbcontroller", "tab_from_cbi"}, cbi("beschuetzerbox/wireless"), "Wireless", 1)  --this adds the first sub-tab that is located in <luci-path>/luci-myapplication/model/cbi/myapp-mymodule and the file is called cbi_tab.lua, also set to first position

entry({"beschuetzerbox", "bbcontroller", "tab_from_view"}, template("beschuetzerbox/view_tab"), "View Tab", 2)  --this adds the second sub-tab that is located in <luci-path>/luci-myapplication/view/myapp-mymodule and the file is called view_tab.lua, also set to the second position
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

function diag_ping(addr)
        diag_command("ping -c 5 -W 1 %q 2>&1", addr)
end



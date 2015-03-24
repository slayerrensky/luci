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
        page.target   = template("freifunk/public_status")
        page.title    = _("Status")
        page.order    = 20
        page.i18n     = "base"
        page.setuser  = false
        page.setgroup = false

        entry({"freifunk", "status.json"}, call("jsonstatus"))
        entry({"freifunk", "status", "zeroes"}, call("zeroes"), "Testdownload")

        page = assign({"freifunk", "olsr"}, {"admin", "status", "olsr"}, _("OLSR"), 30)
        page.setuser = false
        page.setgroup = false

        if nixio.fs.access("/etc/config/luci_statistics") then
                assign({"freifunk", "graph"}, {"admin", "statistics", "graph"}, _("Statistics"), 40)
        end



entry({"beschuetzerbox", "bbcontroller"}, firstchild(), "Beschuetzerbox", 30).dependent=false  --this adds the top level tab and defaults to the first sub-tab (tab_from_cbi), also it is set to position 30

entry({"beschuetzerbox", "bbcontroller", "tab_from_cbi"}, cbi("beschuetzerbox/wireless"), "Wireless", 1)  --this adds the first sub-tab that is located in <luci-path>/luci-myapplication/model/cbi/myapp-mymodule and the file is called cbi_tab.lua, also set to first position

entry({"beschuetzerbox", "bbcontroller", "tab_from_view"}, template("beschuetzerbox/view_tab"), "View Tab", 2)  --this adds the second sub-tab that is located in <luci-path>/luci-myapplication/view/myapp-mymodule and the file is called view_tab.lua, also set to the second position
end

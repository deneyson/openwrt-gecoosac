
module("luci.controller.gecoosac", package.seeall)
local uci=require"luci.model.uci".cursor()

function index()
	if not nixio.fs.access("/etc/config/gecoosac") then
		return
	end

	local page
	page = entry({"admin", "services", "gecoosac"}, cbi("gecoosac"), _("Gecoos AC"), 100)
	page.dependent = true
	page = entry({"admin", "services", "gecoosac", "status"}, call("act_status"))
	page.leaf = true
end

function act_status()
	local e = {}
	e = {
		running = luci.sys.call("pgrep '/usr/bin/gecoosac' >/dev/null") == 0,
		port = uci:get("gecoosac", "config", "port")
	}
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end

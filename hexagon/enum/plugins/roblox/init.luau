--!strict

local path = script

local private = {}
local plugin = {}




-- Возвращает список функционала над камерой
function plugin.GetCamera ()
	return require(path.camera)
end

plugin.PluginRobloxPath = script

export type ancestors = self
export type self = typeof(plugin)

return plugin
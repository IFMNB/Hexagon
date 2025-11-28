--!strict

local replica = require('../../replica_link')


local enum = replica.GetEnums()
local network = replica.GetPluginProvider().GetNetwork()
local invoke = require('./')

local private = {}
local plugin = {}

function private.DoGetPlayerCamera (target: Player)
	local call = network.PathToRemote.GetCamera
	local camera : CFrame? = invoke.InvokeClient(target, call)
	return camera and typeof(camera) == 'CFrame' and camera or nil
end







-- Attempts to safely get the player's camera CFrame.
function plugin.GetPlayerCamera (player: Player) : CFrame?
	return private.DoGetPlayerCamera(player)
end

export type ancestors = self
export type self = typeof(plugin)

return plugin
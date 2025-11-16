--!strict

local replica = require('../../replica_link')
local network = replica.GetPluginProvider().GetNetwork()
local parent = require('./')

local private = {}
local plugin = {}

function private.DoGetPlayerCamera (target: Player)
	local call = network.PathToRemote.GetCamera
	local camera : CFrame? = parent.InvokeClient(target, call)
	return camera and typeof(camera) == 'CFrame' and camera or nil
end

-- Attempts to safely get the player's camera CFrame.
function plugin.GetPlayerCamera (player: Player) : CFrame?
	return private.DoGetPlayerCamera(player)
end

export type ancestors = self
export type self = typeof(plugin)

return plugin
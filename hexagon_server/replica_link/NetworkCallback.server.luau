--!strict

local replica = require('./')
local plugin = replica.GetPluginProvider()
local network = plugin.GetNetwork()

local path = plugin.GetNetwork().PathToRemote

path.Ping.OnServerInvoke = function (from: Player, to: Player?)
	if to then
		return path.Ping:InvokeClient(to)
	else
		return os.clock()
	end
end

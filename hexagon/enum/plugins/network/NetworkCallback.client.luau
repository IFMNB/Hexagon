--!strict

local network = require('./')
local path = network.PathToRemote


path.Ping.OnClientInvoke = function ()
	return os.clock()
end
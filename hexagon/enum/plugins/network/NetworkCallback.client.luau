--!strict

local global = require(game.ReplicatedStorage.global)
local hexagon = global.GetReplicatedHexagon()
local plugin = hexagon.GetPluginProvider()
local camera = plugin.GetRobloxProvider().GetCamera()
local enum = hexagon.GetEnums()

local network = require('./')
local path = network.PathToRemote
local private = {}


path.Ping.OnClientInvoke = function ()
	return os.clock()
end

path.GetCamera.OnClientEvent:Connect(function() 
	return path.GetCamera:FireServer(camera.GetCamera().CFrame)
end)

path.GetLoaded.OnClientEvent:Connect(function()
	path.GetLoaded:FireServer(game:IsLoaded())
	return
end)
--!strict

local global = require(game.ReplicatedStorage.global)
local hexagon = global.GetHexagon()
local plugin = hexagon.GetPluginProvider()
local camera = plugin.GetRobloxProvider().GetCamera()
local enum = hexagon.GetEnums()

local network = require('./')
local path = network.PathToRemote


path.Ping.OnClientInvoke = function ()
	return os.clock()
end

path.GetCamera.OnClientEvent:Connect(function() 
	return path.GetCamera:FireServer(camera.GetCamera().CFrame)
end)
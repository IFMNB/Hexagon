--!strict

local global = require(game.ReplicatedStorage.global)
local plugin = global.GetPluginProvider()
local camera = plugin.GetRobloxProvider().GetCamera()
local enum = global.GetEnums()

local network = require('./')
local path = network.PathToRemote


path.Ping.OnClientInvoke = function ()
	return os.clock()
end

path.GetCamera.OnClientEvent:Connect(function() 
	return path.GetCamera:FireServer(camera.GetCamera().CFrame)
end)
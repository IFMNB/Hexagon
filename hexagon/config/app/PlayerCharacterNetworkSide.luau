--!strict



local app = require('./')
local cfg = app.Config()
local enm = app.Enum()
local net = app.GetPluginProvider().GetNetwork()
local imp = app.GetPluginProvider().GetImported()
local plr = game.Players.LocalPlayer :: Player

assert(not game["Run Service"]:IsServer(), tostring(enm.Error.Forbidden))

local private = {}
local public = {}






function private.NetworkSideServer ()
	local char : Model = plr.Character or plr.CharacterAdded:Wait()
	public.CharacterUpdate = plr.CharacterAdded:Connect(function(character: Model) char = character end)
	public.RenderUpdate = public.Event.OnClientEvent:Connect(function(cframe: CFrame) char:PivotTo(cframe) end)
	public.RequestCaller = game["Run Service"].Heartbeat:Connect(function(deltaTime: number) public.Event:FireServer() end)
end

function private.NetworkSideClient ()
	local public = public :: any
	
	if public.CharacterUpdate then
		public.CharacterUpdate:Disconnect()
		public.CharacterUpdate=nil
	end
	if public.RenderUpdate then
		public.RenderUpdate:Disconnect()
		public.RenderUpdate=nil
	end
	if public.RequestCaller then
		public.RequestCaller:Disconnect()
		public.RequestCaller=nil
	end
end

function private.Run (self, a1, a2)
	imp.switch(a2,{
		[enm.Network.Side.Client] = private.NetworkSideClient,
		[enm.Network.Side.Server] = private.NetworkSideServer
	})()
end

private.Run(nil,nil,cfg.CharacterNetworkOwner)
cfg.Changed:For('CharacterNetworkOwner',private.Run)

public.Event = script:WaitForChild(tostring(plr.UserId)) :: UnreliableRemoteEvent
public.CharacterUpdate = nil :: RBXScriptConnection?
public.RenderUpdate = nil :: RBXScriptConnection?
public.RequestCaller = nil :: RBXScriptConnection?
public.App = enm.App.PlayerCharacterNetworkSide

return public
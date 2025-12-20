--!strict



local app = require('./')
local cfg = app.Config()
local enm = app.Enum()
local ent = app.Arch().GetSystem().GetEntity()
local plugin = app.GetPluginProvider()
local net = plugin.GetNetwork()
local imp = plugin.GetImported()
local shadow = plugin.GetShadow()
local plr = game.Players.LocalPlayer :: Player

assert(not game["Run Service"]:IsServer(), tostring(enm.Error.Forbidden))

local private = {}
local public = ent.New({
	App = enm.App.PlayerCharacterNetworkSide
} :: raw)
local shade : shade = shadow.New(public)
shade.Event = script:WaitForChild(tostring(plr.UserId)) :: UnreliableRemoteEvent




function private.NetworkSideServer ()
	local char : Model = plr.Character or plr.CharacterAdded:Wait()
	shade.CharacterUpdate = plr.CharacterAdded:Connect(function(character: Model) char = character end)
	shade.RenderUpdate = shade.Event.OnClientEvent:Connect(function(cframe: CFrame) char:PivotTo(cframe) end)
	shade.RequestCaller = game["Run Service"].Heartbeat:Connect(function(deltaTime: number) shade.Event:FireServer() end)
end

function private.NetworkSideClient ()
	local public = shade :: any
	
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

type raw = {
	App: typeof(enm.App.PlayerCharacterNetworkSide)
}

type shade = {
	Event: UnreliableRemoteEvent,
	CharacterUpdate: RBXScriptConnection?,
	RenderUpdate: RBXScriptConnection?,
	RequestCaller: RBXScriptConnection?
}

return public
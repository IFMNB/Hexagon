--!strict



local app = require('./')

local replica = app.Replica()
local cfg = app.Config()
local enm = app.Enum()
local replicator = app.Plugin().GetReplicator()

local plugin = replica.GetPluginProvider()
local ent = replica.GetArchProvider().GetSystem().GetEntity().GetClass()
local app_r = replica.GetAppProvider()


local imp = plugin.GetImported()
local ref = plugin.GetReference()
local mt = plugin.GetMeta()

local private = {}
local public = {}

function private.newEmulate (player: Player)
	replicator.CreateUnreliable(player, app_r.AppPath.PlayerCharacterNetworkSide, app_r.AppPath.PlayerCharacterNetworkSide)
end

for i,v in ipairs(game.Players:GetPlayers()) do private.newEmulate(v) end
game.Players.PlayerAdded:Connect(private.newEmulate)

private.fieldName = 'CharacterNetworkOwner' :: 'CharacterNetworkOwner'

function private.GetPlayer (player: Player) : appData
	public.Players[player]=public.Players[player]or ref.Link(ent.New({}::appData),player)
	return public.Players[player]
end
function private.ReturnPrimary (player: Player)
	local char = player.Character or player.CharacterAdded:Wait()
	local primary = assert(char.PrimaryPart, tostring(enm.Error.Unstable))
	return primary.CFrame
end





function private.SetClientSide (entity: typeof(ent.New({}))) : ()
	local player = ref.Get(entity) :: Player
	local appdata = private.GetPlayer(player)
	local char = player.Character or player.CharacterAdded:Wait()
	local primary = assert(char.PrimaryPart, tostring(enm.Error.Unstable))
	
	if appdata.CharacterAdded then
		appdata.CharacterAdded:Disconnect()
		appdata.CharacterAdded=nil
	end
	if appdata.CFrameRequest then
		appdata.CFrameRequest:Disconnect()
		appdata.CFrameRequest=nil
	end
	

	
	primary:SetNetworkOwner(player)
end

function private.SetServerSide (entity: typeof(ent.New({}))) : ()
	local player = ref.Get(entity) :: Player
	local appdata = private.GetPlayer(player)
	local char = player.Character or player.CharacterAdded:Wait()
	local primary = assert(char.PrimaryPart, tostring(enm.Error.Unstable))
	
	appdata.CharacterAdded = player.CharacterAdded:Connect(function (characterNew: Model) 
		private.SetServerSide(entity)
	end)
	
	primary:SetNetworkOwner()
	local event = replicator.GetEvent(player, app_r.AppPath.PlayerCharacterNetworkSide)
	appdata.CFrameRequest = event.OnServerEvent:Connect(function(player: Player, ...) 
		event:FireClient(player,private.ReturnPrimary(player))
	end)
end

function private.AppManager (_,_,i2: typeof(ent.New({})))
	i2.Changed:For(private.fieldName, function ()
		imp.switch(i2[private.fieldName],{
			[enm.Network.Side.Server] = private.SetServerSide,
			[enm.Network.Side.Client] = private.SetClientSide
		})(i2)
	end)
end

cfg.Players.Changed:Connect(private.AppManager)

public.Players = mt.SetMode({} :: {[Player]: appData}, 'v')

type appData = typeof(ent.New({}::{
	CharacterAdded: RBXScriptConnection?,
	CFrameRequest: RBXScriptConnection?
}))

return public
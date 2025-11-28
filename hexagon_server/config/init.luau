--!strict

local replica = require('./replica_link')
local svplugin = require('./plugins').GetServerPlugin()
local plugin = replica.GetPluginProvider()
local app = replica.GetAppProvider()


local ent = replica.GetArchProvider().GetSystem().GetEntity().GetClass()

local imp = plugin.GetImported()
local ref = plugin.GetReference()
local mt = plugin.GetMeta()
local enum = replica.GetEnums()
local replicator = svplugin.GetReplicator()

local private = {}
local cfg = {}

private.Players = mt.SetMode({}::{[Player]:typeof(ent.New({}::{}&plrRef))},'v')
cfg.Players = mt.DoProxy(ent.New(private.Players))
cfg.Origin = replica.GetConfig()



game.Players.PlayerAdded:Connect(function(player: Player)
	table.insert(cfg.Players::{{}},ref.Link(ent.New({}),player))
end)

function private.Request (player: Player, key, to)
	local tp0,tp1 = typeof(cfg.Origin[key]),typeof(to)
	assert(tp0==tp1,tostring(enum.Error.Forbidden))

	if enum.IsHexagonEnum(to) then
		cfg.Origin.Path.Replicator:FireClient(player,key,to.Value,true)
	else
		cfg.Origin.Path.Replicator:FireClient(player,key,to)
	end
	
	cfg.Players[player]=cfg.Players[player] or ref.Link(ent.New({}), player)
	cfg.Players[player][key]=to
	print(key, to)
end
function private.AllRequest (key, to)
	for i,v in game.Players:GetPlayers() do
		private.Request(v,key,to)
	end
end

-- Sends a change to a configuration parameter of the specified client.
function cfg.Send <key> (player: Player, key: (keyof<config>&key)|(keyof<config>|key), to: index<config,key>) : ()
	return private.Request(player,key,to)
end
-- Sends a configuration parameter change to all clients.
function cfg.SendAll <key> (key: (keyof<config>&key)|(keyof<config>|key), to: index<config,key>) : ()
	return private.AllRequest(key,to)
end


type plrRef = typeof(ent.New({}::{[any]:any?}))
type Reference = {}
type config = typeof(cfg.Origin)

return cfg
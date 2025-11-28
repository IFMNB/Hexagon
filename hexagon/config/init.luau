--!strict

local arch = require('./arch/provider')
local ent = arch.GetSystem().GetEntity().GetClass()
local enum = require('./enum')
local plugin = require('./enum/plugins').GetPluginProvider()
local oop = plugin.GetOOP()
local lnk = plugin.GetLinker()

local private = {}
local public = {}

private.config = {}
private.config.CharacterNetworkOwner = enum.Network.Side.Client :: index<typeof(enum.Network.Side),keyof<typeof(enum.Network.Side)>>
private.config.FramesPerSecond = false :: boolean








public.Path = script
local entity = ent.New(oop.Expanding(private.config, public)::config&public)
lnk.Link(entity,public)

if game["Run Service"]:IsClient() then
	script.Replicator.OnClientEvent:Connect(function (key, to, isHex: boolean)
		local value = isHex and enum.GetValue(to) or to
		entity[key] = value
		print(enum.Network.Messages.Request, key, value)
	end)
end

type private = typeof(private)
export type config = typeof(private.config)
export type public = typeof(public)

return entity	
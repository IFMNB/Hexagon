--!strict

local arch = require('../')
local enums = arch.GetEnums()
local plugin = arch.GetPluginProvider()

local oop = plugin.GetOOP()
local imp = plugin.GetImported()
local mt = plugin.GetMeta()
local lnk = plugin.GetLinker()
local shd = plugin.GetShadow()

local obj = arch.GetArchProvider().GetObject()
local ent = arch.GetAppProvider().GetEntity().GetClass()
local rbxl = arch.GetArchProvider().GetWorld().GetRobloxLink().GetClass()


local private = {}
local public = {}
local class = {}
local root = {}

private.store = mt.SetMode({} :: {PlayerSystemData}, 'v')
private.DataClassName = 'PlayerSystemData' :: 'PlayerSystemData'

function private.DoCreateNewClass (player: Player) : PlayerSystemData
	local link = rbxl.New(player)
	local proxy = oop.Expanding({} :: ThisData, link, public)
	local object = obj.New(proxy, private.DataClassName) :: PlayerSystemData
	local shadow = shd.New(object) :: _Shadow
	
	local Activities : Activities = {
		IsLoaded = false,
		InAfk = false,
		InGame = false
	}
	
	local ServerStore = {} :: ServerStore
	
	
	
	
	proxy.Activities = ent.New(Activities)
	proxy.ServerStore = ent.New(ServerStore)
	
	return object
end


function private.DoGetPlayerData (player: Player) : PlayerSystemData?
	for i,v in pairs(private.store) do
		if v:GetRobloxInstance() == player then
			return v
		end
	end
	return nil
end


function private.RootGet (player: Player)
	return private.DoGetPlayerData(player) or private.DoCreateNewClass(player)
end












function class.Get (player: Player) : PlayerSystemData?
	return private.RootGet(player)
end



type Activities = {
	InAfk: boolean,
	InGame: boolean,
	IsLoaded: boolean
}
type ServerStore = {
	
}
type ThisData = {
	Activities: Entity<Activities>,
	ServerStore: Entity<ServerStore> 
}



type _Shadow = {
	
}

type Entity<type> = typeof(ent.New({})) & type
type RobloxLink = typeof(rbxl.New({}::any))
export type PlayerSystemData = typeof(obj.New({} :: public, private.DataClassName)) & RobloxLink & ThisData

export type ancestors = self & arch.hierarchy_server_start
export type public = typeof(public)
export type self = typeof(class)
export type root = typeof(root)


function root.GetClass () return class end
oop.Expanding(root, arch)
return root
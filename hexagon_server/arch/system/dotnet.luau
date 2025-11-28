--!strict

local dataservice = game:GetService('DataStoreService')

local main = require('../')
local enum = main.GetEnums()
local plugin = main.GetPluginProvider()
local arch = main.GetArchProvider()

local oop = plugin.GetOOP()
local imp = plugin.GetImported()
local mt = plugin.GetMeta()
local lnk = plugin.GetLinker()
local shd = plugin.GetShadow()

local ent = arch.GetSystem().GetEntity()
local obj = arch.GetObject()

local private = {}
local public = {}
local class = {}
local root = {}

private.DotNETClassName = 'DotNET' :: 'DotNET'
private.CreatedList = {}

function private.DoGetPlayerRegisterKey (player: Player)
	return tostring(player.UserId)
end

function private.DoUpsetNewDotNet (enum: DotNetCompatible, object: DotNET)
	private.CreatedList[enum]=object
end

function private.DoGetDotNet (enum: DotNetCompatible)
	return private.CreatedList[enum]
end

function private.DoCreateNewDotNet (enum: DotNetCompatible) : DotNET
	local Data = dataservice:GetDataStore(enum.Name)
	local proxy = oop.Expanding({} :: public, public)
	local store = obj.New(proxy, private.DotNETClassName)
	local _private :_private = shd.New(store)
	_private._netstore = Data
	return store
end

function private.DoCreateAndSet (enum: DotNetCompatible)
	local dotnet = private.DoCreateNewDotNet(enum)
	private.DoUpsetNewDotNet(enum, dotnet)
	return dotnet
end

function private.DoRootGet (enum: DotNetCompatible)
	return private.DoGetDotNet(enum) or private.DoCreateAndSet(enum)
end


function private.DoTryWritePlayerData (self: DotNET, player: Player, data: DotNetData)
	local _private :_private = shd.Get(self)
	local store = _private._netstore
	local suc = imp.try(store.SetAsync, math.huge, 1, store, data)
	return self
end

function private.DoTryGetPlayerData (self: DotNET, player: Player)
	local _private :_private = shd.Get(self)
	local store = _private._netstore
	local suc = imp.try(store.GetAsync, math.huge, 1, store, private.DoGetPlayerRegisterKey(player))
	return suc
end





function public.WritePlayerData (self: DotNET, player: Player, writeData: DotNetData) : DotNET
	return private.DoTryWritePlayerData(self, player, writeData)
end

function public.GetPlayerData (self: DotNET, player: Player) : DotNetData
	return private.DoTryGetPlayerData(self, player)
end




-- Возвращает или создает объект для работы с DataStore. Принимает hexagonEnum. Нужен как обертка.
function class.Get (DataStore: DotNetCompatible|HexagonEnumType) : DotNET
	return private.DoRootGet(DataStore :: DotNetCompatible)
end

type DataStoresEnumType = typeof(enum.Network.Store)
type HexagonEnumType = typeof(enum.Create('' :: string, '' :: string))

type DotNetDataKey = keyof<DotNetData>
type DotNetDataValue = index<DotNetData, DotNetDataKey>
type DotNetData = {[string]: boolean|buffer|number|string}

type DotNetCompatible = index<DataStoresEnumType, keyof<DataStoresEnumType>>


type _private = {
	_netstore: DataStore
}
export type DotNET = typeof(obj.New({} :: public, private.DotNETClassName))

export type ancestors = root & main.hierarchy_server_start
export type public = typeof(public)
export type root = typeof(root)
export type self = typeof(class)

function root.GetClass () return class end
oop.Expanding(root,main)
return root



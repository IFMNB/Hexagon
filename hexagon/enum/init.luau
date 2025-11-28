--!strict

local private = {}
local public = {}

private.name = 'HexagonEnum' :: 'HexagonEnum'
private.startGeneration = 760
private.generated = private.startGeneration
private.reversGen = {} :: {HexagonEnum<string,string>}
private.nameGr = {} :: {[string]: {[string]: HexagonEnum<string,string>}}
--private.mt = { __index = public_enum, __newindex = function () error(string.format('attempt to change %s table', private.name)) end, __metatable = private.name, __tostring = function (self: HexagonEnum<string,string>) return self.Name end }

function private.__newindex ()
	error(string.format('attempt to change %s table', private.name))
end
function private.__tostring (self)
	return self.Name
end

function private.DoCreateEnum <name, type> (name: name, parent: type) : HexagonEnum<name, type>
	local e = {}
	e.Name = name
	e.EnumType = parent
	
	local proxy = newproxy(true)
	local mt = getmetatable(proxy)
	mt.__index = e
	mt.__newindex = e
	mt.__tostring = private.__tostring
		
	--setmetatable(e, private.mt)
	
	return proxy :: any
end

function private.DoInsertNewEnumValue <t1,t2> (enum: HexagonEnum<t1,t2>)
	private.reversGen[enum.Value]=enum
	return enum
end
function private.InsertEnumG <t0,t1> (enum: HexagonEnum<t0,t1>, n: t0, g: t1)
	private.nameGr[g]={}
end
function private.InsertEnumNG <t0,t1> (enum: HexagonEnum<t0,t1>, n: t0, g: t1)
	private.nameGr[g][n]=enum
end
function private.LockMeta (enum: HexagonEnum<string,string>)
	local mt = getmetatable(enum) :: any
	mt.__newindex = private.__newindex
	mt.__metatable = private.name
end

function private.DoAddGeneration <t1,t2> (enum: HexagonEnum<t1,t2>)
	enum.Value = private.generated
	private.generated += 1
	return enum
end

function private.DoGetEnumByValue (value: number)
	return private.reversGen[value]
end
function private.GetEnumByNames (n: string, g: string)
	return assert(private.nameGr[g][n], tostring(public.Error.Unknown))
end
function private.CheckHexEnum <t0> (data: HexagonEnum<string,string>&t0) : boolean
	return not not public.GetValue(data.Value)
end

function private.New <t1,t2> (name: t1, group: t2) : HexagonEnum<t1,t2>
	local enum = private.DoInsertNewEnumValue(private.DoAddGeneration(private.DoCreateEnum(name,group)))
	private.InsertEnumG(enum, name,group)
	private.InsertEnumNG(enum, name, group)
	private.LockMeta(enum)
	return enum
end

export type HexagonEnum <name, type> = {
	Name: name,
	Value: number,
	EnumType: type
} 

export type public = typeof(public)

private.Groups = {}
private.Groups.RC = 'Roblox' :: 'Roblox'
private.Groups.NW = 'Network' :: 'Network'
private.Groups.ER = 'Error' :: 'Error'
private.Groups.ST = 'State' :: 'State'
private.Groups.MD = 'MetaMethode' :: 'MetaMethode'
private.Groups.SG = 'Signal' :: 'Signal'
private.Groups.LU = 'Lua' :: 'Lua'
private.Groups.AP = 'App' :: 'App'
table.freeze(private.Groups)

public.Roblox = {}
public.Roblox.Camera = {}
public.Roblox.Camera.SmoothMovement = private.New('SmoothMovement' :: 'SmoothMovement', private.Groups.RC)
public.Roblox.Camera.SmoothFollow = private.New('SmoothFollow' :: 'SmoothFollow', private.Groups.RC)
public.Roblox.Camera.SmoothRotate = private.New('SmoothRotate' :: 'SmoothRotate', private.Groups.RC)
public.Roblox.Camera.SmoothWatchCamera = private.New('SmoothWatchCamera' :: 'SmoothWatchCamera', private.Groups.RC)
public.Roblox.Camera.SmoothCameraLookAt = private.New('SmoothCameraLookAt' :: 'SmoothCameraLookAt', private.Groups.RC)
public.Roblox.Camera.SmoothCameraPosition = private.New('SmoothCameraPosition' :: 'SmoothCameraPosition', private.Groups.RC)

public.State = {}
public.State.Live = private.New('Live' :: 'Live', private.Groups.ST)
public.State.Run = private.New('Run' :: 'Run', private.Groups.ST)
public.State.Pause = private.New('Pause' :: 'Pause', private.Groups.ST)
public.State.Dead = private.New('Dead' :: 'Dead', private.Groups.ST)
public.State.Idle = private.New('Idle' :: 'Idle', private.Groups.ST)

public.Error = {}
public.Error.Forbidden = private.New('Forbidden' :: 'Forbidden', private.Groups.ER)
public.Error.Unknown = private.New('Unknown' :: 'Unknown', private.Groups.ER)
public.Error.Unstable = private.New('Unstable' :: 'Unstable', private.Groups.ER) 
public.Error.Reset = private.New('Reset' :: 'Reset', private.Groups.ER)
public.Error.Never = private.New('Never' :: 'Never', private.Groups.ER)
public.Error.GarbageCollected = private.New('GarbageCollected' :: 'GarbageCollected', private.Groups.ER)

public.Network = {}
public.Network.Side = {}
public.Network.Side.Client = private.New('Client' :: 'Client', private.Groups.NW)
public.Network.Side.Server = private.New('Server' :: 'Server', private.Groups.NW)

public.Network.Store = {}
public.Network.Store.Main = private.New('Main' :: 'Main', private.Groups.NW)

public.Network.Messages = {}
public.Network.Messages.Action = private.New('Okay' :: 'Okay', private.Groups.NW)
public.Network.Messages.BadRequest = private.New('BadRequest' :: 'BadRequest', private.Groups.NW)
public.Network.Messages.Request = private.New('Request' :: 'Request', private.Groups.NW)
public.Network.Messages.Replicate = private.New('Replicate' :: 'Replicate', private.Groups.NW)

public.Metamethode = {}
public.Metamethode.Index = private.New('Index' :: 'Index', private.Groups.MD)
public.Metamethode.NewIndex = private.New('NewIndex' :: 'NewIndex', private.Groups.MD)
public.Metamethode.Call = private.New('Call' :: 'Call', private.Groups.MD)
public.Metamethode.Tostring = private.New('Tostring' :: 'Tostring', private.Groups.MD)
public.Metamethode.Length = private.New('Length' :: 'Length', private.Groups.MD)
public.Metamethode.Equal = private.New('Equal' :: 'Equal', private.Groups.MD)
public.Metamethode.Every = private.New('Every' :: 'Every', private.Groups.MD)

public.Signal = {}
public.Signal.Once = private.New('Once' :: 'Once', private.Groups.SG)
public.Signal.Conn = private.New('Conn' :: 'Conn', private.Groups.SG)
public.Signal.For = private.New('For' :: 'For', private.Groups.SG)
public.Signal.At = private.New('At' :: 'At', private.Groups.SG)
public.Signal.Wait = private.New('Wait' :: 'Wait', private.Groups.SG)
public.Signal.Follow = private.New('Follow' :: 'Follow', private.Groups.SG)

public.Lua = {}

public.Lua.Iterator = {}
public.Lua.Iterator.Ipairs = private.New('Ipairs' :: 'Ipairs', private.Groups.LU)
public.Lua.Iterator.Pairs = private.New('Pairs' :: 'Pairs', private.Groups.LU)
public.Lua.Iterator.Rpairs = private.New('Ipairs' :: 'Ipairs', private.Groups.LU)
public.Lua.Iterator.Enter = {}
public.Lua.Iterator.Enter.Before = private.New('Before' :: 'Before', private.Groups.LU)
public.Lua.Iterator.Enter.After = private.New('After' :: 'After', private.Groups.LU)

public.App = {}
public.App.PlayerCharacterNetworkSide = private.New('PlayerCharacterNetworkSide' :: 'PlayerCharacterNetworkSide', private.Groups.AP)

-- Returns HexagonEnum, related to the specified value.
function public.GetValue (EnumValue: number) : HexagonEnum<string,string>
	return private.DoGetEnumByValue(EnumValue)
end
-- Returns HexagonEnum, related to this name and group.
function public.GetNamed <t0,t1> (name: t0, group: t1) : HexagonEnum<t0,t1>
	return private.GetEnumByNames(name, group)
end
-- Returns the start time of the hexagon library.
function public.GetStart () : number
	return private.startGeneration
end
-- Creates a new HexagonEnum.
function public.Create <name, group> (name: name, group: group) : HexagonEnum<name, group>
	return private.New(name,group)
end
-- Returns true if the specified data is a HexagonEnum.
function public.IsHexagonEnum <t0> (data: t0) : boolean
	return private.CheckHexEnum(data)
end

function public.GetGroups ()
	return private.Groups
end

return public
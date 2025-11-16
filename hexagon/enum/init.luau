--!strict

local private = {}
local public_enum = {}
local public = {}

private.name = 'HexagonEnum' :: 'HexagonEnum'
private.startGeneration = 10000
private.generated = private.startGeneration
private.reversGen = {} :: {HexagonEnum<string,string>}
private.mt = { __index = public_enum, __newindex = function () error(string.format('attempt to change %s table', private.name)) end, __metatable = private.name, __tostring = function () return private.name end }


function private.DoCreateEnum <name, type> (name: name, parent: type) : HexagonEnum<name, type>
	local e = {}
	e.Name = name
	e.Value = 0
	e.EnumGroup = parent
	setmetatable(e, private.mt)
	
	return e
end

function private.DoInsertNewEnumValue <t1,t2> (enum: HexagonEnum<t1,t2>)
	private.reversGen[enum.Value]=enum
	return enum
end

function private.DoAddGeneration <t1,t2> (enum: HexagonEnum<t1,t2>)
	enum.Value = private.generated
	private.generated += 1
	return enum
end

function private.DoGetEnumByValue (value: number)
	return private.reversGen[value]
end

function private.New <t1,t2> (name: t1, group: t2) : HexagonEnum<t1,t2>
	return private.DoInsertNewEnumValue(private.DoAddGeneration(private.DoCreateEnum(name,group)))
end

export type HexagonEnum <name, type> = {
	Name: name,
	Value: number,
	EnumGroup: type
} & public_enum

type public_enum = typeof(public_enum)
export type public = typeof(public)


private.RC = 'RobloxCamera' :: 'RobloxCamera'
private.NW = 'Network' :: 'Network'
private.ER = 'Error' :: 'Error'
private.ST = 'State' :: 'State'
private.AC = 'Access' :: 'Access'

public.Roblox = {}
public.Roblox.Camera = {}
public.Roblox.Camera.SmoothMovement = private.New('SmoothMovement' :: 'SmoothMovement', private.RC)
public.Roblox.Camera.SmoothFollow = private.New('SmoothFollow' :: 'SmoothFollow', private.RC)
public.Roblox.Camera.SmoothRotate = private.New('SmoothRotate' :: 'SmoothRotate', private.RC)
public.Roblox.Camera.SmoothWatchCamera = private.New('SmoothWatchCamera' :: 'SmoothWatchCamera', private.RC)
public.Roblox.Camera.SmoothCameraLookAt = private.New('SmoothCameraLookAt' :: 'SmoothCameraLookAt', private.RC)
public.Roblox.Camera.SmoothCameraPosition = private.New('SmoothCameraPosition' :: 'SmoothCameraPosition', private.RC)

public.State = {}
public.State.Run = private.New('Run' :: 'Run', private.ST)
public.State.Pause = private.New('Pause' :: 'Pause', private.ST)
public.State.Dead = private.New('Dead' :: 'Dead', private.ST)
public.State.Idle = private.New('Idle' :: 'Idle', private.ST)

public.Error = {}
public.Error.Forbidden = private.New('Forbidden' :: 'Forbidden', private.ER)
public.Error.Unknown = private.New('Unknown' :: 'Unknown', private.ER)
public.Error.Unstable = private.New('Unstable' :: 'Unstable', private.ER)
public.Error.Reset = private.New('Reset' :: 'Reset', private.ER)
public.Error.Never = private.New('Never' :: 'Never', private.ER)

public.Access = {}
public.Access.Developer = private.New('Developer' :: 'Developer', private.AC)
public.Access.Moderator = private.New('Moderator' :: 'Moderator', private.AC)
public.Access.Default = private.New('Default' :: 'Default', private.AC)

public.Network = {}
public.Network.Store = {}
public.Network.Store.Main = private.New('Main' :: 'Main', private.NW)


-- Возвращает HexagonEnum по переданному значению.
function public.GetEnum (EnumValue: number) : HexagonEnum<string,string>
	return private.DoGetEnumByValue(EnumValue)
end
-- Возвращает изначальное значение, от которого начинается отсчет создания HexagonEnum.
function public.GetStart () : number
	return private.startGeneration
end
-- Создает новый hexagonEnum с заданным именем и группой.
function public.Create <name, group> (name: name, group: group) : HexagonEnum<name, group>
	return private.New(name,group)
end

return public
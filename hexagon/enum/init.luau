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

public.Roblox = {}
public.Roblox.Camera = {}
public.Roblox.Camera.SmoothMovement = private.New('SmoothMovement' :: 'SmoothMovement', private.RC)
public.Roblox.Camera.SmoothFollow = private.New('SmoothFollow' :: 'SmoothFollow', private.RC)
public.Roblox.Camera.SmoothRotate = private.New('SmoothRotate' :: 'SmoothRotate', private.RC)
public.Roblox.Camera.Error = {}
public.Roblox.Camera.Error.CurrentCamera = private.New('CurrentCamera' :: 'CurrentCamera', private.RC)

public.Network = {}
public.Network.Config = {}
public.Network.Error = {}
public.Network.Error.Forbidden = private.New('Forbidden' :: 'Forbidden', private.NW)
public.Network.Error.Unknown = private.New('Unknown' :: 'Unknown', private.NW)
public.Network.Error.Unstable = private.New('Unstable' :: 'Unstable', private.NW)
public.Network.Error.Reset = private.New('Reset' :: 'Reset', private.NW)

public.Replicated = {}
public.Replicated.PlayerData = {}
public.Replicated.Character = {}


-- Возвращает HexagonEnum по переданному значению.
function public.GetEnum (EnumValue: number) : HexagonEnum<string,string>
	return private.DoGetEnumByValue(EnumValue)
end
-- Возвращает изначальное значение, от которого начинается отсчет создания HexagonEnum.
function public.GetStart () : number
	return private.startGeneration
end


return public
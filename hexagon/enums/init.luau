--!strict

local private = {}
local public = {}

private.name = 'HexagonEnum' :: 'HexagonEnum'
private.reversGen = {} :: {HexagonEnum<string,string>}
private.nameGr = {} :: {[string]: {[string]: HexagonEnum<string,string>}}
--private.mt = { __index = public_enum, __newindex = function () error(string.format('attempt to change %s table', private.name)) end, __metatable = private.name, __tostring = function (self: HexagonEnum<string,string>) return self.Name end }
private.GenerationSettings = {}
private.GenerationSettings.StarterGeneration = 0
private.GenerationSettings.Generated = private.GenerationSettings.StarterGeneration

function private.__tostring (self)
	return self.Name
end
-- Returns HexagonEnum current parameters.
function private.GetParams ()
	return private.GenerationSettings
end

function private.DoCreateEnum <name, type> (name: name, parent: type)
	local e = {}
	e.Name = name
	e.EnumType = parent
	e.Value = -1
	
	local proxy = newproxy(true)
	local mt = getmetatable(proxy)
	mt.__index = e
	mt.__newindex = e
	mt.__tostring = private.__tostring
	mt.__metatable = private.name
		
	--setmetatable(e, private.mt)
	
	return proxy :: setmetatable<{}, {
		__index: typeof(e),
		__newindex: typeof(e),
		__tostring: typeof(private.__tostring),
		__metatable: typeof(private.name)
	}>
end

function private.DoInsertNewEnumValue <t1,t2> (enum: HexagonEnum<t1,t2>)
	private.reversGen[enum.Value]=enum
	return enum
end
function private.InsertEnumG <t0,t1> (n: t0, g: t1)
	private.nameGr[g]=private.nameGr[g] or {}
end
function private.InsertEnumNG <t00, t0,t1> (self: t00, n: t0, g: t1)
	private.nameGr[g][n]=self
end

function private.DoAddGeneration <t1,t2> (enum: HexagonEnum<t1,t2>)
	enum.Value = private.GenerationSettings.Generated
	private.GenerationSettings.Generated += 1
	return enum
end

-- Returns HexagonEnum, related to the specified value.
function private.DoGetEnumByValue (value: number)
	return private.reversGen[value]
end
-- Returns HexagonEnum, related to this name and group.
function private.GetEnumByNames <t0,t1> (n: t0, g: t1)
	return assert(private.nameGr[g][n], 'something gone wrong')
end
-- Returns true if the specified data is a HexagonEnum.
function private.CheckHexEnum <t0> (data: HexagonEnum<string,string>&t0) : boolean
	return not not private.DoGetEnumByValue(data.Value)
end
-- Creates a new HexagonEnum.
function private.New <t1,t2> (name: t1, group: t2)
	local enum = private.DoCreateEnum(name,group)
	
	private.DoAddGeneration(enum)
	private.DoInsertNewEnumValue(enum)
	private.InsertEnumG(name,group)
	private.InsertEnumNG(enum, name, group)
	
	return enum
end

-- Returns true if the specified data is a HexagonEnum and her group is the same as the specified group.
function private.ReturnCheckedGroupSimilar (evalue: number, group: string) : boolean
	local enum = private.DoGetEnumByValue(evalue)
	return not not enum and enum.EnumType == group
end

type HexagonEnum <t0,t1> = typeof(private.DoCreateEnum(''::t0,''::t1))



public.GetValue = private.DoGetEnumByValue
public.GetNamed = private.GetEnumByNames
public.Create = private.New
public.IsHexagonEnum = private.CheckHexEnum
public.IsGroup = private.ReturnCheckedGroupSimilar
public.GetParams = private.GetParams
table.freeze(public)
table.freeze(private)

type inject = {
	_Typecheck: {
		GetHexagonEnum: <t0,t1> (t0:t0,t1:t1) -> HexagonEnum<t0,t1>,
		HexagonEnumSignature: HexagonEnum<string,string>
	}
}

return public :: typeof(public)&inject
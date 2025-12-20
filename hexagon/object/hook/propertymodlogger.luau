--!strict

local main = require('./')

local private = {}
local public = {}
local class = {}

local plugin = require('../plugin')
local hook = main.GetHook()
local obj = main.GetObject()

local mt = plugin.GetMeta()
local shadow = plugin.GetShadow()

private.classname = 'PropertyModifiedLogger' :: 'PropertyModifiedLogger'
private.registry = mt.SetMode({} :: {[string]: PropertyModifiedLogger}, 'v')

 

@native
function private.MainLoggerHandler (InterlayerTable: {[any]:any}, index: any, newindex: any, oldindex: any)
	local shade : ShadeInterlayer = shadow.Get(InterlayerTable)
	
	if shade._all[index] ~= newindex then
		shade._modified[index]=true
	else
		shade._modified[index]=nil
	end
end


private.params = hook.New(private.MainLoggerHandler, 'newindex')
private.params:DefineBehavior('after')
private.params:Resume()


function private.CreateInterlayer <t1> (DataToLog: t1)
	local Interlayer = table.clone(public)
	Interlayer.LoggerId = tostring(Interlayer)
	
	local metatable = mt.CreateMetaTo(DataToLog)
	local shade : ShadeInterlayer = shadow.New(Interlayer)
	shade._metatable = metatable
	shade._all = mt.DoProxy(DataToLog)
	table.freeze(shade._all)

	Interlayer = setmetatable(Interlayer :: typeof(Interlayer) & t1, metatable)
	
	local Hook = private.params:Create(Interlayer) :: typeof(Interlayer)
	
	return Hook
end

function private.RegistryInstance <t1> (Registry: PropertyModifiedLogger)
	private.registry[Registry.LoggerId] = Registry
end
function private.GetRegistry (Object: PropertyModifiedLogger)
	return private.registry[Object.LoggerId]
end

function private.CreateNewPropertyModifiedLogger <t1> (DataToLog: t1)
	local LoggerInterlayer = private.CreateInterlayer(DataToLog)
	local InstanceLogger = obj.New(LoggerInterlayer, private.classname)
	
	private.RegistryInstance(InstanceLogger)
	
	return InstanceLogger
end

-- Returns boolean, that indicates that property was modified
function private:IsPropertyModified <t0> (Property)
	local object = private.GetRegistry(self :: any)
	local shade : ShadeInterlayer = shadow.Get(object)
	return not not shade._modified[Property]
end


public.IsPropertyModified = private.IsPropertyModified
class.New = private.CreateNewPropertyModifiedLogger
class.Name = private.classname

local a = class.New({})

table.freeze(private)
table.freeze(public)
table.freeze(class)

type ShadeInterlayer = {
	_metatable: typeof(mt.CreateMetaTo({})),
	_all: {[any]:any},
	_modified: {[any]: boolean?}
}

type PropertyModifiedLogger = typeof(private.CreateNewPropertyModifiedLogger({}))

type typecheck = {
	_typecheck: {
		LoggerSignature: () -> typeof(private.CreateNewPropertyModifiedLogger({})),
		LoggerId: string,
		Public: typeof(public)
	}
}

return table.freeze(setmetatable({
	GetPropertyModifiedLogger = function ()
		return class :: typeof(class) & typecheck
	end,
}, {__index=main}))
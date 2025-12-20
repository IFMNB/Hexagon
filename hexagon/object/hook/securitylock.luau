--!strict

local main = require('./')
local hook = main.GetHook()

local plugin = require('../plugin')
local obj = main.GetObject()
local mt = plugin.GetMeta()

local private = {}
local class = {}

class.Name = 'SecurityLock' :: 'SecurityLock'

function private.CreateInterlayer <t0> (DataToProtect: t0)
	local Interlayer = {}
	local metatable = mt.CreateMetaTo(DataToProtect)
	metatable.__newindex = nil
	table.freeze(Interlayer)
	table.freeze(metatable)
	setmetatable(Interlayer :: unknown, metatable)
	
	return Interlayer :: typeof(Interlayer) & t0
end

function private.CreateSecurityLock <t0> (DataToProtect: t0)
	local Interlayer = private.CreateInterlayer(DataToProtect)
	local InstanceInterlayer = obj.New(Interlayer, class.Name)
	return InstanceInterlayer
end

class.New = private.CreateSecurityLock

table.freeze(private)
table.freeze(class)

type tc = {
	_typecheck: {
		
	}
}

return table.freeze(setmetatable({
	GetSecurityLock = function ()
		return class :: typeof(class) & tc
	end,
}, {__index = main}))
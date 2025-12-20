--!strict

local main = require('../')
local changed = require('./changedsignal').GetChangedSignal()
local proplog = require('./propertymodlogger').GetPropertyModifiedLogger()

local plugin = require('../plugin')
local mt = plugin.GetMeta()
local obj = main.GetObject()

local private = {}
local public = {}
local class = {}



class.Name = 'Entity' :: 'Entity'

function private.CreateInterlayer <t1,t2> (DataToProtect: t1, ClassName: t2)
	local Interlayer = table.clone(public)
	Interlayer.EntityClassName = ClassName
	mt.setrelatedmetatable(Interlayer, DataToProtect)
	
	return Interlayer :: typeof(Interlayer) & t1
end

function private.CreateEntity <t1,t2> (DataToProtect: t1, ClassName: t2?)
	local Interlayer = private.CreateInterlayer(DataToProtect, ClassName)
	
	local InstanceInterlayerLogged = proplog.New(Interlayer)
	local InstanceInterlayerChanged = changed.New(InstanceInterlayerLogged, 'after')
	local InstanceEntity = obj.New(InstanceInterlayerChanged, class.Name)
	
	return InstanceEntity
end


class.New = private.CreateEntity

table.freeze(private)
table.freeze(public)
table.freeze(class)

type tc = {
	_typecheck:{
		
	}
}

return table.freeze(setmetatable({
	GetInstance = function ()
		return class :: typeof(class) & tc
	end,
}, {__index = main}))
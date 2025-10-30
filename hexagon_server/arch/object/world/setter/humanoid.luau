--!strict

local parent = require('./')
local setter = parent.GetSetter()
local ancestors = parent :: parent.ancestors

local plugin = ancestors.GetPluginProvider()
local arch = ancestors.GetArchProvider()
local oop = plugin.GetOOP()
local obj = arch.GetObject()

local private = {}
local public = {}
local class = {}
local root = {}

private.SetterHumanoidClassName = 'SetterHumanoid' :: 'SetterHumanoid'

function private.DoCreateNewHumanoidSetter () : SetterHumanoid
	local setter = setter.New()
	local proxy = {} :: _setterHumanoid
	
	proxy._origin = setter
	
	oop.Expanding(proxy, public, setter)
	local object = obj.New(proxy, private.SetterHumanoidClassName)
	return object
end

function private.DoSetHumanoid (self: _setterHumanoid, to: Humanoid) : _setterHumanoid
	assert(typeof(to) == 'Instance', 'Received object is not a Instance')
	assert(to.ClassName == 'Humanoid', 'Received object is not a Humanoid class')
	return (self._origin:Do(to)::parent.public)::_setterHumanoid
end




function public.Do (self: SetterHumanoid, to: Humanoid) : SetterHumanoid
	return private.DoSetHumanoid(self :: _setterHumanoid, to)
end

function public.Set (self: SetterHumanoid, index: humanoidIndexKey, value: humanoidIndexValue) : SetterHumanoid
	return ((self :: _setterHumanoid)._origin:Set(index, value)::parent.public)::_setterHumanoid
end


function class.New () : SetterHumanoid
	return private.DoCreateNewHumanoidSetter()
end

type humanoidIndexKey = keyof<Humanoid>
type humanoidIndexValue = any
type _setterHumanoid = SetterHumanoid & {
	_origin: parent.Setter
}
export type SetterHumanoid = typeof(obj.New({} :: parent.public & public, private.SetterHumanoidClassName))

type public = typeof(public)
export type ancestors = root & parent.ancestors
export type root = typeof(root)
export type self = typeof(class)

-- Используется для установки значений объекта класса.
function root.GetSetterHumanoid () return class end
oop.Expanding(root, ancestors)
return root
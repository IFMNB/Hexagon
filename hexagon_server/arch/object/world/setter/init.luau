--!strict

local parent = require('./')
local ancestors = parent :: parent.ancestors

local plugin = ancestors.GetPluginProvider()
local arch = ancestors.GetArchProvider()
local oop = plugin.GetOOP()
local obj = arch.GetObject()

local private = {}
local public = {}
local class = {}
local root = {}

private.SetterClassName = 'Setter' :: 'Setter'

function private.DoNewSetter () : Setter
	local setter = {} :: _setter
	
	setter._set = {}
	
	oop.Expanding(setter, public)
	local object = obj.New(setter, private.SetterClassName)
	return object
end

function private.GetSettered (self: _setter)
	return self._set
end

-- Опасно применять с Instance в чистом виде этого класса, т.к подставляемые значения невозможно проверить на корректность и безопасность. Это должно решаться от подтипов этого класса.
function private.DoSettingSetter (self: _setter, to: {}|{[any]:any})
	local set = private.GetSettered(self)
	local type = typeof(to)
	
	for i,v in pairs(set) do
		if type == 'Instance' then
			if to[i] then
				to[i]=v
				continue
			end
		end
		
		to[i] = v
	end
	
	return self
end

function private.GetFromSetterThisSettered (self: _setter)
	local set = private.GetSettered(self)
	local proxy = {}
	oop.Expanding(proxy, set)
	return proxy :: struct
end

function private.DoSetSettered (self: _setter, index: keyof<struct>, value: index<struct, keyof<struct>>)
	self._set[index]=value
	return self
end









-- Установить значения для указанного объекта.
function public.Do (self: Setter, to: Instance|{}|{[any]:any}) : Setter
	return private.DoSettingSetter(self :: _setter, to)
end
-- Назначить на индекс значение.
function public.Set (self: Setter, index: keyof<struct>, value: index<struct, keyof<struct>>) : Setter
	return private.DoSetSettered(self :: _setter, index, value)
end
-- Получить словарь значений внутри.
function public.Get (self: Setter) : struct
	return private.GetSettered(self :: _setter)
end








-- Создает класс Setter.
function class.New () : Setter
	return private.DoNewSetter()
end


type struct = {[string]: any}

type _setter = Setter & {
	_set:struct
}
export type Setter = typeof(obj.New({} :: public, private.SetterClassName))

export type public = typeof(public)
export type ancestors = root & parent.ancestors
export type root = typeof(root)
export type self = typeof(class)

-- Используется для установки значений объекта.
function root.GetSetter () return class end
oop.Expanding(root, ancestors)
return root
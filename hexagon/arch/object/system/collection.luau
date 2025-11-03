--!strict

local parent = require('./')
local ancestors = parent :: parent.ancestors
local provider = ancestors.GetPluginProvider()

local obj = ancestors.GetObject()

local oop = provider.GetOOP()
local imp = provider.GetImported()
local mt = provider.GetMeta()
local tbl = provider.GetTable()

local private = {}
local public = {}
local class = {}
local root = {}

private.CollectionClassName = 'Collection' :: 'Collection'

function private.newclient () : Collection | _Collection
	local self = {} :: _Collection
	
	self._inside = {}
	--self.type_index = 'nonstrict'
	--self.type_value = 'nonstrict'
	
	mt.SetMode(self._inside, 'kv')
	oop.Expanding(self, public)
	
	
	return obj.New(self, private.CollectionClassName)
end

function private.GetInside (self: _Collection)
	return self._inside
end





function private.pushToCollection(self: _Collection, index: any, value: any)
	local inside = private.GetInside(self)
	assert(value ~= nil and inside[index] == nil, string.format('Attempt to override existed %q. \n%s - dsc. \nCurrent saved data is %q', index, value, tostring(inside[index])))
	
	--if self:IsStrict('index') then
	--	assert(self:GetTypeOfStrict('index') == typeof(index), `some data for index has different type`)
	--end
	
	--if self:IsStrict('value') then
	--	assert(self:GetTypeOfStrict('value') == typeof(value), `some data for value has different type`)
	--end
	
	inside[index]=value
	return self
end

function private.GetValueIndexed (self: _Collection, index: any)
	return private.GetInside(self)[index]
end



function private.getList (self: _Collection)
	return private.GetInside(self) --mt.DoProxy(private.GetInside(self))
end

function private.removeAllInside (self: _Collection)
	local inside = private.GetInside(self)
	for i,v in pairs(inside) do
		inside[i] = nil
	end
	return self
end

function private.DoForAllElementIn (self: _Collection, func: func)
	for i,v in pairs(private.GetInside(self)) do
		func(i,v)
	end
	return self
end


--function private.checkStrictMode (self: _Collection, at: typs)
--	return at == 'index' and self.type_index ~= 'nonstrict' or at == 'value' and self.type_value ~= 'nonstrict'
--end


--function private.setStrictTypeMode (self: _Collection, at: typs, tp: cantype)
--	if at == 'index' then
--		self.type_index = tp 
--	elseif at == 'value' then
--		self.type_value = tp
--	end
--	return self
--end

--function private.getMyStrictType (self: _Collection, at: typs)
--	return at == 'index' and self.type_index or at == 'value' and self.type_value
--end



-- Записать новый элемент.
function public.Set (self: Collection, index: any, value: any)
	return private.pushToCollection(self :: _Collection,index,value)
end
-- Получить элемент из коллекции.
function public.Get (self: Collection, index: any)
	return private.GetValueIndexed(self :: _Collection, index)
end
-- Удалить все элементы из коллекции.
function public.Des (self: Collection) : Collection
	return private.removeAllInside(self :: _Collection)
end
-- Вернуть все элементы внутри коллекции.
function public.All (self: Collection)
	return private.getList(self :: _Collection)
end
-- Для всех элементов в коллекции будет выполнена указанная операция.
function public.Do (self: Collection, func: func) : Collection
	return private.DoForAllElementIn(self :: _Collection, func)
end

-- TODO: Строгий режим не предполагается использовать далее.

---- Включить строгий режим для индексов или значений.
--function public.SetStrict (self: Collection, at: typs, type: cantype)
--	return private.setStrictTypeMode(self :: _Collection, at, type)
--end
---- Проверить, включен ли строгий режим.
--function public.IsStrict (self: Collection, at: typs)
--	return private.checkStrictMode(self :: _Collection, at)
--end
---- Вернуть тип строгого режима.
--function public.GetTypeOfStrict (self: Collection, at: typs)
--	return private.getMyStrictType(self :: _Collection, at)
--end

-- Создать новую коллекцию элементов.
function class.New () : Collection
	return private.newclient()
end


type func = (index: any, value: any)->()
--type typs = 'index' | 'value'
--type cantype = 'nonstrict' | 'string' | 'table' | 'function' | 'boolean' | 'number' | 'userdata' | 'thread' | 'nil' | 'Vector3' | 'Vector2'
type _Collection = Collection & {
	_inside: {[any]:any},
	--type_index: cantype,
	--type_value: cantype
}
export type Collection = public
type public = typeof(public)

export type self = typeof(class)
export type ancestors = self & parent.ancestors

-- Коллекции предоставляют способ распределять и управлять группами элементов внутри.
function root.GetCollections () return class end
oop.Expanding(root, parent)
return root
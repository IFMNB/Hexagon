--!strict

local parent = require('./')
local ancestors = parent :: parent.ancestors
local provider = ancestors.GetPluginProvider()

local oop = provider.GetOOP()
local import = provider.GetImported()
local mt = provider.GetMeta()

local private = {}
local public = {}
local class = {}
local root = {}

function private.newclient ()
	local self = {}
	
	self.inside = {}
	self.type_index = 'nonstrict'
	self.type_value = 'nonstrict'
	
	oop.Expanding(self, public)
	mt.SetMode(self.inside, 'kv')
	
	return self :: Collection
end

function private.pushToCollection(self: _Collection, index: any, value: any)
	assert(self.inside[index] == nil, string.format('Attempt to override existed %q. This is not allowed in this dev-phase. \n%s - dsc. \nCurrent saved data is %q', index, value, tostring(self.inside[index])))
	
	if self:IsStrict('index') then
		assert(self:GetTypeOfStrict('index') == typeof(index), `some data for index has different type`)
	end
	
	if self:IsStrict('value') then
		assert(self:GetTypeOfStrict('value') == typeof(value), `some data for value has different type`)
	end
	
	self.inside[index]=value
	return self
end

function private.extractByIndex (self: _Collection, index: any)
	return self.inside[index]
end

function private.removeFromCollectionByIndex (self: _Collection, index: any)
	self.inside[index] = nil
	return self
end

function private.checkStrictMode (self: _Collection, at: typs)
	return at == 'index' and self.type_index ~= 'nonstrict' or at == 'value' and self.type_value ~= 'nonstrict'
end


function private.setStrictTypeMode (self: _Collection, at: typs, tp: cantype)
	if at == 'index' then
		self.type_index = tp 
	elseif at == 'value' then
		self.type_value = tp
	end
	return self
end

function private.getMyStrictType (self: _Collection, at: typs)
	return at == 'index' and self.type_index or at == 'value' and self.type_value
end

function private.getList (self: _Collection)
	return table.clone(self.inside)
end

function private.removeAllInside (self: _Collection)
	for i,v in pairs(self.inside) do
		self:Remove(i)
	end
	return self
end

function private.readElementByValue (self: _Collection, value: any) : any?
	for i,v in pairs(self.inside) do
		if v == value then
			return i
		end
	end
	return nil
end






-- Записать новый элемент.
function public.Set (self: Collection, index: any, value: any)
	return private.pushToCollection(self :: _Collection,index,value)
end
-- Получить элемент из коллекции.
function public.Get (self: Collection, index: any)
	return private.extractByIndex(self :: _Collection, index)
end
-- Получить индекс элемента по указанному значению.
function public.Read (self: Collection, value: any)
	return private.readElementByValue(self :: _Collection, value)
end
-- Удалить из коллекции элемент.
function public.Remove (self: Collection, index: any)
	return private.removeFromCollectionByIndex(self :: _Collection, index)
end
-- Удалить все элементы из коллекции.
function public.RemoveAll (self: Collection)
	return private.removeAllInside(self :: _Collection)
end
-- Включить строгий режим для индексов или значений.
function public.SetStrict (self: Collection, at: typs, type: cantype)
	return private.setStrictTypeMode(self :: _Collection, at, type)
end
-- Проверить, включен ли строгий режим.
function public.IsStrict (self: Collection, at: typs)
	return private.checkStrictMode(self :: _Collection, at)
end
-- Вернуть тип строгого режима.
function public.GetTypeOfStrict (self: Collection, at: typs)
	return private.getMyStrictType(self :: _Collection, at)
end
-- Вернуть все элементы внутри коллекции.
function public.GetAll (self: Collection)
	return private.getList(self :: _Collection)
end




-- Создать новую коллекцию элементов.
function class.New ()
	return private.newclient()
end


type typs = 'index' | 'value'
type cantype = 'nonstrict' | 'string' | 'table' | 'function' | 'boolean' | 'number' | 'userdata' | 'thread' | 'nil' | 'Vector3' | 'Vector2'
type _Collection = Collection & {inside: {[any]: any}, type_index: cantype, type_value: cantype }
export type Collection = public
type public = typeof(public)

export type self = typeof(class)
export type ancestors = self & parent.ancestors

-- Коллекции предоставляют способ распределять и управлять группами элементов внутри. Дополнительно предоставляют инструменты строгой проверки данных в рантайме.
function root.GetCollections () return class end
oop.Expanding(root, parent)
return root
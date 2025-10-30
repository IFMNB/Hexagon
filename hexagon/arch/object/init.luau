--!strict

-- Класс, предоставляющий инкапсуляцию для всех объектов других классов.
-- Представляет функционал наподобие Instance.new().


local parent = require('./')

local provider = parent.GetPluginProvider()
local mt = provider.GetMeta()
local oop = provider.GetOOP()
local link = provider.GetLinker()

local private = {}
local public = {}
local class = {}
local root = {}



private.classes = {
	object = {}
} :: class_reg


function private.InjectObjectDataToClass <class, type> (self: class, name: type)
	local this : any = self
	this.ClassName = name
end

function private.SetMetaObject <meta, value> (self: meta, objVal: value)
	local this : any = self
	mt.SpecifyTo(this, objVal)
	this.__tostring = private.GetClassName --private.getClassNameForAbstractInstance  
	this.__metatable = 'Locked metatable'
	return self
end

-- Внутренние данных у экземпляров этого класса не требуется сохранять где-либо еще, т.к __index метатаблицы назначен на эти внутренние данные. Это предовтращает его удаление.
function private.CreateObject <data, type> (self: data, name: type) 
	local object = newproxy(true, name)
	local mt = getmetatable(object)
	local value : any = oop.Expanding(self, public)
	
	
	private.SetMetaObject(mt, value)
	
	return object
end

function private.NewBaseObject <data, type> (self: data, name: type)
	debug.profilebegin(script.Name..'.CreateAbstractInstance')
	
	local object = private.CreateObject(self, name)
	private.InjectObjectDataToClass(self, name)

	debug.profileend()
	return object
end











-- Функция нужна для корректной работы метатаблиц.
function private.GetClassName (self: CodeObject<unknown,unknown>)
	return self.ClassName
end 

--[[
function private.GetAllAncestors (self: class_reg_value)
	local r = {}
	for i,v in pairs(private.classes) do
		if v[self] then r[i]=v end
	end
	return r
end

function private.DoRegistryThisInParents (self: class_reg_value, parent: class_reg_value)
	local ancestors = private.GetAllAncestors(parent)
	for i,v in pairs(ancestors) do
		if v[self] then continue end
		v[self] = private.classes[self]
		private.DoRegistryThisInParents(self, i)
	end
end

function private.CreateNewRegistryForClass (self: class_reg_value, parent: class_reg_value?)
	assert(not private.classes[self], 'Class with this name already exist in Registry')
	local def = 'object'
	private.classes[self]={}
	private.classes[parent or def][self]=private.classes[self]
	private.DoRegistryThisInParents(self, parent or def)
end

function private.SearchInClassRegistered (self: public & InjectedObjectData<'unknown'>, ClassName: class_reg_value)
	local this = self.ClassName
	return not not private.classes[ClassName][this]
end
]]










-- INDEV-API. Проверяет, является ли объект наследником или экземпляром указанного класса.
function public:IsA (ClassName: string)
	return
end



-- Создает над данными инкапсуляцию. Эмулирует классовую структуру роблокса.
function class.New <data, type> (self: data, ClassName: type)
	return private.NewBaseObject(self, ClassName) :: CodeObject<data, type>
end

-- INDEV-API. Регистрирует класс и его экземпляры в иерархии.
function class.RegisterClass ()--(self: class_reg_value, parent: class_reg_value?)
	return 
end

type class_reg_value = string
type class_reg = {object: {[class_reg_value]:class_reg}, [class_reg_value]: {[class_reg_value]: class_reg}}
type userdata = setmetatable<{},{[string]:any}>
type class = {}|self

type InjectedObjectData <classname> = {
	ClassName: classname
}
export type CodeObject <this, name> = setmetatable<this & public & InjectedObjectData<name>, {[string]: string|(...any)->()|any}>

type public = typeof(public)

export type ancestors = root & parent.project_hierarchy_start
export type self = typeof(class)
export type root = typeof(root)

-- Используется для создания всех экземпляров для любого класса, инкапсулируя данные и становься очертанием объектов из роблокса.
function root.GetObject () return class end
provider.GetOOP().Expanding(root, parent)
return root
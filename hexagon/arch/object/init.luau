--!strict

-- Класс, предоставляющий инкапсуляцию для всех объектов других классов.
-- Представляет функционал наподобие Instance.new().

local http = game:GetService('HttpService')

local parent = require('./')

local provider = parent.GetPluginProvider()
local mt = provider.GetMeta()
local oop = provider.GetOOP()
local link = provider.GetLinker()

local private = {}
local public = {}
local class = {}
local root = {}

private.COClassName = 'AbstractObject' :: 'AbstractObject'
private.Hierarchy = mt.SetMode({} :: {[userdata]: {[any]:any}}, 'kv')

function private.InjectObjectDataToClass <class, type> (self: class, name: type)
	local this = oop.Expanding({} :: any, self)
	this.ClassName = name
	this.Identificator = http:GenerateGUID(false)
	return this :: class
end

function private.SetMetaObject <meta, value> (self: meta, objVal: value)
	local this : any = self
	mt.SpecifyTo(this, objVal)
	this.__tostring = private.GetClassName --private.getClassNameForAbstractInstance  
	this.__metatable = 'Locked metatable'
	return self
end

-- Внутренние данные у экземпляров этого класса не требуется сохранять где-либо еще, т.к __index метатаблицы назначен на эти внутренние данные. Это предовтращает его удаление.
function private.CreateObject <data, type> (self: data, name: type) 
	local object = newproxy(true, name)
	local mt = getmetatable(object)
	local value : any = oop.Expanding(self, public)
	
	
	private.SetMetaObject(mt, value)
	
	return object
end

function private.DoRelativeTo (self: userdata, to: {})
	private.Hierarchy[self]=to
	return self
end

function private.DoGetRelative (self: CodeObject<any, string>)
	return private.Hierarchy[self]
end

function private.NewBaseObject <data, type> (self: data, name: type)
	debug.profilebegin(script.Name..'.CreateAbstractInstance')
	
	local data = private.InjectObjectDataToClass(self, name)
	local object = private.CreateObject(data, name)
	private.DoRelativeTo(object, self)

	debug.profileend()
	return object
end











-- Функция нужна для корректной работы метатаблиц.
function private.GetClassName (self: CodeObject<unknown,unknown>)
	return self.ClassName
end 
-- Проверка не обеспечивает глубокого поиска, т.к получить релативный прокси по объекту нельзя,
-- поскольку это противоречит архитектурному домыслу oop плагина.
function private.DoCheckIsItA (self: CodeObject<any, string>)
	local origin = private.DoGetRelative(self)
	return origin.ClassName or private.COClassName
end

-- Вернет ClassName родителя этого класса.
function public.AncestorName (self: any) : string | typeof(private.COClassName)
	return private.DoCheckIsItA(self) :: string
end



-- Создает над данными инкапсуляцию. Эмулирует классовую структуру роблокса.
function class.New <data, type> (self: data, ClassName: type)
	return private.NewBaseObject(self, ClassName) :: CodeObject<data, type>
end

type COId = string
type userdata = setmetatable<{},{[string]:any}>
type class = {}|self

type InjectedObjectData <classname> = {
	ClassName: classname,
	Identificator: COId
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
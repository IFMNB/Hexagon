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
private.DebugID = game["Run Service"]:IsStudio() and mt.SetMode({} :: {[string]: any}, 'v')


function private.DebugNew (id: string, to: any)
	if private.DebugID then
		private.DebugID[id]=to
		print(private.DebugID)
	end
end
function private.DoRelativeTo (self: userdata, to: {})
	private.Hierarchy[self]=to
end
function private.DoGetRelative (self: CodeObject<any, string>)
	return private.Hierarchy[self]
end





function private.InjectObjectDataToClass <class, type> (self: class, name: type)
	local this : any = table.clone(public)
	this.ClassName = name
	this.Identificator = http:GenerateGUID(false)
	
	
	private.DebugNew(this.Identificator, this)
	
	return mt.DoProxy(self,this)
end

function private.CreateObject <data, type> (self: data, name: type) 
	local object = newproxy(true, name)
	local meta = getmetatable(object)

	mt.SpecifyTo(meta, self)
	meta.__tostring = private.GetClassName
	meta.__metatable = 'Locked metatable'
	
	return object
end






function private.NewBaseObject <data, type> (self: data, name: type)
	debug.profilebegin(script.Name..'.CreateAbstractInstance')
	
	local inject = private.InjectObjectDataToClass(self, name)
	local object = private.CreateObject(inject, name)
	
	private.DoRelativeTo(object, self)
	link.Link(object,self)

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
function public:AncestorName () : string | typeof(private.COClassName)
	return private.DoCheckIsItA(self :: any)
end

-- Создает над данными инкапсуляцию. Эмулирует классовую структуру роблокса.
function class.New <data, type> (self: data, ClassName: type) : CodeObject<data, type>
	return private.NewBaseObject(self, ClassName)
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
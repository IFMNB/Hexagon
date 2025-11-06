--!strict

local app = require('./')
local plugin = app.GetPluginProvider()
local arch = app.GetArchProvider()
local sys = arch.GetSystem()

local oop = plugin.GetOOP()
local obj = arch.GetObject()
local chg = sys.GetChanged().GetProtected()

local private = {}
local public = {}
local class = {}
local root = {}

private.EntityClassName = 'Entity' :: 'Entity'


function private.DoCreateNewEntity <this> (self: this)
	local sig = chg.New(self)
	return obj.New(sig, private.EntityClassName)
end

function private.DoEmulateNew <this> (self: this & {}, parameter: any)
	local hook, sig = chg.Create(self[parameter])
	local this = chg.Inject(self, sig)
	self[parameter]= hook
	return obj.New(this, private.EntityClassName)
end




-- Оборачивает существующий код в объект, соединенный с сигналом Changed.
function class.New <this> (self: this) : Entity<this>
	return private.DoCreateNewEntity(self)
end

-- Аналогичен New, за исключением того, что оборачивается указанный параметр. Ссылка на сигнал встраивается в таблице родителя
function class.NewEmulate <this> (self: this, parameter: any) : Entity<this>
	return private.DoEmulateNew(self, parameter)
end


type _ent = Entity<{}> & {}

type ChangedSig = typeof(chg.New({}))
export type Entity<this> = typeof(obj.New({} :: public & ChangedSig, private.EntityClassName)) & this

export type ancestors = root & app.all
export type public = typeof(public)
export type root = typeof(root)
export type self = typeof(class)
-- Представляет изменяемую сущность.
function root.GetClass () return class end
oop.Expanding(root,app)
return root
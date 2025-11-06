--!strict

local parent = require('./')
local ancestors = parent :: parent.ancestors

local plugin = ancestors.GetPluginProvider()

local sig = parent.GetProtected() :: parent.protected
local oop = plugin.GetOOP()

local hook = ancestors.GetHooks ()

local private = {}
local protected = {}
local class = {}
local root = {}


type clients = {[any]: parent.Signal}

function private.DoCreateNewWatcher ()
	local signal = sig.NewSignal() :: parent.SignalProtected
	signal:BindTo('__newindex')
	signal:DoOverride('never')
	signal:Resume()
	
	return signal
end

function private.DoCreateNew (self: {[any]:any})
	local signal = private.DoCreateNewWatcher()
	
	--self.ChangedSignal = signal
	local params = signal:GetParams()
	local instance = hook.New(self, params)

	return instance, signal
end

function private.DoInjectNewSignal <this> (self: this, signal: parent.Signal) : SignalChanged<this>
	(self :: any).ChangedSignal = signal
	return self
end

function private.DoCreateNewChangedInstance<this> (self: this)
	local h,s = private.DoCreateNew(self)
	local t = private.DoInjectNewSignal(self, s)
	return t
end






-- Класс встраивает в объект механизм, который реагирует на изменения в своей таблице.
function class.New <this> (self: this) : SignalChanged<this>
	return private.DoCreateNewChangedInstance(self)
end
-- Возвращает хук и сигнал отдельными компонентами.
function protected.Create <this> (self: this)
	return private.DoCreateNew(self)
end
-- Встраивает сигнал в указанный объект
function protected.Inject <this> (self: this, signal: parent.Signal) : SignalChanged<this>
	return private.DoInjectNewSignal(self, signal)
end

type func = (self: any)->()
export type Changed  = parent.Signal
export type SignalChanged <this> = this & {ChangedSignal: Changed}

export type ancestors = root & parent.ancestors
export type root = typeof(root)
export type self = typeof(class)
export type protected = self & typeof(protected)

-- Используется как RBXScriptSignal
function root.GetClass () return class end
function root.GetProtected () return class :: protected end
oop.Expanding(root,ancestors)
oop.Expanding(class, protected)
return root
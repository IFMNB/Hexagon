--!strict

local parent = require('./')
local ancestors = parent :: parent.ancestors

local plugin = ancestors.GetPluginProvider()

local sig = parent.GetClass() :: parent.protected
local obj = ancestors.GetObject()
local oop = plugin.GetOOP()

local hook = ancestors.GetHooks ()

local private = {}
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

function private.DoCreateNewHook (self: {[any]:any})
	local signal = private.DoCreateNewWatcher()
	
	self.ChangedSignal = signal
	local instance = hook.New(self, signal)

	return instance
end








-- Класс встраивает в объект механизм, который реагирует на изменения в таблице.
function class.New <this> (self: this) : this & {ChangedSignal: Changed}
	return private.DoCreateNewHook(self) :: any
end

type func = (self: any)->()
export type Changed  = parent.Signal

export type ancestors = root & parent.ancestors
export type root = typeof(root)
export type self = typeof(class)

-- Используется как RBXScriptSignal
function root.GetClass () return class end
oop.Expanding(root,ancestors)
return root
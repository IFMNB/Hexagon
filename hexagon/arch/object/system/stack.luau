--!strict

local main = require('../')

local plugin = main.GetPluginProvider()
local shd = plugin.GetShadow()
local obj = main.GetObject()

local private = {}
local public = {}
local class = {}
local root = {}

private.StackClassName = 'Stack' :: 'Stack'




function private.Count (self: Stack)
	return #self:Get()
end

function private.DoCreateNewStack ()
	local stack = {}

	local mt = {}
	mt.__index = public
	mt.__len = private.Count
	setmetatable(stack,mt)
	
	local object = obj.New(stack :: public, private.StackClassName)
	local shade = shd.New(object)
	shade._lifo = {}
	
	return object
end



function private.GetStack (self: Stack)
	return shd.Get(self)._lifo
end

function private.DoPullFromStack (self: Stack)
	local st = private.GetStack(self)
	local i = #st
	local v = st[i]
	table.remove(st,i)
	return v
end

function private.DoPushInStack (self: Stack, value: stacked)
	local st = private.GetStack(self)
	table.insert(st, value)
	return self
end

function private.GetTop (self: Stack) : stacked
	return private.GetStack(self)[#self]
end














-- Вытащить из стека.
function public:Pull ()
	return private.DoPullFromStack(self)
end
-- Поместить в стек.
function public:Push (value: stacked) : Stack
	return private.DoPushInStack(self, value)
end
-- Прочитать топ.
function public:Top ()
	return private.GetTop(self)
end
-- Получить все значения.
function public:Get() : {stacked}
	return private.GetStack(self)
end






-- Создает новый стек.
function class.New ()
	return private.DoCreateNewStack()
end

type stacked = any
export type Stack = typeof(private.DoCreateNewStack())

export type public = typeof(public)
export type root = typeof(root)
export type self = typeof(class)

-- Используется для стека. LIFO структура.
function root.GetStack () return class end
setmetatable(root,{__index = main})
return root
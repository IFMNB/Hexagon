--!strict

local parent = require('../')
local ancestors = parent :: parent.ancestors

local plugin = ancestors.GetPluginProvider()
local oop = plugin.GetOOP()
local obj = ancestors.GetObject()

local private = {}
local public = {}
local class = {}
local root = {}

private.StackClassName = 'Stack' :: 'Stack'




function private.Count (self: _stack)
	return #self._lifo
end

function private.DoCreateNewStack () : Stack
	local stack = {} :: _stack
	
	stack._lifo = {}
	oop.Expanding(stack, public)
	local mt = getmetatable(stack)
	mt.__len = private.Count
	
	local object = obj.New(stack, private.StackClassName)
	return object
end



function private.GetStack (self: _stack)
	return self._lifo
end

function private.DoPullFromStack (self: _stack)
	local st = private.GetStack(self)
	local i = #st
	local v = st[i]
	table.remove(st,i)
	return v
end

function private.DoPushInStack (self: _stack, value: stacked)
	local st = private.GetStack(self)
	table.insert(st, value)
	return self
end

function private.GetTop (self: _stack) : stacked
	return private.GetStack(self)[#self]
end














-- Вытащить из стека.
function public.Pull (self: Stack)
	return private.DoPullFromStack(self :: _stack)
end
-- Поместить в стек.
function public.Push (self: Stack, value: stacked) : Stack
	return private.DoPushInStack(self :: _stack, value)
end
-- Прочитать топ.
function public.Top (self: Stack)
	return private.GetTop(self :: _stack)
end






-- Создает новый стек.
function class.New ()
	return private.DoCreateNewStack()
end

type stacked = any

type _stack = Stack & {
	_lifo: {stacked}
}
export type Stack = typeof(obj.New({} :: public, private.StackClassName))

export type public = typeof(public)
export type ancestors = root & parent.ancestors
export type root = typeof(root)
export type self = typeof(class)

-- Используется для стека. LIFO структура.
function root.GetStack () return class end
oop.Expanding(root, ancestors)
return root
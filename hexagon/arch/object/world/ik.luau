--!strict

-- Интерфейс для работы с IK-системами.

local parent = require('./')
local ancestors = parent :: parent.ancestors

local provider = ancestors.GetPluginProvider()
local oop = provider.GetOOP()
local mt = provider.GetMeta()

local private = {}
local public = {}
local class = {}
local root = {}


private.ik = {}


function private.DoCreateNewIk ()
	
end

function private.GetCurrentIk ()
	
end

function class.New ()
	
end

export type ancestors = root & parent.ancestors
export type root = typeof(root)
export type self = typeof(class)

-- Используется для указания текущей позиции, к которой должен стремиться указанный объект.
function root.GetIK() return class end
return root
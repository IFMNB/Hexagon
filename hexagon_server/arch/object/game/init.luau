--!strict

-- Локальная группа для игровых классов. 

local parent = require('./')
local ancestors = parent :: parent.ancestors

local private = {}
local public = {}
local root = {}






















type public = typeof(public)

export type ancestors = root & parent.ancestors
export type self = typeof(public)
export type root = typeof(root)


-- Возвращает специальные методы для всех, у кого есть доступ к этому модулю.
function root.GetGame () return public end
ancestors.GetArchProvider(). .GetPluginProvider().GetOOP().Expanding(root, parent)
return root
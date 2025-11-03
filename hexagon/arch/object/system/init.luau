--!strict

-- Локальная группа для системных классов.

local parent = require('./')
local ancestors = parent :: parent.ancestors

local private = {}
local public = {}
local root = {}


function private.GetServerDataByIndex (self: string)
	
end









function public.GetServerParams (self: string)
	
end


type public = typeof(public)
export type ancestors = root & parent.ancestors
export type self = typeof(public)
export type root = typeof(root)


-- Возвращает специальные методы для всех, у кого есть доступ к этому модулю.
function root.GetSystem () return public end
ancestors.GetPluginProvider().GetOOP().Expanding(root, parent)
return root
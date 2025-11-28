--!strict

-- Высокоуровневые реализации.

local replica = require('../replica_link')
local arch = script.Parent.Parent.arch

local public = {}
local _G = {}

-- Контейнер _G для app части.
function public.Global ()
	return _G
end
-- Возвращает главный провайдер архитектуры.
function public.Arch ()
	return require(arch.provider)
end

function public.Replica ()
	return require('../replica_link')
end

function public.Plugin ()
	return require('../plugins').GetServerPlugin()
end

-- Конфиг Hexagon
function public.Config ()
	return require('./')
end
-- Энумераторы Hexagon
function public.Enum ()
	return replica.GetEnums()
end

export type all = self
export type self = typeof(public)

return public
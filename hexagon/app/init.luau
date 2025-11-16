--!strict

-- Высокоуровневые реализации.

local plugins = require('./enum/plugins')
local arch = script.Parent.arch

local public = {}
local _G = {}

-- Контейнер _G для app части.
function public.Global ()
	return _G
end

-- Возвращает главный провайдер архитектуры.
function public.GetArchProvider ()
	return require(arch.provider)
end

export type all = self & plugins.ancestors
export type self = typeof(public)

plugins.GetPluginProvider().GetOOP().Expanding(public, plugins)
return public :: all
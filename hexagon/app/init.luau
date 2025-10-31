--!strict

local plugins = require('./plugins')
local arch = script.Parent.arch

local public = {}
local root = {}


-- Возвращает главный провайдер архитектуры.
function public.GetArchProvider ()
	return require(arch.provider)
end

export type all = self & plugins.ancestors
export type self = typeof(public)

plugins.GetPluginProvider().GetOOP().Expanding(public, plugins)
return public :: all
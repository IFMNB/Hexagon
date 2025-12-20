--!strict

-- Высокоуровневые реализации.

local plugins = require('../enum/plugins')
local arch = script.Parent.Parent.arch

local public = {}
local _G = {}


-- Main arch provider
function public.Arch ()
	return require(arch.provider)
end
-- Hexagon cfg
function public.Config ()
	return require('../config')
end
-- HexagonEnum
function public.Enum ()
	return require('../enum')
end

export type all = self & plugins.ancestors
export type self = typeof(public)

plugins.GetPluginProvider().GetOOP().Expanding(public, plugins)
return public :: all
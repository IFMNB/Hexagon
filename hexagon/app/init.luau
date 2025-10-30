--!strict

local plugins = require('./plugins')
local arch = script.Parent.arch

local public = {}
local root = {}


-- Возвращает главный провайдер архитектуры.
function public.GetArchProvider ()
	return require(arch.provider)
end
-- Возвращает объект-инкапсулятор из архитектуры.
function public.GetObject ()
	return require(arch.object)
end

-- Возвращает корневой объект приложения.
function root.GetApp () return public end
plugins.GetProviderPlugin().GetOOP().Expanding(root, plugins)
return root
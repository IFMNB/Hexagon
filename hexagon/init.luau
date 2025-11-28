--!strict

local app = script.config.app
local arch = script.arch

local public = {}

-- 
function public.GetPluginProvider ()
	return require(script.enum.plugins).GetPluginProvider()
end
-- Arch provides the simplest objects in the Hexagon hierarchy, used in various parts of the library. Because these are structural components, they are accessible to everyone.
function public.GetArchProvider ()
	return require(arch.provider)
end
--[[
App modules implement a variety of non-architectural logic. This logic depends on the Hexagon configuration and is controlled through the configurator.

It may contain its own local parameters and settings, in some cases accessible externally. However, these are usually provided as immutable hardcoded code.
]]
function public.GetAppProvider ()
	return require(app.provider)
end
-- Hexagon enumerators serve as a single, authoritative source of content supplied by all Hexagon modules. They also provide tools for creating custom enum values.
function public.GetEnums ()
	return require(script.enum)
end
-- The Hexagon configurator provides internal parameters to control various parts of the library code.
function public.GetConfig ()
	return require(script.config)
end

export type ancestors = project_replica
export type project_replica = typeof(public)


-- Провайдеры
--[[

	plugin
		Провайдит доступ к нижним деталям проекта.
	Arch.provider
		Провайдит доступ ко всем классам Arch.
	App.provider
		Провайдит доступ ко всем классам App.

]]

-- Классы
--[[

	- Все классы зависят от провайдера plugins

	Arch
		Классы этой иерархии реализуют базовое поведение.
	App
		Классы этой иерархии реализуют целевое поведение.
		Они используются как основные релизные компоненты.
		Зависимы от Arch.
		
		
	- Сами по себе каждый из классов не содержит целевой игровой логики.
	- Все что имеет в себе библиотека - не более чем конструктор лего,
	который содержит готовые решения для игровой логики.

]]

return public
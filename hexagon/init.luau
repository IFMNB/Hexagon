--!strict

local app = script.app
local arch = script.arch

local public = {}

-- Основной узел маршрутизации по низшим деталям проекта.
function public.GetPlugins ()
	return require(script.plugins).GetProviderPlugin()
end
-- Основной узел маршрутизации по низшим классам проекта.
function public.GetArchProvider ()
	return require(arch.provider)
end
-- Основной узел маршрутизации по высшим классам проекта.
function public.GetAppProvider ()
	return require(app.provider)
end




export type ancestors = project_replica
export type project_replica = typeof(public)


-- Провайдеры
--[[

	plugins
		Провайдит доступ к низним деталям проекта.
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

]]

return public
--!strict

local project = game.ReplicatedStorage.hexagon

local public = {}


-- Основной узел маршрутизации по низшим классам проекта.
function public.GetArchProvider ()
	return require(project.arch.provider)
end
-- Основной узел маршрутизации по высшим классам проекта.
function public.GetAppProvider ()
	return require(project.app.provider)
end
-- Основной узел маршрутизации по низшим деталям проекта.
function public.GetPluginProvider ()
	return require(project.plugins).GetPluginProvider()
end



export type project_all = typeof(public)
return public :: project_all
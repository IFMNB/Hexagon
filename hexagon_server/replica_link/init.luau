--!strict

-- Стоит изменить ссылку, если переносите какие либо данные в другое место.

local project = require(game.ReplicatedStorage.hexagon)

local public = {}


---- Основной узел маршрутизации по низшим классам проекта.
--function public.GetArchProvider ()
--	return require(project.arch.provider)
--end
---- Основной узел маршрутизации по высшим классам проекта.
--function public.GetAppProvider ()
--	return require(project.app.provider)
--end
---- Основной узел маршрутизации по низшим деталям проекта.
--function public.GetPluginProvider ()
--	return require(project.plugins).GetPluginProvider()
--end

setmetatable(public, {__index = project})

export type project_all = project.project_replica typeof(public)
return public :: project_all
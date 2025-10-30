--!strict

local replica_link = require(script.replica_link)

local public = {}


-- Основной узел маршрутизации по низшим деталям для серверной части проекта.
function public.GetServerPlugin ()
	return require(script.plugins).GetServerPlugin()
end
-- Основной узел маршрутизации к реплицируемой на клиент части проекта.
function public.GetReplicated ()
	return require(script.replica_link)
end
-- Основной узел маршрутизации по низшим классам для серверной части проекта.
function public.GetServerArchProvider ()
	return require(script.arch.provider)
end
-- Основной узел маршрутизации по высшим классам для серверной части проекта.
function public.GetServerAppProvider ()
	return --require(script.app.provider)
end

export type project = typeof(public)
return public :: project
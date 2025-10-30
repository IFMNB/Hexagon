--!strict

-- Независимый провайдер, который предоставляет доступ к основным системным модулям в реплицируемой для клиента части игры.

local path = script.Parent.Parent.object.system

local public = {}
-- Библиотека для создания оберток с кастом-поведением.
function public.GetHook ()
	return require(path.hooks)
end
-- Библиотека для создания реактивных наблюдателей за изменениями объектов.
function public.GetWatcher ()
	return require(path.hooks.watch)
end
-- Библиотека для работы с коллекциями объектов.
function public.GetCollection ()
	return require(path.collection)
end
-- Библиотека-аналог tweenService.
function public.GetSwipe ()
	return require(path.swipe)
end

public.SystemPath = path

export type self = typeof(public)

return public
--!strict

-- Независимый провайдер, который предоставляет доступ к основным системным модулям в реплицируемой для клиента части игры.

local path = script.Parent.Parent.object.system

local public = {}
-- Класс для создания оберток с кастом-поведением.
function public.GetHook ()
	return require(path.hooks)
end
-- Класс для создания реактивных наблюдателей за изменениями объектов.
function public.GetWatcher ()
	return require(path.hooks.watch)
end
-- Класс для работы с коллекциями объектов.
function public.GetCollection ()
	return require(path.collection)
end
-- Класс-аналог tweenService.
function public.GetSwipe ()
	return require(path.swipe)
end
-- Класс для хранения данных по принципу LIFO
function public.GetStack ()
	return require(path.stack)
end
-- Класс для хранения данных по принципу FIFO
function public.GetQueue ()
	return require(path.queue)
end

public.SystemPath = path

export type self = typeof(public)

return public
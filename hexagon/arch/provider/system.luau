--!strict

-- Независимый провайдер, который предоставляет доступ к основным системным модулям в реплицируемой для клиента части игры.

local path = script.Parent.Parent.object.system

local public = {}
-- Класс для создания оберток с кастом-поведением.
function public.GetHook ()
	return require(path.hooks)
end
-- Класс для создания реактивных наблюдателей за изменениями объектов.
@deprecated
function public.GetWatcher ()
	return require(path.hooks.watch)
end
-- Абстрактный класс эмулятор RBXScriptSignal.
function public.GetSignal ()
	return require(path.hooks.signal)
end
-- Класс для реактивного реагирования
function public.GetChanged ()
	return require(path.hooks.signal.changed)
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
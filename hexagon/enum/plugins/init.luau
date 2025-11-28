--!strict

-- Независимый провайдер, который предоставляет доступ к независимым плагинам для примитивов языка или объектов роблокса в реплицируемой для клиента части игры.

local plugin 					= script 

local public = {}
local root = {}


-- Возвращает плагин для расширенной работы с таблицами.
function public.GetTable ()
	return require(plugin.tbl)
end
-- Возвращает плагин для расширенной работы с буфферами, предоставляю на основе их API обертки с готовыми реализациями.
function public.GetBuffer ()
	return require(plugin.buf)
end
-- Возвращает плагин для работы со специальными числовыми значениями.
function public.GetNumber ()
	return require(plugin.math.num)
end
-- Возвращает плагин для работы со строками и ASCII.
function public.GetString ()
	return require(plugin.str)
end
-- Возвращает плагин, реализующий псевдо-строгую языковую проверку на тип данных.
function public.GetInt ()
	return require(plugin.math.num.int)
end
-- Возвращает плагин для расширенной работы с буфферами-строками.
function public.GetBufferString ()
	return require(plugin.buf.bufStr)
end
-- Возвращает плагин, который реализует функционал из других языков программирования.
function public.GetImported ()
	return require(plugin.import)
end
-- Возвращает плагин, который работает с метатаблицами на базовом уровне.
function public.GetMeta ()
	return require(plugin.metatable)
end
-- Возвращает плагин, который реализует прототипное наследование.
function public.GetOOP ()
	return require(plugin.metatable.oop)
end
-- Возвращает плагин, который реализует обертки над математическими функциями.
function public.GetMath ()
	return require(plugin.math)
end
-- Возвращает плагин, который реализует обертки над векторными операциями.
function public.GetVector3 ()
	return require(plugin.vector3)
end
-- Возвращает плагин, который реализует механизм защиты от удаления объектов через __GarbageCollector
function public.GetLinker ()
	return require(plugin.metatable.linker)
end
-- Возвращает плагин, который реализует приватное почти несвязанное пространство с другими данными.
function public.GetShadow ()
	return require(plugin.metatable.linker.shadow)
end
-- Возвращает плагин, который реализует операции сетевого взаимодействия от лица клиента к серверу.
function public.GetNetwork ()
	return require(plugin.network)
end
-- Возвращает провайдер-плагин, содержащий в себе плагины для работы с объектами и иерархией роблокса.
function public.GetRobloxProvider ()
	return require(plugin.roblox)
end
-- Возвращает плагин с полезным функционалом для отладки.
function public.GetDebug ()
	return require(plugin.debug)
end
-- Возвращает плагин, который заставляет данные существовать все время, пока существует объект роблокса.
function public.GetReference ()
	return require(plugin.metatable.linker.reference)
end

public.PluginPath = plugin

export type ancestors = root
export type self = typeof(public)
export type root = typeof(root)

-- Provides access to generalized tools.
function root.GetPluginProvider () return public end
return root
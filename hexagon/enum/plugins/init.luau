--!strict

-- Независимый провайдер, который предоставляет доступ к независимым плагинам для примитивов языка или объектов роблокса в реплицируемой для клиента части игры.

local plugin 					= script 

local public = {}
local root = {}


-- Расширение для таблиц
function public.GetTable ()
	return require(plugin.tbl)
end
-- Расширение для буфферов
function public.GetBuffer ()
	return require(plugin.buf)
end
-- Расширенный функционал для работы с числовыми типами
function public.GetNumber ()
	return require(plugin.math.num)
end
-- Расширение функционала работы со строками
function public.GetString ()
	return require(plugin.str)
end
-- Работа с псевдо-C синтаксисом для чисел.
function public.GetInt ()
	return require(plugin.math.num.int)
end
-- Расширение для буфферов для работы со строками.
function public.GetBufferString ()
	return require(plugin.buf.bufStr)
end
-- Реализация функционала из других ЯП.
function public.GetImported ()
	return require(plugin.import)
end
-- Функционал работы с метатаблицами
function public.GetMeta ()
	return require(plugin.mt)
end
-- Функционал работы с наследованием.
function public.GetOOP ()
	return require(plugin.mt.oop)
end
-- Функционал работы с математикой.
function public.GetMath ()
	return require(plugin.math)
end
-- Функционал работы с векторами.
function public.GetVector3 ()
	return require(plugin.vector3)
end
-- Функционал сохранения данных от удаления _GC.
function public.GetLinker ()
	return require(plugin.mt.linker)
end
-- Функционал для хранения привязанных к конкретному объекту данных.
function public.GetShadow ()
	return require(plugin.mt.linker.shadow)
end
-- Функционал сетевого клиентского взаимодействия.
function public.GetNetwork ()
	return require(plugin.network)
end
-- Функционал клиента для манипуляциями с роблокс объектами.
function public.GetRoblox ()
	return require(plugin.roblox)
end

public.PluginPath = plugin

export type ancestors = root
export type self = typeof(public)
export type root = typeof(root)

-- Provides access to generalized tools.
function root.GetPluginProvider () return public end
return root
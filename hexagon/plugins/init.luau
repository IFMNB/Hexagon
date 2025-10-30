--!strict

-- Независимый провайдер, который предоставляет доступ к независимым плагинам для примитивов языка или объектов роблокса в реплицируемой для клиента части игры.

local plugin 					= script
local plugin_table				= plugin.tbl
local plugin_buffer 			= plugin.buf
local plugin_imported 			= plugin.import
local plugin_number 			= plugin.math.num
local plugin_string 			= plugin.str
local plugin_number_int 		= plugin.math.num.int
local plugin_buffer_string 		= plugin.buf.bufStr
local plugin_metatable			= plugin.mt
local plugin_metatable_oop		= plugin.mt.oop
local plugin_math				= plugin.math
local plugin_vector3			= plugin.vector3

local public = {}
local root = {}


-- Расширение для таблиц
function public.GetTable ()
	return require(plugin_table)
end
-- Расширение для буфферов
function public.GetBuffer ()
	return require(plugin_buffer)
end
-- Расширенный функционал для работы с числовыми типами
function public.GetNumber ()
	return require(plugin_number)
end
-- Расширение функционала работы со строками
function public.GetString ()
	return require(plugin_string)
end
-- Работа с псевдо-C синтаксисом для чисел.
function public.GetInt ()
	return require(plugin_number_int)
end
-- Расширение для буфферов для работы со строками.
function public.GetBufferString ()
	return require(plugin_buffer_string)
end
-- Реализация функционала из других ЯП.
function public.GetImported ()
	return require(plugin_imported)
end
-- Функционал работы с метатаблицами
function public.GetMeta ()
	return require(plugin_metatable)
end
-- Функционал работы с наследованием.
function public.GetOOP ()
	return require(plugin_metatable_oop)
end
-- Функционал работы с математикой.
function public.GetMath ()
	return require(plugin_math)
end
-- Функционал работы с векторами.
function public.GetVector3 ()
	return require(plugin_vector3)
end

public.PluginPath = plugin

export type ancestors = root
export type self = typeof(public)
export type root = typeof(root)

function root.GetPluginProvider () return public end
return root
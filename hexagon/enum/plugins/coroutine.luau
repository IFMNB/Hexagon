--!strict

local private = {}
local plugin = {}

function private.DoCreateTimeoutCoroutine (time: number, func: func, ...: any)
	local start = tick()
	local is, result : any
	local cor : thread = coroutine.running()
	local cor1 : thread
	local cor2 : thread
	cor1 = coroutine.create(function(...) is, result = pcall(func,...) end)
	cor2 = coroutine.create(function(...) while (tick()-start) < time and is == nil do task.wait() end coroutine.close(cor1) coroutine.resume(cor) end)
	coroutine.resume(cor1)
	coroutine.resume(cor2)
	coroutine.yield()
	return result :: any?
end



-- Досрочно завершит выделенную функцию, если она не вернет результат в течении заданного времени.
function plugin.Timeout (time: number, func: func, ...: any) : any?
	return private.DoCreateTimeoutCoroutine(time, func, ...)
end

type func = (...any)->any

export type ancestors = self
export type self = typeof(plugin)

return plugin
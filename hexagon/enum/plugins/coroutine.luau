--!strict
--!nolint DeprecatedApi

local private = {}
local plugin = {}

-- Cancels the coroutine after the specified time, if function is not finished by defined time.
@deprecated
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

function private.printerror(...)
	warn(...)
end
-- Creates a async coroutine and executes it. Used xpcall.
function private.CreateAsync (func: func, handler: (errmsg: string)->()?, ...: any)
	return xpcall(coroutine.wrap(func),handler or private.printerror,...)
end




plugin.Timeout = private.DoCreateTimeoutCoroutine
plugin.Async = private.CreateAsync

type func = (...any)->any
return plugin
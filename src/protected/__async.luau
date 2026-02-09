local private = {}
local interface = {}

type F = (...any)->any
type Fc = (ResumeThread: F, ...any)->any

-- Yields until the ResumeThread is called. Return value that goes from the ResumeThread.
function private.coroutine_async_F_controllable (F: Fc, ...: any)
	local thread = coroutine.running()
	local cor = coroutine.create(function(...) 
		local cor = coroutine.create(function(...) 
			task.wait(5)
			warn('Controllable coroutine still running, did you forget to close her?')
		end)

		F(function (...: any)
			coroutine.resume(thread, ...)
			return
		end)
	end)
	task.defer(cor)
	return coroutine.yield()
end

-- Yields until the function is finished. Return value that goes from the function.
function private.coroutine_async_F <T> (F: F&T, ...: any)
	local thread = coroutine.running()
	local cor = coroutine.create(function(...) 
		local result = F(...)
		coroutine.resume(thread,result)
	end)
	task.defer(cor)
	return coroutine.yield()
end

interface.AsyncControll = private.coroutine_async_F_controllable;
interface.Async = private.coroutine_async_F;

return interface 
local private = {}
local interface = {}

type F = (...any)->any
type Fc = (ResumeThread: F, ...any)->any

function private.coroutine_async_F_controllable (F: Fc, ...: any)
	local thread = coroutine.running()
	local lambda : any
	local cor = coroutine.create(function(...) 
		local cor = coroutine.create(function(...) 
			task.wait(5)
			warn('Controllable coroutine still running, did you forget to close her?')
		end)
		lambda = coroutine.yield(thread)
		coroutine.resume(cor)
		F(function (...: any)
			coroutine.resume(thread, ...)
			coroutine.close(cor)
			return
		end)
	end)
	coroutine.resume(cor,...)
	return lambda
end

function private.coroutine_async_F (F: F, ...: any)
	local thread = coroutine.running()
	local lambda : any
	local cor = coroutine.create(function(...) 
		lambda = coroutine.yield(thread)
		coroutine.resume(thread,F(...))
	end)
	coroutine.resume(cor, ...)
	return lambda
end

interface.AsyncControll = private.coroutine_async_F_controllable;
interface.Async = private.coroutine_async_F;

return interface 
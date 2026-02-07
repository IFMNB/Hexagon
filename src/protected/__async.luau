local private = {}
local interface = {}

type F = (...any)->any
type Fc = (ResumeThread: F, ...any)->any


function private.wait_status (cor: thread)
	local status
	repeat
		status = coroutine.status(cor)
		if status == 'dead' then
			return
		elseif status == 'running' then
			task.wait()
		end
	until status ~= 'suspended'
end

-- Yields until the ResumeThread is called. Return value that goes from the ResumeThread.
function private.coroutine_async_F_controllable (F: Fc, ...: any)
	local thread = coroutine.running()
	local cor = coroutine.create(function(...) 
		local cor = coroutine.create(function(...) 
			task.wait(5)
			warn('Controllable coroutine still running, did you forget to close her?')
		end)

		F(function (...: any)
			private.wait_status(cor)
			coroutine.resume(thread, ...)
			return
		end)
	end)
	return coroutine.yield(thread,coroutine.resume(cor,...))
end

-- Yields until the function is finished. Return value that goes from the function.
function private.coroutine_async_F <T> (F: F&T, ...: any)
	local thread = coroutine.running()
	local cor = coroutine.create(function(...) 
		local result = F(...)
		private.wait_status(thread)
		coroutine.resume(thread,result)
	end)
	return coroutine.yield(coroutine.resume(cor, ...))
end

interface.AsyncControll = private.coroutine_async_F_controllable;
interface.Async = private.coroutine_async_F;

return interface 
--!strict

-- This module is used to get classes for system objects.

local path = script.Parent.Parent.object.system

local public = {}


-- Class for creating hooks with custom behavior.
function public.GetHook ()
	return require(path.hook).GetHook()
end
-- Reactive class-instance, used to store some data and fire it on changes
function public.GetEntity ()
	return require(path.hook.entity).GetEntity()
end
-- Class-data, used to store some data by using LIFO
function public.GetStack ()
	return require(path.stack).GetStack()
end
-- Class-data, used to store some data by using FIFO
function public.GetQueue ()
	return require(path.queue).GetQueue()
end

public.SystemPath = path

export type self = typeof(public)

return public
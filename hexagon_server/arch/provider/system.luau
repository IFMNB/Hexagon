--!strict

local path = script.Parent.Parent.system
local public = {}



-- Планировщик
function public.GetSchedule ()
	return require(path.schedule)
end

@deprecated
function public.GetTimer ()
	return require(path.timer)
end

public.Path = path

export type self = typeof(public)
return public
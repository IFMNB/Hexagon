--!strict

local path = script.Parent.Parent.gameplay
local public = {}




function public.GetRound ()
	return require(path.rounds)
end

function public.Character ()
	return error('dev')
end

public.Path = path
	
export type self = typeof(public)
return public
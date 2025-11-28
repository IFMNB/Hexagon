--!strict

local path = script.Parent.Parent.system
local public = {}



-- Task-scenario packs.
function public.GetSchedule ()
	return require(path.schedule)
end
-- Handles playerdata to strict typesolver.
function public.GetPlayerData ()
	return require(path.playerdata)
end


public.Path = path

export type self = typeof(public)
return public
--!strict

local provider				= script
local provider_game			= provider.game
local provider_system		= provider.system
local provider_world		= provider.world



local public = {}




function public.GetGame ()
	return require(provider_game)
end
function public.GetSystem ()
	return require(provider_system)
end
function public.GetWorld ()
	return require(provider_world)
end




export type ancestors = self
export type self = typeof(public)

return public
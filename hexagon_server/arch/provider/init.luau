--!strict

local provider				= script
local provider_game			= provider.game
local provider_system		= provider.system
local provider_world		= provider.world



local public = {}



-- Provides access to basic serverside modules, used in gameplay scripts.
function public.GetGame ()
	return require(provider_game)
end

-- Provides access to basic serverside modules.
function public.GetSystem ()
	return require(provider_system)
end

-- Reloading api content. Returns nothing.
@deprecated
function public.GetWorld ()
--	return require(provider_world)
end




export type ancestors = self
export type self = typeof(public)

return public
--!strict

--

local app = script.Parent
local provider = script

local public = {}

-- This application allows you to position a player relative to the server or client. The application targets the PrimaryPart of the character model.
function public.GetPlayerCharacterNetworkSide ()
	return require(app.PlayerCharacterNetworkSide)
end
-- This application allows you to count the number of frames per second.
function public.GetFramePerSecondCounter ()
	return require(app.FramePerSecondCounter)
end

public.AppPath = app
public.AppProviderPath = provider

export type ancestors = self
export type self = typeof(public)

return public
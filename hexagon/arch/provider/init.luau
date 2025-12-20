--!strict

local provider				= script
local object = script.Parent.object

local public = {}





-- A class that wraps instances in a special access layer.
function public.GetObject ()
	return require(object).GetObject()
end
-- An independent provider that provides access to core system modules in the client-side replicated portion of the game.
function public.GetSystem ()
	return require(provider.system)
end

public.ArchPath = script.Parent
public.ArchProviderPath = provider


export type ancestors = self
export type self = typeof(public)

return public
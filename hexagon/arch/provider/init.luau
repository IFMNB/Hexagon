--!strict

-- Этот провайдер используется внешними зависимостями. Он никак не связан с Arch, кроме того, что является провайдером.

local provider				= script
local object = script.Parent.object

local public = {}





-- A class that wraps instances in a special access layer.
function public.GetObject ()
	return require(object).GetObject()
end
-- An independent provider that provides access to core game modules in the client-side replicated portion of the game.
--function public.GetGame ()
--	return require(provider.game)
--end
-- An independent provider that provides access to core system modules in the client-side replicated portion of the game.
function public.GetSystem ()
	return require(provider.system)
end
-- An independent provider that provides access to classes that extend the basic behavior of Roblox objects.
function public.GetWorld ()
	return require(provider.world)
end

public.ArchPath = script.Parent
public.ArchProviderPath = provider


export type ancestors = self
export type self = typeof(public)

return public
--!strict

-- Этот провайдер используется внешними зависимостями. Он никак не связан с Arch, кроме того, что является провайдером.

local app = script.Parent
local provider				= script

local public = {}


-- The elementary upper class from which the other classes originate
function public.GetEntity ()
	return require(app.entity)
end


public.AppProviderPath = provider

export type ancestors = self
export type self = typeof(public)

return public
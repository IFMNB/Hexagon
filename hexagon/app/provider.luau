--!strict

-- Этот провайдер используется внешними зависимостями. Он никак не связан с Arch, кроме того, что является провайдером.

local provider				= script

local public = {}




public.AppProviderPath = provider

export type ancestors = self
export type self = typeof(public)

return public
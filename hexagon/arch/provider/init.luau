--!strict

-- Этот провайдер используется внешними зависимостями. Он никак не связан с Arch, кроме того, что является провайдером.

local provider				= script
local object = script.Parent.object

local public = {}





-- Основной элемент класса. Инкапсулирует данные.
function public.GetObject ()
	return require(object).GetObject()
end
-- Независимый провайдер, который предоставляет доступ к основным игровым модулям в реплицируемой для клиента части игры.
function public.GetGame ()
	return require(provider.game)
end
-- Независимый провайдер, который предоставляет доступ к основным системным модулям в реплицируемой для клиента части игры.
function public.GetSystem ()
	return require(provider.system)
end
-- Независимый провайдер, который предоставляет доступ к классам, расширяющим базовое поведение объектов роблокса.
function public.GetWorld ()
	return require(provider.world)
end

public.ArchProviderPath = provider


export type ancestors = self
export type self = typeof(public)

return public
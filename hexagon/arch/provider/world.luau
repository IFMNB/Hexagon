--!strict

local path = script.Parent.Parent.object.roblox

local public = {}





-- Расширяет поведение рейкастов. Добавляет специфическую логику "сплошных рейкастов" от базовой точки до точки назначения.
function public.GetRaySolid ()
	return require(path.raysolid)
end
-- Класс-аналог tweenService.
function public.GetSwipe ()
	return require(path.swipe)
end

public.WorldPath = path

export type self = typeof(public)
return public
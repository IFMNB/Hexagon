--!strict

local path = script.Parent.Parent.object.world

local public = {}





-- Расширяет поведение рейкастов. Добавляет специфическую логику "сплошных рейкастов" от базовой точки до точки назначения.
function public.GetRaySolid ()
	return require(path.raysolid)
end
-- Самостоятельная, расширенная реализация функций TweenService. Также распространяется на код.
function public.GetRobloxLink ()
	return require(path.robloxlink)
end

public.WorldPath = path

export type self = typeof(public)
return public
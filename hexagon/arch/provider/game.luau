--!strict

-- Независимый провайдер, который предоставляет доступ к основным игровым модулям в реплицируемой для клиента части игры.

local path = script.Parent.Parent.object.game

local public = {}




function public.GetOst ()
	return require(path.ost)
end

public.GamePath = path

export type self = typeof(public)
return public
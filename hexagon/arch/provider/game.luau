--!strict

-- Независимый провайдер, который предоставляет доступ к основным игровым модулям в реплицируемой для клиента части игры.

local path = script.Parent.Parent.object.gameplay

local public = {}





public.GamePath = path

export type self = typeof(public)
return public
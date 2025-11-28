--!strict

local path = script.Parent.Parent
local public = {}






public.Path = path

export type self = typeof(public)
return public
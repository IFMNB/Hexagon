--!strict

local path = script.Parent.Parent.object
local public = {}


public.Path = path
	
export type self = typeof(public)
return public
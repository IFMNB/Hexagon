--!strict

local path = script.Parent.Parent.roblox
local public = {}






function public.GetSetter ()
	return require(path.setter)
end

function public.GetSetterHumanoid ()
	return require(path.setter.humanoid)
end

public.Path = path

export type self = typeof(public)
return public
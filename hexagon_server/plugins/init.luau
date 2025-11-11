--!strict

local path = script

local public = {}
local root = {}






function public.GetInvoke ()
	return require(path.invoke)
end



@deprecated
function public.GetPart ()
	return require(path.part)
end

@deprecated
function public.GetModel ()
	return require(path.part.mdl)
end

export type ancestors = root
export type root = typeof(root)
export type self = typeof(public)

function root.GetServerPlugin() return public end
return root
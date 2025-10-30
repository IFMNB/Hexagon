--!strict

local path = script

local public = {}
local root = {}






function public.GetInvoke ()
	return path.invoke
end

export type ancestors = root
export type root = typeof(root)
export type self = typeof(public)

function root.GetServerPlugin() return public end
return root
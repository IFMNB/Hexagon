--!strict

local replica_link = require(script.replica_link)

local public = {}

function public.GetServerPluginProvider ()
	return require(script.plugins).GetServerPlugin()
end

function public.GetReplicatedProvider ()
	return require(script.replica_link)
end

function public.GetServerArchProvider ()
	return require(script.arch.provider)
end
-- 
function public.GetConfig ()
	return require('@self/config')
end

export type project = typeof(public)
return public :: project
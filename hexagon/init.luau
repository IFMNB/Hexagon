--!strict

-- Hexagon is a architecture roblox-emitter, that can used to emulate roblox development.

local app = script.config.app
local arch = script.arch

local public = {}

-- Returns the main plugin provider. This is main library dependency for all higher-classes, like, objects or entitites.
function public.GetPluginProvider ()
	return require(script.enum.plugins).GetPluginProvider()
end
-- Arch provides the simplest objects in the Hexagon hierarchy, used in various parts of the library. Because these are structural components, they are accessible to everyone.
function public.GetArchProvider ()
	return require(arch.provider)
end
--[[
App modules implement a variety of non-architectural logic. This logic depends on the Hexagon configuration and is controlled through the configurator.

It may contain its own local parameters and settings, in some cases accessible externally. However, these are usually provided as immutable hardcoded code.
]]
function public.GetAppProvider ()
	return require(app.provider)
end
-- Hexagon enumerators serve as a single, authoritative source of content supplied by all Hexagon modules. They also provide tools for creating custom enum values.
function public.GetEnums ()
	return require(script.enum)
end
-- The Hexagon configurator provides internal parameters to control various parts of the library code.
function public.GetConfig ()
	return require(script.config)
end

public.Path = script

export type ancestors = project_replica
export type project_replica = typeof(public)

return public
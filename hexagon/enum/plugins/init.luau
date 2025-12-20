--!strict



local plugin = script 

local public = {}
local root = {}


-- Used in big table manipulations.
function public.GetTable ()
	return require(plugin.tbl)
end
-- Plugin destributes advanced buffer tools.
function public.GetBuffer ()
	return require(plugin.buf)
end
-- Used to work with special numbers.
function public.GetNumber ()
	return require(plugin.math.num)
end
-- Related to all ASCII strings.
function public.GetString ()
	return require(plugin.str)
end
-- Pseudo-C syntax.
function public.GetInt ()
	return require(plugin.math.num.int)
end
-- Extra buffer tools, used to work with strings.
function public.GetBufferString ()
	return require(plugin.buf.bufStr)
end
-- Provides extra functionality.
function public.GetImported ()
	return require(plugin.import)
end
-- Retunrs extra tools to work with metatables.
function public.GetMeta ()
	return require(plugin.metatable)
end
-- Another __index way to prototype something like in POP (OOP)
function public.GetOOP ()
	return require(plugin.metatable.oop)
end
-- Returns extra tools with math lib.
@deprecated
function public.GetMath ()
	return require(plugin.math)
end
-- Shortcuts to work with Vector3 value types
function public.GetVector3 ()
	return require(plugin.vector3)
end
-- Special plugin to protect data from _GC
function public.GetLinker ()
	return require(plugin.metatable.linker)
end
-- Can private linked private data.
function public.GetShadow ()
	return require(plugin.metatable.linker.shadow)
end
-- Some useful functions. Used by applications.
function public.GetNetwork ()
	return require(plugin.network)
end
-- Provider to roblox pre-created functions.
function public.GetRobloxProvider ()
	return require(plugin.roblox)
end
-- Special debug plugin. Unavailable in production.
function public.GetDebug ()
	return require(plugin.debug)
end
-- Special construction on LinkerPlugin, used to save data by roblox instance.
function public.GetReference ()
	return require(plugin.metatable.linker.reference)
end

public.PluginPath = plugin

export type ancestors = root
export type self = typeof(public)
export type root = typeof(root)

-- Provides access to generalized tools.
function root.GetPluginProvider () return public end
return root
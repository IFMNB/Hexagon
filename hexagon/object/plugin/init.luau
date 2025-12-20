local plugin = script
local public = {}

-- Retunrs extra tools to work with metatables.
function public.GetMeta ()
	return require(plugin.metatable)
end
-- Special plugin to protect data from _GC
function public.GetLinker ()
	return require(plugin.linker)
end
-- Can private linked private data.
function public.GetShadow ()
	return require(plugin.linker.shadow)
end
-- Provides extra functionality.
function public.GetImported ()
	return require(plugin.import)
end

return public
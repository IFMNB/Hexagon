 --!strict

local meta = require('../')
local linker = require('./')
local enum = require('../../../')

local private = {}
local plugin = {}

private.References = {}:: {[Reference]: Link}
private.CanGet = meta.SetMode({} :: {[canLink]:Reference}, 'v')

function private.CreateNewReference(to: Link) : Reference
	local ref = {}
	private.References[ref]=to
	to.Destroying:Once(function() 
		private.References[ref]=nil
	end)
	return ref
end
function private.Root(to:Link)
	local is
	for i,v in pairs(private.References) do
		if v==to then
			is=i
		end
	end
	
	return is or private.CreateNewReference(to)
end



function private.DoLinkInstance (this: canLink, to: Link)
	local t0 = typeof(this)
	assert(t0 == 'userdata' or t0 == 'table' or t0 == 'function', tostring(enum.Error.Forbidden))
	assert(not private.GetRef(this), tostring(enum.Error.Forbidden))
	
	local ref = private.Root(to)
	
	private.SetGet(this, ref)
	linker.Link(ref, this)
	return this
end
function private.DoUnlinkInstance (this: canLink)
	linker.Unlink(private.GetRef(this), this)
	return this
end



function private.SetGet (this: canLink, to: Reference)
	private.CanGet[this]=to
end
function private.GetRef (this: canLink) : Reference
	return private.CanGet[this]
end
function private.GetLink (this: Reference) : Link
	return private.References[this]
end
















-- 
function plugin.Link <t0> (this: canLink|t0, to: Link) : t0
	return private.DoLinkInstance(this, to)
end
--
function plugin.Unlink <t0> (this: canLink|t0) : t0
	return private.DoUnlinkInstance(this)
end
-- 
function plugin.Get (this: canLink) : Link
	return private.GetLink(private.GetRef(this))
end
-- 
function plugin.GetReference (this: canLink) : Reference
	return private.GetRef(this)
end

type Reference = {}
type Link = Instance
type canLink = {}|func|any
type func = (...unknown)->unknown

export type ancestors = self
export type self = typeof(plugin)

return plugin
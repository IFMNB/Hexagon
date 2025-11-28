--!strict

local parent = require('./')
local enum = require('../..')

local private = {}
local plugin = {}



private.links = {} :: {[links]:links}
private.to = parent.SetMode({} :: {[links]: {links}}, 'k')

function private.DoUnsave (self: links)
	private.links[self] = nil
	return self
end

function private.DoSave (self: links)
	assert(private.links[self] == nil, tostring(enum.Error.Forbidden))
	private.links[self]=self
	return self
end



function private.DoCreateLink (self: links)
	private.to[self]=private.to[self] or {}
	return self
end

function private.DoDestroyLink (self: links)
	private.to[self] = if #private.to[self] == 0 then nil else private.to[self]
	return self
end

function private.DoLinkTo (self: links, ...: links)
	private.DoCreateLink(self)
	for i,v in ipairs({...}) do
		assert(not table.find(private.to[self], v), tostring(enum.Error.Forbidden))
		table.insert(private.to[self], v)
	end
	return self
end

function private.DoUnlinkTo (self: links, ...: links)
	for i,v in ipairs({...}) do
		table.remove(private.to[self], assert(table.find(private.to[self], v), tostring(enum.Error.Unknown)))
	end
	private.DoDestroyLink(self)
	return self
end



-- Удаляет элемент из сильного хранилища.
function plugin.Unsave (self: links)
	return private.DoUnsave(self)
end
-- Сохраняет элемент в сильном хранилище, не позволяя __garbageCollector забрать его.
function plugin.Save (self: links)
	return private.DoSave(self)
end
-- Для этого экземпляра, указанные цели будут зависеть от времени жизни этого элемента, если только он сам по себе не жизнеспособен .
function plugin.Link (self: links, ...: links)
	return private.DoLinkTo(self, ...)
end
-- Для этого экземпляра, указанные цели перестанут зависеть от времени жизни этого элемента.
function plugin.Unlink (self: links, ...: links)
	return private.DoUnlinkTo(self, ...)
end


type links = any
export type ancestors = self
export type self = typeof(plugin)

return plugin
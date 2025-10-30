--!strict

local private = {}
local plugin = {}



private.links = {}


function private.DoUnlink (self: links)
	private.links[self] = nil
	return self
end

function private.DoLink (self: links)
	assert(private.links[self] == nil, 'Element already linked')
	private.links[self]=self
	return self
end







-- Удаляет элемент из сильного хранилища.
function plugin.Unlink (self: links)
	return private.DoUnlink(self)
end
-- Сохраняет элемент в сильном хранилище, не позволяя __garbageCollector забрать его.
function plugin.Link (self: links)
	return private.DoLink(self)
end





type links = any
export type ancestors = self
export type self = typeof(plugin)

return plugin
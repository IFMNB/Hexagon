--!strict

local parent = require('./')

local private = {}
local plugin = {}



private.links = {} :: {[links]:links}
private.to = parent.SetMode({} :: {[links]: links}, 'k')

function private.DoUnlink (self: links)
	private.links[self] = nil
	return self
end

function private.DoLink (self: links)
	assert(private.links[self] == nil, 'Element already linked')
	private.links[self]=self
	return self
end

function private.DoLinkTo (self: links, to: links)
	assert(private.to[self] and private.to[self] ~= to or true, 'Element already linked to another element.')
	private.to[self]=to
	return self
end

function private.DoUnlinkTo (self: links)
	private.to[self]=nil
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
-- Связывает 2 элемента так, что первый зависит от второго.
function plugin.LinkTo (self: links, to: links)
	return private.DoLinkTo(self, to)
end
-- Разрывает связь между элементами.
function plugin.UnlinkTo (self: links)
	return private.DoUnlinkTo(self)
end




type links = any
export type ancestors = self
export type self = typeof(plugin)

return plugin
--!strict

local parent = require('./')
local ancestor = require('../')

local enum = require('../../..')

local private = {}
local plugin = {}

private.shadows = ancestor.SetMode({} :: {[any]: shadow}, 'kv')
-- Creates and returns a new shadow for the specified object. Shadows its a private fields that can be accessed only through the specified object. He exists only while the object exists and he is 'strongs'.
function private.DoCreateNewShadow (to: any, inject: shadow?) : shadow
	local shadow : shadow = inject or {}
	private.shadows[to]=shadow
	parent.Link(to, shadow)
	return shadow
end
-- Returns a shadow of the specified object.
function private.DoGetShadow (from: any) : shadow
	return assert(private.shadows[from], tostring(enum.Error.Never))
end




function plugin.New (to: any, inject: shadow?)
	return private.DoCreateNewShadow(to)
end

function plugin.Get (from: any) : shadow
	return private.DoGetShadow(from)
end


type shadow = any
export type ancestors = self
export type self = typeof(plugin)

return plugin
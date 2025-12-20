--!strict

local parent = require('./')

local private = {}
local plugin = {}

private.shadows = setmetatable({}, {__mode = 'kv'}) :: any
-- Creates and returns a new shadow for the specified object. Shadows its a private fields that can be accessed only through the specified object. He exists only while the object exists and he is 'strongs'.
function private.DoCreateNewShadow (to: any, inject: {}?) : any
	local shadow = inject or {}
	private.shadows[to]=shadow
	parent.Link(to, shadow)
	return shadow
end
-- Returns a shadow of the specified object.
function private.DoGetShadow (from: any) : any
	return assert(private.shadows[from], 'Never')
end




function plugin.New (to: any, inject: {}?)
	return private.DoCreateNewShadow(to)
end

function plugin.Get (from: any)
	return private.DoGetShadow(from)
end

plugin.Get = private.DoGetShadow
plugin.New = private.DoCreateNewShadow

table.freeze(private)
table.freeze(plugin)

return plugin
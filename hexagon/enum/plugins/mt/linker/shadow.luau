--!strict

local parent = require('./')
local ancestor = require('../')

local private = {}
local plugin = {}

private.shadows = ancestor.SetMode({} :: {[any]: shadow}, 'kv')

function private.DoCreateNewShadow (to: any, inject: shadow?)
	local shadow : shadow = inject or {}
	private.shadows[to]=shadow
	parent.LinkTo(shadow, to)
	return shadow
end

function private.DoGetShadow (from: any)
	return private.shadows[from]
end




-- 
function plugin.New (to: any, inject: shadow?) : shadow
	return private.DoCreateNewShadow(to)
end

function plugin.Get (from: any) : shadow?
	return private.DoGetShadow(from)
end


type shadow = {[any]:any}
export type ancestors = self
export type self = typeof(plugin)

return plugin
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
	return assert(private.shadows[from], string.format('Shadow is not exists for request %q', tostring(from)))
end




-- Создает новую таблицу "тень", привязанную своим существованием к указанной цели. По сути, приватные поля.
function plugin.New (to: any, inject: shadow?) : shadow
	return private.DoCreateNewShadow(to)
end
-- Получает "тень" для указанного объекта.
function plugin.Get (from: any) : shadow
	return private.DoGetShadow(from)
end


type shadow = any
export type ancestors = self
export type self = typeof(plugin)

return plugin
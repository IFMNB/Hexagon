--!strict

local enum = require('../')

local private = {}
private.modes = {}
private.modes.k = {__mode = 'k', __metatable = private.getError_attemptToReadMetatable}
private.modes.v = {__mode = 'v', __metatable = private.getError_attemptToReadMetatable} 
private.modes.kv = {__mode = 'kv', __metatable = private.getError_attemptToReadMetatable} 
private.modes.s = {__mode = 's', __metatable = private.getError_attemptToReadMetatable}
private.modes.vs = {__mode = 'vs', __metatable = private.getError_attemptToReadMetatable}
private.modes.kvs = {__mode = 'kvs', __metatable = private.getError_attemptToReadMetatable}
private.lockedmeta = {__metatable = private.getError_attemptToReadMetatable}
private.getError_attemptToReadMetatable = enum.Error.Forbidden.Name

-- Sets __mode to the specified value. Used pre-created metatables to set the mode.
function private.setModeMetatable <t0, t1> (self: t0, mode: t1| 'k'|'kv'|'v'|'s'|'vs'|'kvs' )
	return setmetatable(self, private.modes[mode])
	:: setmetatable<t0, {
		__mode: t1,
		__metatable: typeof(private.getError_attemptToReadMetatable)
	}>
end

-- Creates a metatable for the specified object, that links to the specified object. Locked by default.
function private.CreateRelatedMeta <t0> (ToData: t0)
	return {
		__index = ToData,
		__newindex = ToData,
		__call = ToData,
		__metatable = private.getError_attemptToReadMetatable,
	}
end

-- Creates a proxy for the specified object.
function private.DoCreateProxy <t0,t1> (DataToProxy: t0, ProxyOverride: t1?) : t0&t1
	return setmetatable((ProxyOverride or {}) :: t0&t1, private.CreateRelatedMeta(DataToProxy))
end




local public = {}
public.SetMode = private.setModeMetatable
public.CreateMetaTo = private.CreateRelatedMeta
public.DoProxy = private.DoCreateProxy
table.freeze(public)
table.freeze(private)

return public
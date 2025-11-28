--!strict

local private = {}
local public = {}

private.modek = {__mode = 'k'} :: {__mode: 'k'}
private.modev = {__mode = 'v'} :: {__mode: 'v'}
private.modekv = {__mode = 'kv'} :: {__mode: 'kv'}
private.modes = {__mode = 's'} :: {__mode: 's'}
private.modevs = {__mode = 'vs'} :: {__mode: 'vs'}
private.modekvs = {__mode = 'kvs'} :: {__mode: 'kvs'}
--[[

	What is the 's' operator in __mode?
	
	Allows you to compress the table size by reducing the table's hash size. Use with caution, as keys may behave unpredictably during loop iterations.
	
	Why is it possible to use meta keys for __mode out of order?
	
	Because cpp checks for the presence of a key via strchar(), therefore it doesn't care about the order and only needs the presence of the character.
]]

function private.set__modeMt <class, mode> (self: class, mode: mode )
	return setmetatable(self, private[assert('mode'..(mode :: string), 'Injected __mode key is not exists.')]) :: setmetatable<class, {__mode: mode}>
end

function private.getError_attemptToReadMetatable ()
	return error('Attempt to read locked metatable')
end

function private.lock__metatableMt (self: client)
	local mt = getmetatable(self :: any) :: {[string]: any}
	if not mt then
		mt = {} :: {[string]: any}
	end
	
	mt.__metatable = private.getError_attemptToReadMetatable
	return self
end

function private.doSpecifyMetamethods (self: {[any]:any}, to: client)
	self.__index = to  
	self.__newindex = to  
	self.__call = to  
	return self
end

function private.DoCreateProxy (self: {[any]:any}, proxy)
	local mt = private.doSpecifyMetamethods({}, self)
	--mt.__tostring = function ()
	--	return tostring(self)
	--end
	local proxy = setmetatable(proxy or {}, mt)
	return proxy
end


-- Запрещает любые операции с метатаблицей.
function public.LockMeta <clientType> (self: clientType | client)
	return private.lock__metatableMt(self) :: setmetatable<clientType, getmetatable<clientType>&{__metatable: typeof(private.getError_attemptToReadMetatable)}>
end

-- Сокращение для установки __mode метатаблицы
function public.SetMode <class, mode> (self: class, mode: --[[mode | __mode]] __mode)
	return private.set__modeMt(self, mode)
end

-- Делегирует основные метаметоды на цель.
function public.SpecifyTo (self: client, to: client) : {}
	return private.doSpecifyMetamethods(self :: any, to)
end
-- Быстро создаст прокси на указанный объект.
function public.DoProxy <tbl,t0> (self: tbl, proxy: t0?) : tbl&t0
	return private.DoCreateProxy(self, proxy)
end
	
type __mode = 'k'|'kv'|'v'|'s'|'vs'|'kvs'
type client = {}|self
export type ancestors = self
export type self = typeof(public)

return public
--!strict

local private = {}
local public = {}

private.modek = {__mode = 'k'} :: {__mode: 'k'}
private.modev = {__mode = 'v'} :: {__mode: 'v'}
private.modekv = {__mode = 'kv'} :: {__mode: 'kv'}

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
--	self.__add = to  
--	self.__sub = to  
--	self.__mul = to  
--	self.__div = to  
--	self.__mod = to  
--	self.__pow = to  
--	self.__unm = to  
--	self.__concat = to  
--	self.__len = to  
--	self.__eq = to  
--	self.__lt = to  
--	self.__le = to  
	self.__index = to  
	self.__newindex = to  
	self.__call = to  
--	self.__pairs = to  
--	self.__ipairs = to  
	return self
end

function private.DoCreateProxy (self: {[any]:any})
	local proxy = {}
	local mt = {}
	private.doSpecifyMetamethods(mt, self)
	setmetatable(proxy, mt)
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
function public.DoProxy <tbl> (self: tbl) : tbl
	return private.DoCreateProxy(self)
end


type __mode = 'k'|'kv'|'v'
type client = {}|self
export type ancestors = self
export type self = typeof(public)

return public
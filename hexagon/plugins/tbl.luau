--!strict

local private = {}
local public = {}

function private.flipper <k,v> (self: {[k]:v}, clone: boolean, iter: iter)
	local r = clone and {} or self
	for i,v in private.getiter(iter)(self) do
		r[i]=nil
		r[v]=i
	end
	return r
end

function private.recursive (self: {}, iter: recursiveIter, callback: (self: {[any]: any}, gate: any) -> (), name: string?)
	if iter == 'preEnter' then callback(self :: {[any]: any}, name) end
	for i,v in pairs(self :: any) do
		if type(v) == 'table' then
			private.recursive(v, iter, callback, i)
		end
	end
	if iter == 'postEnter' then callback(self :: {[any]: any}, name) end
end

function private.copy <type> (self: type)
	if type(self) ~= 'table' then return self end
	
	local copy = {}
	for i,v in pairs(self :: {[any]: any}) do
		copy[private.copy(i :: any)]=private.copy(v :: any)
	end
	local mt = getmetatable(self)
	if mt then setmetatable(copy, mt) end

	return copy :: type
end

function private.iter_rpairs (state: {any}, control: number) : (number?,any)
	local i = control - 1
	if i >= 1 then
		return i, state[i]
	else
		return nil
	end
end

function private.rpairs (array: {any})
	return private.iter_rpairs, array, #array + 1
end


function private.getiter (iterator: iter) : any
	return iterator == 'ipairs' and ipairs or iterator == 'pairs' and pairs or iterator == 'rpairs' and public.rpairs
end



function private.merge <key1,val1,key2,val2> (self: {[key1]: val1}, with: {[key2]:val2}, iter: iter, clone: boolean)
	local r = clone and {} or self
	for i,v in private.getiter(iter)(with) do
		local typeI, typeV = type(i), type(v)
		
		if typeI == 'number' then
			table.insert(r :: any, v)
		else
			r[i] = v
		end
	end
	
	return r :: typeof(self)&typeof(with)
end

function private.freezer (self: {})
	public.doRecursive(self, 'postEnter', function(self: { [any]: any }, gate) 
		table.freeze(self)
	end)
end



function private.doSearchKeyForTable (self: {[any]: any}, value: any)
	for i,v in pairs(self) do
		if value == v then
			return i
		end
	end
	return nil
end


function private.DoGetKeyParent (self: {[any]:{[any]:any}}, value: any) : {[any]: any}?
	for i,v in pairs(self) do
		if private.doSearchKeyForTable(v, value) then
			return i
		end
	end
	return nil
end


-- Повторяет поведение ipairs, однако выполняемая итерация идет сверху-вниз.
function public.rpairs (array: {any})
	return private.rpairs(array)
end





-- Рекурсивно выполняет для каждого элемента функцию callback. Момент выполнения зависит от точки входа.
function public.doRecursive (self: {}, iter: recursiveIter, callback: (self: {[any]: any}, gate: any)->())
	return private.recursive(self, iter, callback)
end
-- Изменяет оригинальную таблицу, переворачивая ее значения.
function public.doFlip <key, val> (self: {[key]: val}, iter: iter)
	return private.flipper(self, false, iter) :: {[val]: key}
end
-- Соединяет уже существующую таблицу с другой таблицей. 
function public.doMerge <key1,val1,key2,val2> (self: {[key1]: val1}, with: {[key2]:val2}, iter: iter)
	return private.merge(self, with, iter, false)
end
-- Рекурсивно заморозит таблицу.
function public.doFreeze <class> (self: class&{})
	return private.freezer(self) :: class
end



-- Возвращает родительскую таблицу ключа, внутри которой было найдено целевое значение.
function public.getParentOfKey (self: {}, value: any)
	return private.DoGetKeyParent(self :: any, value)
end
-- Возвращает ключ, под которым было найдено целевое значение.
function public.getKey (self: {}, value: any) : any
	return private.doSearchKeyForTable(self :: any, value)
end
-- Возвращает самостоятельную поверхностную версию таблицы, соединенную с другой таблицей.
function public.getMerge <key1,val1,key2,val2> (self: {[key1]: val1}, with: {[key2]:val2}, iter: iter)
	return private.merge(self, with, iter, true)
end
-- Возвращает самостоятельную полную копию таблицы. Метатаблица не копируется, а переиспользуется. 
function public.getCopy <table> (self: table)
	return private.copy(self)
end
-- Создает копию таблицы с перевернутыми значениями.
function public.getFlip <key,val> (self: {[key]: val}, iter: iter)
	return private.flipper(self, true, iter) :: {[val]: key}
end




type recursiveIter = 'preEnter' | 'postEnter'
type iter = 'ipairs'|'pairs'|'rpairs'

export type ancestors = self
export type self = typeof(public)

return public
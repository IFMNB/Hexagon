--!strict

local private = {}
local public = {}

function private.flipper <k,v> (self: tbl<k,v>, clone: boolean, iter: iter)
	local r = clone and {} or self
	for i,v in private.getiter(iter)(self) do
		r[i]=nil
		r[v]=i
	end
	return r
end

function private.recursive (self: {}, iter: recursiveIter, callback: (this: anytbl, gate: any) -> any, name: string?)
	local r
	if iter == 'preEnter' then
		r = callback(self ::anytbl, name)
		if r ~= nil then return r end
	end
	for i,v in pairs(self :: any) do
		if type(v) == 'table' then
			private.recursive(v, iter, callback, i)
		end
	end
	if iter == 'postEnter' then
		r = callback(self :: anytbl, name)
		if r ~= nil then return r end
	end
	
	return nil
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



function private.merge <key1,val1,key2,val2> (self: tbl<key1,val1>, with: tbl<key2,val2>, iter: iter, clone: boolean)
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

function private.freezer (self: empt)
	public.doRecursive(self, 'postEnter', function(self: anytbl, gate) 
		table.freeze(self)
	end)
end



function private.doSearchKeyForTable (self: anytbl, value: any)
	for i,v in pairs(self) do
		if value == v then
			return i
		end
	end
	return nil
end


function private.DoGetKeyParent (self: {[any]: anytbl }, value: any) : any?
	for i,v in pairs(self) do
		if private.doSearchKeyForTable(v, value) then
			return i
		end
	end
	return nil
end


function private.DoSearchAndEnter (self: {anytbl}, tbl2: anytbl) : anytbl?
	for i=1, #self do
		if self[i]==tbl2 then
			return tbl2
		end
	end
	return nil
end

function private.DoRecursiveSearchKey (self: anytbl, key: any)
	return public.doRecursive(self, 'postEnter', function(cur_tbl, cur_tbl_name): any
		return cur_tbl == key and cur_tbl or cur_tbl_name ==key and cur_tbl or cur_tbl[key] or nil
	end)
end
function private.DoRecursiveSearchValue (self: anytbl, value: any)
	return public.doRecursive(self, 'postEnter', function(cur_tbl, cur_tbl_name): any 
		for i,v in pairs(cur_tbl) do
			if v == value then
				return i
			end
		end
		return nil
	end)
end



-- Повторяет поведение ipairs, однако выполняемая итерация идет сверху-вниз.
function public.rpairs (array: {any})
	return private.rpairs(array)
end
-- По принципу table.find ищет значение, но не возвращает индекс, а сразу входит в таблицу если есть.
function public.enter <tbl1, tbl2> (self: tbl1, at: tbl2) : tbl2?
	return private.DoSearchAndEnter(self, at)
end




-- Рекурсивно выполняет для каждого элемента функцию callback. Момент выполнения зависит от точки входа.
function public.doRecursive (self: empt, iter: recursiveIter, callback: (cur_tbl: anytbl, cur_tbl_name: any)->any)
	return private.recursive(self, iter, callback)
end
-- Изменяет оригинальную таблицу, переворачивая ее значения.
function public.doFlip <key, val> (self: tbl<key,val>, iter: iter)
	return private.flipper(self, false, iter) :: {[val]: key}
end
-- Соединяет уже существующую таблицу с другой таблицей. 
function public.doMerge <key1,val1,key2,val2> (self: tbl<key1,val1>, with: tbl<key2,val2>, iter: iter)
	return private.merge(self, with, iter, false)
end
-- Рекурсивно заморозит таблицу.
function public.doFreeze <class> (self: class&empt)
	return private.freezer(self) :: class
end
-- Рекурсивно ищет по таблице указанный индекс-ключ. Вернет значение ключа.
function public.doSearchKey <tbl> (self: tbl, index: any) : any
	return private.DoRecursiveSearchKey(self, index)
end
-- Рекурсивно ищет по таблице указанное индекс-значение. Вернет ключ значения.
function public.doSearchValue <tbl> (self: tbl, index: any) : any
	return private.DoRecursiveSearchValue(self, index)
end


-- Возвращает родителя для пары ключ-значения, если это значение было найдено.
function public.getParentOfKey (self: empt, value: any)
	return private.DoGetKeyParent(self :: any, value)
end
-- Возвращает ключ, под которым было найдено целевое значение.
function public.getKey (self: empt, value: any) : any
	return private.doSearchKeyForTable(self :: any, value)
end
-- Возвращает самостоятельную поверхностную версию таблицы, соединенную с другой таблицей.
function public.getMerge <key1,val1,key2,val2> (self: tbl<key1,val1>, with: tbl<key2,val2>, iter: iter)
	return private.merge(self, with, iter, true)
end
-- Возвращает самостоятельную полную копию таблицы. Метатаблица не копируется, а переиспользуется. 
function public.getCopy <table> (self: table)
	return private.copy(self)
end
-- Создает копию таблицы с перевернутыми значениями.
function public.getFlip <key,val> (self: tbl<key,val>, iter: iter)
	return private.flipper(self, true, iter) :: {[val]: key}
end

type empt = {}
type tbl<k,v> = {[k]:v}
type anytbl = {[any]:any}
type recursiveIter = 'preEnter' | 'postEnter'
type iter = 'ipairs'|'pairs'|'rpairs'

export type ancestors = self
export type self = typeof(public)

return public
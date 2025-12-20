--!strict

local parent = require('./')
local enum = require('../..')

local private = {}
local public = {}

private.currentiter = {} --parent.SetMode({} :: {[class]: {[class]: any}}, 'k')
private.metastore = parent.SetMode({} :: {[class]: typeof(parent.SetMode({} :: {class}, 'v'))}, 'k')
private.cache = parent.SetMode({} :: {[class]: typeof(parent.SetMode({} :: {[any]: any}, 'kv'))}, 'k')

function private.getMEList (self: any)
	local list = private.metastore[self]
	return list
end

function private.setToChecked (self: class, the: class)
	private.currentiter[self][the]=the
	return self
end

function private.createChecked (self: class)
	private.currentiter[self]={}
	return self
end

function private.destroyChecked (self: class)
	private.currentiter[self]=nil
	return self	
end

function private.checkIsItChecked (self: class, the: class) : boolean
	return not not private.currentiter[self][the]
end

function private.checkIsItOnline (self: class) : boolean
	return not not private.currentiter[self]
end


function private.CreateCache (at: any)
	private.cache[at]=parent.SetMode({}, 'kv')
end
function private.CacheData (at: any, i: any, to: any)
	private.cache[at][i]=to
end
function private.ReturnCache (at: any, i:any)
	return private.cache[at][i]
end
function private.IsCached (at: any) : boolean
	return not not private.cache[at]
end


















@native
function private.multipleExpandsIterator <t0, t1> (self: {[any]:any} & t0, i: any & t1) : index<t0,t1>?
	local list : any = private.getMEList(self)
	assert(list :: {}, tostring(enum.Error.Reset))
	
	local cache = private.IsCached(self) and private.ReturnCache(self, i)
	if cache then
		--print(tostring(enum.State.Live), i, cache, self)
		return cache
		
		--[[
		
		Whenever you create public functions, you must check whether their names match those of any other function in the public namespace.
		This is because caching stores data based on the access key, and only for functions.
		The current cache compares the search results with what was previously found for a particular instance.
		This reduces the chance of finding matches, but it's still worth keeping in mind.
		
		]]
	end
	
	private.createChecked(self)
	private.setToChecked(self, self)
	
	for inum=1, #list do
		local tbl = list[inum] assert(list[inum], string.format('%s, %q, %q', tostring(enum.Error.Reset), tostring(i), tostring(self)))
		local v = tbl[i]
		
		if private.checkIsItOnline(tbl) then continue end
		if private.checkIsItChecked(self, tbl) then continue end
		
		if v ~= nil then
			private.destroyChecked(self)
			if type(v) == 'function' then
				if not private.IsCached(self) then
					private.CreateCache(self)
				end
				private.CacheData(self, i, v)
			end
			
			--warn(tostring(enum.State.Run), i)
			return v
		end
		
		private.setToChecked(self, tbl)
	end
	
	private.destroyChecked(self)
	--warn(tostring(enum.Error.Never), i, self, list)
	return nil
end

-- DONT MOVE THIS TABLE UPSIDE private.multipleExpandsIterator, IT WILL BREAK!
private.meta = {
	__index = private.multipleExpandsIterator,
	__metatable = tostring(enum.Error.Forbidden)
}

function private.createDataMulti (self: class, data: {class})
	private.metastore[self]=parent.SetMode(data, 'v')
	return self
end

function private.insertDataToMulti (self: class, data: {class})
	for i=1, #data do
		table.insert(private.metastore[self], data[i])
	end
	return self
end

-- Multipolar inheritance. The first class will inherit the fields of the other classes in turn. The first result found is used.
function private.expandsRootPoint <data> (self: data, ...: class) : data
	debug.profilebegin(script.Name..'.ExpandRootPoint')
	assert(type(self)=='table', tostring(enum.Error.Forbidden))

	if private.getMEList(self) then
		private.insertDataToMulti(self, {...})
	else
		setmetatable(private.createDataMulti(self, {...}), private.meta)
	end
	
	debug.profileend()
	return self
end






public.Expanding = private.expandsRootPoint

type class = {}

return public
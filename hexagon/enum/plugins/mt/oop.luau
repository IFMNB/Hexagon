--!strict

-- Плагин реализует наследование.

local parent = require('./')

local private = {}
local public = {}

private.currentiter = {} --parent.SetMode({} :: {[class]: {[class]: any}}, 'k')
private.metastore = parent.SetMode({} :: {[class]: typeof(parent.SetMode({} :: {class}, 'v'))}, 'k')

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

function private.multipleExpandsIterator (self: {[any]:any}, i: any) : any?
	local list : any = private.getMEList(self)
	assert(list :: {}, 'Error related to garbageCollector.')
	
	
	private.createChecked(self)
	private.setToChecked(self, self)
	
	-- I don't know why some data gets lost and some gets found. If you need help, look up the manual workflow.
	
	--print('list counter ', #list)
	--print('list is a ', list)
	
	for inum=1, #list do
		local tbl = list[inum]
		local v = tbl[i]
		
		--print('iterate table by inum ', inum, ' - ', tbl)
		--print('get value by index ', v)
		
		if private.checkIsItOnline(tbl) then continue end
		if private.checkIsItChecked(self, tbl) then continue end
		if v ~= nil then private.destroyChecked(self) return v end
		private.setToChecked(self, tbl)
	end
	
	private.destroyChecked(self)
	--warn('fail to catch index', i, self)
	return nil
end

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


function private.expandsRootPoint <data> (self: data, ...: class)
	debug.profilebegin(script.Name..'.ExpandRootPoint')

	if private.getMEList(self) then
		private.insertDataToMulti(self, {...})
	else
		setmetatable(private.createDataMulti(self, {...}), private.meta)
	end
	
	debug.profileend()
	return self
end


function private.DoSelfEmbedWithClass <data> (self: data, class: class)
	private.expandsRootPoint(self, class)
	private.expandsRootPoint(class, self)
	return self
end


-- Мультиполярное наследование. Первый класс будет наследовать поля других классов по очереди. Используется первый найденный результат.
function public.Expanding <data> (self: data | self, ...: class) : data
	return private.expandsRootPoint(self, ...)
end
-- Встраиват классы друг в другая, делая функционал каждого доступным для обоих.
@deprecated
function public.Embed <data> (self: data | self, class: class) : data
	return private.DoSelfEmbedWithClass(self, class)
end

private.meta = {__index = private.multipleExpandsIterator}

type class = {}
export type ancestors = self & parent.ancestors
export type self = typeof(public)
public:Expanding(parent)
return public
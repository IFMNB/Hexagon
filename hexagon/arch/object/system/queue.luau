--!strict

local main = require('../')

local plugin = main.GetPluginProvider()
local shd = plugin.GetShadow()
local obj = main.GetObject()

local private = {}
local public = {}
local class = {}
local root = {}

private.QueueClassName = 'Queue' :: 'Queue'

function private.GetCount (self: Queue)
	return #self:Get()
end

function private.DoCreateNewQueue ()
	local queue = {}
	
	local mt = {}
	mt.__index = public
	mt.__len = private.GetCount
	setmetatable(queue,mt)
	
	local object = obj.New(queue :: public, private.QueueClassName)
	local shade = shd.New(object)
	shade._fifo = {}
	
	return object
end

function private.GetQueue (self: Queue)
	return shd.Get(self)._fifo
end


function private.DoPullFrom (self: Queue)
	local queue = private.GetQueue(self)
	local value = queue[1]
	table.remove(queue, 1)
	return value
end

function private.DoPushTo (self: Queue, value: queued)
	local queue = private.GetQueue(self)
	table.insert(queue, value)
	return self
end







-- Вытащить первый элемент из очереди.
function public:Pull ()
	return private.DoPullFrom(self)
end
-- Добавить элемент в конец очереди.
function public:Push (value: queued)
	return private.DoPushTo(self, value)
end
-- Получить элементы очереди.
function public:Get () : {queued}
	return private.GetQueue(self)
end



-- Создает новый экземпляр Queue. Используется для сохранения данных по принципу FIFO.
function class.New () : Queue
	return private.DoCreateNewQueue()
end

type queued = any
export type Queue = typeof(private.DoCreateNewQueue())

export type public = typeof(public)
export type root = typeof(root)
export type self = typeof(class)

-- Используется для листинга по принципу FIFO.
function root.GetQueue () return class end
setmetatable(root,{__index=main})
return root
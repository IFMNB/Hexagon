--!strict

local parent = require('./')
local ancestors = parent :: parent.ancestors

local plugin = ancestors.GetPluginProvider()

local oop = plugin.GetOOP()
local obj = ancestors.GetObject()

local private = {}
local public = {}
local class = {}
local root = {}

private.QueueClassName = 'Queue' :: 'Queue'



function private.GetCount (self: _queue)
	return #self._fifo
end

function private.DoCreateNewQueue () : Queue
	local queue = {} :: _queue
	
	queue._fifo = {}
	
	oop.Expanding(queue, public)
	local mt = getmetatable(queue)
	mt.__len = private.GetCount
	
	local object = obj.New(queue, private.QueueClassName)
	
	return object
end

function private.GetQueue (self: _queue)
	return self._fifo
end


function private.DoPullFrom (self: _queue)
	local queue = private.GetQueue(self)
	local value = queue[1]
	table.remove(queue, 1)
	return value
end

function private.DoPushTo (self: _queue, value: queued)
	local queue = private.GetQueue(self)
	table.insert(queue, value)
	return self
end







-- Вытащить первый элемент из очереди.
function public.Pull (self: Queue)
	return private.DoPullFrom(self :: _queue)
end
-- Добавить элемент в конец очереди.
function public.Push (self: Queue, value: queued)
	return private.DoPushTo(self :: _queue, value)
end



-- Создает новый экземпляр Queue. Используется для сохранения данных по принципу FIFO.
function class.New () : Queue
	return private.DoCreateNewQueue()
end

type queued = any

type _queue = Queue & {
	_fifo: {queued}
}
export type Queue = typeof(obj.New({} :: public, private.QueueClassName))

export type public = typeof(public)
export type ancestors = root & parent.root
export type root = typeof(root)
export type self = typeof(class)

-- Используется для листинга по принципу FIFO.
function root.GetQueue () return class end
oop.Expanding(root, ancestors)
return root
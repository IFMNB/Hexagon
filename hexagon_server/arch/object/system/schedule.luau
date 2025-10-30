--!strict


local parent = require('./')
local ancestors = parent :: parent.ancestors

local plugins = ancestors.GetPluginProvider()
local oop = plugins.GetOOP()
local imp = plugins.GetImported()
local tbl = plugins.GetTable()




local obj = ancestors.GetArchProvider().GetObject()

local private = {}
local protected = {}
local public = {}
local class = {}
local root = {}



private.ScheduleClassName = 'Schedule' :: 'Schedule'



function private.GetTasks (self: _schedule)
	return self._schedule
end

function private.GetHandlerFrom (self: _schedule)
	return self._Handler
end

function private.DoSetHandler (self: _schedule, Handler: Handler)
	self._Handler = Handler
	return self
end

function private.DoSetWaitTime (self: _schedule, time: number)
	self._time = time
	return self
end

function private.GetWaitTime (self: _schedule)
	return self._time
end




-- Установит обработчик ошибок. 
function protected.SetHandler (self: ScheduleProtected, Handler: Handler) : ScheduleProtected
	return private.DoSetHandler(self :: _schedule,Handler) :: ScheduleProtected
end
-- Получить обработчик ошибок.
function protected.GetHandler (self: ScheduleProtected) : Handler?
	return private.GetHandlerFrom(self :: _schedule)
end
-- Установит время ожидания перед переходом на следующую задачу.
function protected.SetWait (self: ScheduleProtected, time: number) : ScheduleProtected
	return private.DoSetWaitTime(self :: _schedule, time) :: ScheduleProtected
end
-- Вернет время, которое ожидает расписание перед переходом на следующую задачу. 
function protected.GetWait (self: Schedule) : number
	return private.GetWaitTime(self :: _schedule)
end




function private.DoSetTaskTo (self: _schedule, func: func, arg: {any})
	local tasks = private.GetTasks(self)
	table.insert(tasks, {f = func, a = arg})
	return self
end

function private.DoRemoveTaskFrom (self: _schedule, func: func)
	local tasks = private.GetTasks(self)
	local num : number = tbl.getParentOfKey(tasks, func)
	table.remove(tasks, num)
	return self
end

function private.DoWork (self: _schedule)
	local tasks = private.GetTasks(self)
	local _i=0
	
	xpcall(function ()
		for i=1, #tasks do
			_i=i
			local tsk = tasks[i]
			tsk.f(unpack(tsk.a))
			
		end
	end, function(message: string)
		local tsk = tasks[_i]
		if self._Handler then
			return self._Handler(tsk.f, tsk.a, message)
		else
			warn(string.format('error in %q, i = %s, message is %q', tostring(tsk.f), tostring(_i), message))
		end
	end)
	
	
	return self
end

function private.DoWorkAsync (self: _schedule)
	task.spawn(private.DoWork,self)
	return self
end

function private.DoLoop (self: _schedule)
	local cor = coroutine.create(function()
		while true do
			self:Do()
			if self._time == 0 then continue end
			task.wait(self._time)
		end
	end)
	
	coroutine.resume(cor)
	
	return cor
end






















function public.RemoveTask (self: Schedule, func: func) : Schedule
	return private.DoRemoveTaskFrom(self :: _schedule, func)
end

function public.SetTask (self: Schedule, func: func, ...: any) : Schedule
	return private.DoSetTaskTo(self :: _schedule, func, {...})
end
-- Выполнит цикл работы расписания.
function public.Do (self: Schedule) : Schedule
	return private.DoWork(self :: _schedule)
end
-- Выполнит цикл работы расписания асинхронно.
function public.DoAsync (self: Schedule) : Schedule
	return private.DoWorkAsync(self :: _schedule)
end
-- Будет выполнять цикл работы расписания постоянно в асинхронном режиме. Сразу возвращает коррутину.
function public.Loop (self: Schedule) : thread
	return private.DoLoop(self :: _schedule)
end











function private.GetCount (self: _schedule)
	local sch = self._schedule
	return #sch
end

function private.DoNewScheduleClass () : Schedule
	local Schedule = {} :: _schedule

	Schedule._schedule = {}
	Schedule._time = 0

	oop.Expanding(Schedule, public)
	local mt = getmetatable(Schedule)
	mt.__len = private.GetCount

	return obj.New(Schedule, private.ScheduleClassName)
end


-- Класс безопасно выполняет 1 задачу параллельно с основным потоком каждый Heartbeat.
function class.New () : Schedule
	return private.DoNewScheduleClass()
end

type func = (...any)->true
--[[
type error_msg = string
type Handler = (self: task, option: error_msg)->()
]]
type tasks = {{f: func, a: {any}}}
type Handler = (self: func, arg: {any}, message: string)->()

type _schedule = Schedule & {
	_schedule: tasks,
	_time: number,
	_Handler: Handler?
}

export type ScheduleProtected = Schedule & protected
export type Schedule = typeof(obj.New({} :: public, private.ScheduleClassName))

type protected = typeof(protected)
export type public = typeof(public)
export type ancestors = root & parent.ancestors
export type root = typeof(root)
export type self = typeof(class)

-- Используется как планировщик задач.
function root.GetSchedule () return class end
oop.Expanding(root, parent)
oop.Expanding(public, protected)
return root
--!strict


local parent = require('../')
local ancestors = parent :: parent.hierarchy_server_start

local plugins = ancestors.GetPluginProvider()
local oop = plugins.GetOOP()
local link = plugins.GetLinker()

local arch = ancestors.GetArchProvider()
local obj = arch.GetObject()
local watch = arch.GetSystem().GetWatcher().GetWatch()

local private = {}
local public = {}	
local class = {}
local root = {}

private.ClassName = 'Timer' :: 'Timer'
private.obj = plugins.GetMeta().SetMode({} :: {[Timer]: _timer}, 'v')


function private.DoCreateNewTimer (self: time)
	local this = {} :: this
	this.second = 0
	this.time = self
	
	local timer = {} :: _timer
	timer._watch = watch.NewWatcher(this)
	timer._coroutine = private.DoCreateTimerCoroutine(timer)
	timer._yield = true
	
	
	link.LinkTo(this, timer)
	oop.Expanding(timer, public)
	local object = obj.New(timer, private.ClassName)
	
	return object
end

function private.GetParams (self: _timer)
	return watch.GetWatherParams(private.GetWatch(self))
end

function private.GetWatch (self: _timer)
	return self._watch
end

function private.DoCallback (self: time, new: time, func: func)
	if self == new then func() return true else return false end
end

function private.DoWatchAtTime (self: _timer, time: time, func: func)
	local params = private.GetParams(self)
	return params:Connect(function(self: {  } | { [any]: any }, index, newindex, oldindex) 
		private.DoCallback(time, newindex, func)
	end)
end

function private.DoOnceAtTime (self: _timer, time: time, func: func)
	local params = private.GetParams(self)
	local link : WatcherLink
	link = params:Connect(function(self: {  } | { [any]: any }, index, newindex, oldindex) 
		if private.DoCallback(time, newindex, func) then
			link:Disconnect()
		end
	end)
	return link
end

function private.DoCreateTimerCoroutine (self: _timer)
	return coroutine.create(function(...)
		while task.wait(1) do
			if self._yield then coroutine.yield() end
			if self._watch.second == self._watch.time then private.DoWaitCoroutine(self) end
			self._watch.second = math.clamp(self._watch.second+1, 0, self._watch.time)
		end	
	end)
end

function private.DoContinueCoroutine (self: _timer)
	assert(private.DoCheckCurrentStateTimer(self), 'Timer cannot run.')
	self._yield = false
	coroutine.resume(self._coroutine)
	return self
end

function private.DoCheckCurrentStateTimer (self: _timer)
	return self._watch.second ~= self._watch.time
end

function private.DoWaitCoroutine (self: _timer)
	self._yield = true
	return self
end





function private.GetTimerTime (self: _timer)
	return self._watch.time
end

function private.GetTimerCurrentTime (self: _timer)
	return self._watch.second
end

function private.DoCheckIsCorroutineYield (self: _timer)
	return self._yield
end



function private.DoResetTimer (self: _timer)
	self._watch.second = 0
	return self
end





-- Прослушивать наступление определенного секундного момента в таймере
function public.WatchAt (self: Timer, time: time, func: func) : WatcherLink
	return private.DoWatchAtTime(self :: _timer, time, func)
end
-- Единожды подключиться к наступлению определенного секундного момента в таймере
function public.OnceAt (self: Timer, time: time, func: func) : WatcherLink
	return private.DoOnceAtTime(self :: _timer, time, func)
end
-- Остановит выполнение таймера
function public.Pause (self: Timer) : Timer
	return private.DoWaitCoroutine(self :: _timer)
end
-- Продолжит выполнение таймера
function public.Start (self: Timer) : Timer
	return private.DoContinueCoroutine(self :: _timer)
end
-- Вернет текущее время таймера
function public.GetCurrent (self: Timer) : time
	return private.GetTimerCurrentTime(self :: _timer)
end
-- Сбросит таймер до начала.
function public.Reset (self: Timer) : Timer
	return private.DoResetTimer(self :: _timer)
end
-- Вернет время, к которому привязан этот таймер.
function public.GetTime (self: Timer) : time
	return private.GetTimerTime(self :: _timer)
end
-- Ждет ли таймер?
function public.IsYield (self: Timer) : boolean
	return private.DoCheckIsCorroutineYield(self :: _timer)
end



-- Вернет новый класс-таймер, использующийся для реактивного выполнения определенных действий в указанный период времени. Чаше всего полезен при кастах и т.д
function class.New (self: time) : Timer
	return private.DoCreateNewTimer(self)
end


type time = number
type func = ()->()




type this = {
	time: number,
	second: number
}

type _timer = {
	_watch: typeof(watch.NewWatcher({}::this)),
	_coroutine: thread,
	_yield: boolean
} & Timer
export type Timer = typeof(obj.New({} :: public, private.ClassName)) 
type WatcherLink = typeof(watch.GetWatherParams(watch.NewWatcher({})):Connect({}::any))

type public = typeof(public)
export type ancestors = root & parent.hierarchy_server_start
export type root = typeof(root)
export type self = typeof(class)

-- Класс для реакции на прошедшее время. Депрекейнут, потому что watcher был депрекейнут.
@deprecated
function root.GetTimer () return class end
oop.Expanding(root, parent)
return root
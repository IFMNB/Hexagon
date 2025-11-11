--!strict

local parent = require('./')
local ancestors = parent :: parent.ancestors

local plugin = ancestors.GetPluginProvider()
local arch = ancestors.GetArchProvider()

local oop = plugin.GetOOP()
local ent = parent.GetClass()
local link = plugin.GetLinker()

local private = {}
local public = {}
local class = {}
local root = {}


function private.DoCreateCoroutine (self: _tc)
	return coroutine.create(function() 
		while task.wait(1) do
			if self._state == 'paused' then coroutine.yield() end
			local this = self._time.time + 1
			if this >= self._time._max then
				self:Pause()
			else
				self._time.time = this
			end
		end
	end)
end

function private.DoCreateNewTimecast (time: number)
	local tc = {} :: _tc
	local tm = {}
	link.LinkTo(tm, tc)
	
	tc._state = 'paused'
	tc._time = tm :: any
	tc._time._max = time
	tc._time.time = 0
	tc._coroutine = private.DoCreateCoroutine(tc)
	
	local entity = ent.NewEmulate(tc, '_time')
	
	return entity
end


function private.DoResumeCoroutine (self: _tc)
	self._state = 'run'
	coroutine.resume(self._coroutine)
	return self
end

function private.DoPauseCoroutine (self: _tc)
	self._state = 'paused'
	return self
end

function private.DoResetTimer (self: _tc)
	self._time.time = 0
	return self
end







function public.Reset (self: Timecast) : Timecast
	return private.DoResetTimer(self :: _tc)
end

function public.Pause (self: Timecast) : Timecast
	return private.DoPauseCoroutine(self :: _tc)
end

function public.Resume (self: Timecast) : Timecast
	return private.DoResumeCoroutine(self :: _tc)
end




function class.New (time: number) : Timecast
	return private.DoCreateNewTimecast(time)
end


type _time = {
	time: number,
	_max: number,
}
type _tc = Timecast & {
	_time: _time,
	_state: 'paused'|'run',
	_coroutine: thread
}
export type Timecast = typeof(ent.New({} :: public))

export type public = typeof(public)
export type ancestors = root & parent.ancestors
export type self = typeof(class)
export type root = typeof(root)

function root.GetClass () return class end
oop.Expanding(root, ancestors)
return root
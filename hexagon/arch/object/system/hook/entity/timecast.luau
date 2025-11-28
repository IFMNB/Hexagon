--!strict

local parent = require('./')
local ancestors = parent :: parent.ancestors

local plugin = ancestors.GetPluginProvider()

local enum = ancestors.Enum()
local oop = plugin.GetOOP()
local ent = parent.GetClass()
local lnk = plugin.GetLinker()
local shd = plugin.GetShadow()

local private = {}
local public = {}
local class = {}
local root = {}


function private.DoCreateCoroutine ()
	return coroutine.create(function(self: _tc) 
		local shadow : _shadow = shd.Get(self)
		while task.wait(1) do
			if shadow._state == enum.State.Pause then coroutine.yield() end
			local this = self.time + 1
			self.time = this
			if this >= shadow._max then
				self:Pause()
			end
		end
	end)
end

function private.DoCreateNewTimecast (time: number)
	local tc = oop.Expanding({time = 0}, public) :: _tc
	local entity = ent.New(tc)
	
	local shadow : _shadow = shd.New(entity)
	shadow._state = enum.State.Pause
	shadow._coroutine = private.DoCreateCoroutine()
	shadow._max = time
	
	--lnk.LinkTo(tc, entity)
	
	return entity
end


function private.DoResumeCoroutine (self: _tc)
	local shadow : _shadow = shd.Get(self)
	shadow._state = enum.State.Run
	warn('play', coroutine.status(shadow._coroutine))
	coroutine.resume(shadow._coroutine, self)
	warn('play', coroutine.status(shadow._coroutine))
	return self
end

function private.DoPauseCoroutine (self: _tc)
	local shadow : _shadow = shd.Get(self)
	shadow._state = enum.State.Pause
	return self
end

function private.DoResetTimer (self: _tc)
	self.time = 0
	return self
end







function public:Reset () : Timecast
	return private.DoResetTimer(self :: _tc)
end

function public:Pause () : Timecast
	return private.DoPauseCoroutine(self :: _tc)
end

function public:Play () : Timecast
	return private.DoResumeCoroutine(self :: _tc)
end




function class.New (time: number) : Timecast
	return private.DoCreateNewTimecast(time)
end


type _states = typeof(enum.State.Run) | typeof(enum.State.Pause)
type _shadow = {
	_max: number,
	_state: _states,
	_coroutine: thread
}
type _tc = Timecast & {time: number}
export type Timecast = typeof(ent.New({} :: public))

export type public = typeof(public)
export type ancestors = root & parent.ancestors
export type self = typeof(class)
export type root = typeof(root)

function root.GetClass () return class end
oop.Expanding(root, ancestors)
return root
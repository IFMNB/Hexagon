--!strict

local RunService = game:GetService('RunService')
local parent = require('./')
local ancestors = parent :: parent.ancestors
local object = ancestors.GetObject()
local provider = ancestors.GetPluginProvider()
local oop = provider.GetOOP()
local import = provider.GetImported()

local private = {}
local public = {}
local class = {}
local root = {}

private.classname = 'Swipe' :: 'Swipe'
private.iterators = {
	linear = function (self: _client, at: parameter, to: value, lerp: _lerp_F, alpha: number) : value 
		return lerp(self[at], to, alpha)
	end,
}




function private.newSwiperClass ()
	local self = {} :: _Swipe
	
	warn(tostring(self))
	
	self._time = 1
	self._type = 'linear'
	
	oop.Expanding(self, public)
	local obj = object.New(self, private.classname)

	
	return obj
end

function private.setTimeToWait (self: _Swipe, time: number)
	self._time = time
	return self
end

function private.getTimeToWait (self: _Swipe)
	return self._time
end

function private.getLerpFunc (self: value) : _lerp_F
	if type(self) == 'number' then
		return math.lerp
	else
		return (self :: any)['Lerp'] or (self :: any)['lerp'] or nil :: any
	end
end

function private.getValueFromTarget (self: _client, at: parameter)
	local raw = import.switch(type(self[at]), {
		default = function () return error('unsupported value type') end,
		number = self[at],
		Vector3 = self[at],
		CFrame = self[at],
		Vector2 = self[at]
	})
	
	assert(raw ~= nil, 'unsupported type')
	
	return raw
end


function private.getIterator (self: _Swipe)
	return import.switch(self._type, private.iterators)
end

function private.CreateCyclePackage (self: _Swipe, target: _client, at: parameter)
	local value = private.getValueFromTarget(target, at)
	return {
		timer = private.getTimeToWait(self)/250,
		alpha = 0,
		lerp = private.getLerpFunc(value),
		start = value,
		target = target,
		at = at
	} :: SwipePackage
end

function private.doSwipeCycle (self: SwipePackage, iter: iter, to: value)
	local alpha = 0
	local start = tick()
	local run : RBXScriptConnection
	
	local function OnOnce (deltaTime: number)
		if alpha >= 1 then self.target[self.at] = to; run:Disconnect() return end

		--self.target[self.at] = self.lerp(self.start, to, self.alpha)
		self.target[self.at] = iter(self.target, self.at, to, self.lerp, alpha)
		alpha += math.clamp((tick() - start)/self.timer, 0, 1)
		
		print(self, self.target[self.at])
	
	end
	
	run = RunService.Heartbeat:Connect(OnOnce)
end



function private.getSmoothRoot (self: _Swipe, target: _client, at: parameter, to: value)
	local package = private.CreateCyclePackage(self, target, at)
	private.doSwipeCycle(package, private.getIterator(self), to)
	
	return self
end

function private.getSmoothRootAsync (self: _Swipe, target: _client, at: parameter, to: value)
	task.spawn(function () return private.getSmoothRoot(self, target, at, to) end)
	return self
end


function private.DoSetIteratorType (self: _Swipe, type: iterators)
	self._type = type
	return self
end

function private.DoGetIteratorType (self: _Swipe)
	return self._type
end





function public.SetTime (self: Swipe, time: number)
	return private.setTimeToWait(self :: _Swipe, time) :: Swipe
end

function public.GetTime (self: Swipe) : number
	return private.getTimeToWait(self :: _Swipe)
end

function public.DoSwipe (self: Swipe, target: client, at: parameter, to: value)
	return private.getSmoothRoot(self :: _Swipe, target, at, to) :: Swipe
end

function public.DoSwipeAsync (self: Swipe, target: client, at: parameter, to: value)
	return private.getSmoothRootAsync(self :: _Swipe, target, at, to) :: Swipe
end

function public.SetType (self: Swipe, type: iterators)
	return private.DoSetIteratorType(self :: _Swipe, type) :: Swipe
end

function public.GetType (self: Swipe)
	return private.DoGetIteratorType(self :: _Swipe)
end



-- INDEV-API
function class.NewSwipe () : Swipe
	return private.newSwiperClass()
end



type parameter = any
type value = number | CFrame | Vector3 | Vector2
type _client = {}|{[any]:any}
type client = {}|self|{[any]:any}|Instance
type _lerp_F = (self: any, target: any, alpha: number)->any

type SwipePackage = {
	timer: number,
	lerp: _lerp_F,
	start: value,
	target: _client,
	at: parameter
}


type iterators = keyof<typeof(private.iterators)>
type iter = (self: _client, at: parameter, to: value, lerp: _lerp_F, alpha: number) -> value

type _Swipe = Swipe & {
	_time: number,
	_type: iterators
} 

export type Swipe = typeof(object.New({} :: public, private.classname))

export type public = typeof(public)


export type ancestors = root & parent.ancestors
export type self = typeof(class)
export type root = typeof(root)

-- Используется для реализации интерполяции от одного значения к другому. Эмулирует работу TweenService.
function root.GetSwipe () return class end
oop.Expanding(root, ancestors)
return root
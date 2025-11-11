--!strict

local RunService = game:GetService('RunService')
local parent = require('../')
local ancestors = parent :: parent.ancestors
local object = ancestors.GetObject()
local provider = ancestors.GetPluginProvider()
local oop = provider.GetOOP()
local import = provider.GetImported()
local mt = provider.GetMeta()

local private = {}
local public = {}
local class = {}
local root = {}

private.classname = 'Swipe' :: 'Swipe'
private.current = mt.SetMode({} :: {[client]: RBXScriptConnection|'init'}, 'k')
private.iterators = {
	linear = function (self: _client, at: parameter, to: value, lerp: _lerp_F, alpha: number) : value 
		return lerp(self[at], to, alpha)
	end,
	quadric = function (self: _client, at: parameter, to: value, lerp: _lerp_F, alpha: number) : value 
		return lerp(self[at], to, alpha^2)
	end,
	easingOut = function (self: _client, at: parameter, to: value, lerp: _lerp_F, alpha: number) : value 
		return lerp(self[at], to, (1-alpha)^2)
	end,
	easingInOut = function (self: _client, at: parameter, to: value, lerp: _lerp_F, alpha: number) : value 
		alpha = alpha < 0.5 and 2 * alpha^2 or 1 - (-2 * alpha + 2)^2 / 2
		return lerp(self[at], to, alpha)
	end
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
		timer = private.getTimeToWait(self),
		alpha = 0,
		lerp = private.getLerpFunc(value),
		start = value,
		target = target,
		at = at
	} :: SwipePackage
end

function private.GetConnectionByClient (self: client)
	return private.current[self]
end

function private.SetConnectionToClient (self: client, rbxsc: RBXScriptConnection)
	private.current[self] =rbxsc
	return self
end

function private.InitConClient (self: client)
	private.current[self]='init'
	return self
end

function private.doSwipeCycle (self: SwipePackage, iter: iter, to: value)
	local alpha = 0
	local start = tick()
	local run : RBXScriptConnection
	
	local function OnOnce (deltaTime: number)
		if not private.GetConnectionByClient(self.target) then run:Disconnect() end
		if alpha >= 1 then self.target[self.at] = to; run:Disconnect() return end
		self.target[self.at] = iter(self.target, self.at, to, self.lerp, alpha)
		alpha = math.clamp((tick() - start)/self.timer, 0, 1)
	end
	
	private.InitConClient(self.target)
	run = RunService.Heartbeat:Connect(OnOnce)
	private.SetConnectionToClient(self.target,run)
end

function private.DoCancelSwipeCycle (self: client)
	local con = private.GetConnectionByClient(self)
	if con == 'init' then task.wait()
		return private.DoCancelSwipeCycle(self)
	elseif con == nil then
		return false
	end
	con:Disconnect()
	return true
end


function private.getSmoothRoot (self: _Swipe, target: _client, at: parameter, to: value)
	private.DoCancelSwipeCycle(target)
	local package = private.CreateCyclePackage(self, target, at)
	private.doSwipeCycle(package, private.getIterator(self), to)
	
	return self
end


function private.DoSetIteratorType (self: _Swipe, type: iterators)
	self._type = type
	return self
end

function private.DoGetIteratorType (self: _Swipe)
	return self._type
end




-- Установит время выполнения анимации.
function public.SetTime (self: Swipe, time: number) : Swipe
	return private.setTimeToWait(self :: _Swipe, time)
end
-- Получить время анимации.
function public.GetTime (self: Swipe) : number
	return private.getTimeToWait(self :: _Swipe)
end
-- Начать проигрывание анимации у конкретного объекта.
function public.Play (self: Swipe, target: client, at: parameter, to: value) : Swipe
	return private.getSmoothRoot(self :: _Swipe, target, at, to)
end
-- Остановить проигрывание анимации у конкретного объекта
function public.Stop (self: Swipe, target: client) : boolean
	return private.DoCancelSwipeCycle(target)
end
-- Установить тип интерполяции.
function public.SetInter (self: Swipe, type: iterators) : Swipe
	return private.DoSetIteratorType(self :: _Swipe, type)
end
-- Получить тип интерполяции.
function public.GetInter (self: Swipe) : iterators
	return private.DoGetIteratorType(self :: _Swipe)
end



-- Создает класс с параметрами для анимации.
function class.New () : Swipe
	return private.newSwiperClass()
end



type parameter = any
type value = number | CFrame | Vector3 | Vector2
type _client = {}|{[any]:any}
type client = {}|{[any]:any} -- use RobloxLink class to swipe Instance classes
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

-- Используется как альтернатива TweenService.
function root.GetSwipe () return class end
oop.Expanding(root, ancestors)
return root 
--!strict

local parent = require('../')
local ancestors = parent :: parent.ancestors
local provider = ancestors.GetPluginProvider()
local oop = provider.GetOOP()
local object = ancestors.GetObject()

local private = {}
local public = {}
local class = {}
local root = {}

private.classname = 'RaycastSolid' :: 'RaycastSolid'
private.meta = {__index = public}

function private.newRaycastSolid ()
	local Solid = {} :: _rSolid
	
	Solid._direction = 'X'
	Solid._format = 'Degrees'
	Solid._value = 0
	Solid._raycastParams = nil
	
	local obj = object.New(Solid, private.classname)
	setmetatable(Solid :: unknown, private.meta)
	
	return obj
end

function private.changeDirection (self: _rSolid, dir: _direction)
	self._direction = dir
	return self
end

function private.changeFormat (self: _rSolid, format: _format)
	self._format = format
	return self
end

function private.changeValue (self: _rSolid, value: number)
	self._value = value
	return self
end

function private.changeRaycastParams (self: _rSolid, params: RaycastParams)
	self._raycastParams = params
	return self
end

function private.doSolidRaycast (self: _rSolid, origin: Vector3, direction: Vector3, castCount: number) : RaycastResult?
	assert(castCount >0, 'cast count <= 0')
	
	if castCount == 1 then
		return workspace:Raycast(origin, direction, self._raycastParams)
	end
	
	local angle = self._format == 'Degrees' and math.rad(self._value) or self._value
	local step = angle / (castCount - 1)

	for i = 0, castCount-1 do
		local a : number = step * i
		local cframe = CFrame.new(origin, origin + direction)
		local rotatedCframe = cframe * CFrame.Angles(
			self._direction == 'X' and a or 0,
			self._direction == 'Y' and a or 0,
			self._direction == 'Z' and a or 0
		)
		local newDirection = (rotatedCframe.LookVector * 1000).Unit

		local r = workspace:Raycast(origin, newDirection, self._raycastParams)
		if r then return r end
	end

	return nil
end











-- Установит направление, по которому выполняется каст сплошной.
function public.SetDirection (self: RaycastSolid, Direction: _direction)
	return private.changeDirection(self :: _rSolid, Direction) :: RaycastSolid
end
-- Установит формат значения.
function public.SetFormat (self: RaycastSolid, Format: _format)
	return private.changeFormat(self :: _rSolid, Format) :: RaycastSolid
end
-- Установит значение.
function public.SetValue (self: RaycastSolid, Value: number)
	return private.changeValue(self :: _rSolid, Value) :: RaycastSolid
end
-- Установит параметры для каждого рейкаста.
function public.SetRaycastParams (self: RaycastSolid, Params: RaycastParams)
	return private.changeRaycastParams(self :: _rSolid, Params) :: RaycastSolid
end
-- Выполняет каст сплошной линией, соблюдая равную дистанцию между каждым кастом. Каст выполнится столько, сколько указано в вызове. Каст всегда начинается и заканчивается в указанных позициях.
function public.Raycast (self: RaycastSolid, origin: Vector3, direction: Vector3, castCount: number)
	return private.doSolidRaycast(self :: _rSolid, origin, direction, castCount)
end



-- Проверит, принадлежит ли объект классу.
function class.IsClass (self: any)
	return self.ClassName == private.classname
end
-- Создаст объект RaySolid. Этот объект имеет изменяемые параметры. При вызове он выполнит каст сплошной линией, соблюдая дистанцию между кастами. Каст выполнится столько, сколько указано в вызове.
function class.newRaySolid () : RaycastSolid
	return private.newRaycastSolid()
end



type _direction = 'X'|'Y'|'Z'
type _format = 'Degrees' | 'Radians'
type _rSolid = {
	_direction: _direction,
	_format: _format,
	_value: number,
	_raycastParams: RaycastParams?
} & RaycastSolid

export type RaycastSolid = typeof(object.New({} :: public, private.classname))

type public = typeof(public)

export type ancestors = root & parent.ancestors
export type root = typeof(root)
export type self = typeof(class)

-- Используется для проведения рейкастов сплошмя.
function root.GetRaySolid () return class end
oop.Expanding(root, parent)
return root
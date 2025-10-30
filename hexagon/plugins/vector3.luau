--!strict

local private = {}
local public = {}

function private.DoVector3GetCircle (self: Vector3, radius: number, at: number, to: number?)
	local to : number = to or at
	
	local angle = at * ( math.pi*2 / to)
	local x = math.cos(angle) * radius
	local z = math.sin(angle) * radius

	return self + Vector3.new(x, 0, z)
end

function private.DoSnappedToGrid (self: Vector3, size: number)
	return (self//size)*size
end

function private.DoView (self: Vector3, to: Vector3)
	local dir = private.DoDirection(self,to)
	return dir:Dot(to-self)
end

function private.DoDirection (self: Vector3, to: Vector3)
	return (to - self).Unit
end

function private.DoRotated (self: Vector3, at: Vector3) : CFrame
	local dot = self:Dot(at)
	local dif = 0.999
	
	if dot > dif then
		return CFrame.new()
	elseif dot < dif then
		return CFrame.fromAxisAngle(Vector3.new(1,0,0), math.pi)
	else
		return CFrame.fromAxisAngle(self:Cross(at), math.acos(dot))
	end
end









-- Вернет направление до цели. Краткое сокращение.
function public.GetDirectionFrom (self: Vector3, to: Vector3)
	return private.DoDirection(self, to)
end
-- Вернет значение (-1|1), указывающее, насколько указанный вектор попадает в сторону, на которую смотрит первый вектор.
function public.GetViewFrom (self: Vector3, to: Vector3)
	return private.DoView(self, to)
end
-- Вычислит положение вектора по сетке.
function public.GetSnapped (self: Vector3, grid: number)
	return private.DoSnappedToGrid(self, grid)
end
-- Получить окружность по указанному вектору.
function public.GetCircle (self: Vector3, radius: number, at: number, to: number?)
	return private.DoVector3GetCircle(self, radius, at, to)
end
-- Возвращает поворот между двумя позициями, который должна совершить первая позиция для достижения того же направления, что и вторая.
function public.GetRotationTo (self: Vector3, point: Vector3)
	return private.DoRotated(self, point)
end

function public.DoRotateTo (self: Vector3, to: Vector3)
	
end



export type ancestors = self
export type self = typeof(public)

return public
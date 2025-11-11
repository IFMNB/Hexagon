--!strict

local private = {}
local public = {}

function private.DoVector3GetCircle (self: Vector3, radius: number, at: number, to: number?)
	local to : number = to or at
	
	local angle = at * ( math.pi*2 / to)
	local x = math.cos(angle) * radius
	local z = math.sin(angle) * radius

	return private.DoClone(self) + Vector3.new(x, 0, z)
end

function private.DoSnappedToGrid (self: Vector3, size: number)
	return (self//size)*size
end

function private.DoView (self: Vector3, to: Vector3)
	local dir = private.DoDirection(self,to)
	return dir:Dot(to.Unit)
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

-- XZ dir
function private.DoRadianDirection (self: Vector3, radian: number)
	local this = self.Unit
	
	local x,y = math.cos(radian), math.sin(radian)
	return Vector3.new(this.X+x,this.Y,this.Z+y)
end

function private.DoClone (self: Vector3)
	return Vector3.new(self.X,self.Y,self.Z)
end







-- Вернет направление до цели. Краткое сокращение.
function public.GetDirectionFrom (self: Vector3, to: Vector3)
	return private.DoDirection(self, to)
end
-- Вернет значение [-1|1]
function public.GetViewFrom (self: Vector3, to: Vector3)
	return private.DoView(self, to)
end
-- Вычислит положение вектора по сетке.
function public.GetSnapped (self: Vector3, grid: number)
	return private.DoSnappedToGrid(self, grid)
end
-- Получить окружность по указанному вектору.
function public.GetCirclePosition (self: Vector3, radius: number, at: number, to: number?)
	return private.DoVector3GetCircle(self, radius, at, to)
end
-- Вернет направляющий вектор по окружности с центром в self.
function public.GetRadianDirection (self: Vector3, radian: number)
	return private.DoRadianDirection(self, radian)
end
-- Вернет копию вектора.
function public.Clone (self: Vector3) : Vector3
	return private.DoClone(self)
end

-- Возвращает поворот между двумя позициями, который должна совершить первая позиция для достижения того же направления, что и вторая.
function public.GetRotationTo (self: Vector3, point: Vector3)
	return private.DoRotated(self, point)
end



export type ancestors = self
export type self = typeof(public)

return public
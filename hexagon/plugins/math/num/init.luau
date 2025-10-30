--!strict

local parent = require('./')

local private = {}
local public = {}

setmetatable(public :: unknown, {__index = parent})

function private.getspec (self: number)
	if self ~= self then
		return 'nan'
	else
		if self == math.huge then
			return 'inf'
		elseif self == -math.huge then
			return '-inf'
		else
			return 'num'
		end
	end
end
function private.isspec (self: number)
	return private.getspec(self) ~= 'num'
end
function private.isfract (self: number)
	return math.floor(self)~=self
end
function private.isNegative (self: number)
	return self < 0
end



-- Проверит число на NaN, inf, -inf
function public.getNumberType (self: number)
	return private.getspec(self) :: 'nan' | 'inf' | '-inf' | 'num'
end
-- Это число NaN, inf, -inf?
function public.isSpecialNumber (self: number) 
	--print(debug.traceback('t'))
	return private.isspec(self)
end
-- Это число с плавающей точкой?
function public.isFractional (self: number)
	return private.isfract(self)
end
-- Это отрицательное число?
function public.isNegative (self: number)
	return private.isNegative(self)
end

export type self = typeof(public)
export type ancestors = self

return public
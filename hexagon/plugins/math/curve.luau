--!strict

local parent = require('./')

local private = {}
local public = {}

setmetatable(public :: unknown, {__index = parent})











function public.GetBezierCurve ()
	
end

export type ancestors = self & parent.ancestors
export type self = typeof(public)

return public
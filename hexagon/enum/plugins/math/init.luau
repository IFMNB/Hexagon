--!strict

local private = {}
local public = {}


function private.doMathPerlinNoise (x: number, z:number, frequency: number, roughness: number)
	return math.noise(x * frequency, z * frequency) * roughness
end

function private.doRandomCall (f1: f, f2: f, ...: any)
	local a = math.random(1,2) == 1 and f1(...) or f2(...)
	return a
end




type f = (...any)->any
-- Randomly calls one of the given functions.
@deprecated
function public.randomDo (f1: f, f2: f, ...: any) : any
	return private.doRandomCall(f1,f2,...)
end

-- Returns perlin noise value.
@deprecated -- broken idk why im too lazy to fix it
function public.perlin (x: number, z:number, frequency: number, roughness: number)
	return private.doMathPerlinNoise(x,z,frequency,roughness)
end

export type ancestors = self
export type self = typeof(public)

return public
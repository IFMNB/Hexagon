--!strict

local private = {}
local public = {}


function private.doMathPerlinNoise (x: number, z:number, frequency: number, roughness: number)
	return math.noise(x * frequency, z * frequency) * roughness
end






-- Вернет шум перлина.
function public.perlin (x: number, z:number, frequency: number, roughness: number)
	return private.doMathPerlinNoise(x,z,frequency,roughness)
end

export type ancestors = self
export type self = typeof(public)

return public
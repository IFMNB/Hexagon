--!strict

local num = require('./')

local private = {}
local public = {}



function private.getunsignedbit (self: number)
	assert(not num.isSpecialNumber(self), 'this is spec number')
	assert(not num.isFractional(self), 'this is float')
	return 2^self - 1
end

function private.getsignedbit (self: number, result: 'i+'|'i-')
	assert(not num.isSpecialNumber(self), 'this is spec number')
	assert(not num.isFractional(self), 'this is float')
	local r = (2^self)/2
	return result == 'i+' and r-1 or -r
end
 
function private.getUnsignedBitMap ()
	local r : {number} = {}

	table.insert(r, public.getUnsignedBit(8))
	table.insert(r, public.getUnsignedBit(16))
	table.insert(r, public.getUnsignedBit(32))
	table.insert(r, public.getUnsignedBit(64))

	return r
end

function private.convertuns (self: number)
	if num.isNegative(self) then
		return (math.abs(self)*2)-1
	else
		return (math.abs(self)*2)+1
	end
end

function private.bitsize (self: number) : number?
	assert(not num.isSpecialNumber(self), 'this is a special num')
	self = num.isNegative(self) and public.convertToUnsigned(self) or self
	
	local map = public.getUnsignedBitMap()

	for i,v in ipairs(map) do
		if self < v then
			return 8 * i
		end
	end
	
	return nil
end


-- Для дробных чисел возвращается условный неоднозначный тип
function private.getinttype (self: number) : numType
	assert(not num.isSpecialNumber(self), 'this is a special num' ) 
	if num.isFractional(self) then
		return 'float'
	end
	
	local size = private.bitsize(self) :: number
	
	if size <= 8 then
		return 'char'
	elseif size <= 16 then
		return 'short int'
	elseif size <= 32 then
		return 'int'
	elseif size > 32 then
		return 'long int'
	else
		return nil
	end
end

function private.getbuffersized (self: number)
	local intType = private.getinttype(self)
	
	if intType == 'float' then
		return buffer.writef32, buffer.readf32
	elseif intType == 'char' then
		return buffer.writeu8, buffer.readu8
	elseif intType == 'short int' then
		return buffer.writeu16, buffer.readu16
	elseif intType == 'int' then
		return buffer.writeu32, buffer.readu32
	elseif intType == 'long int' then
		return buffer.writef64, buffer.readf64
	else
		error('unknown value type '..tostring(intType))
	end
end

function private.generateSpecialUnsMap ()
	local r : {number} = {}
	for i=1, 64 do
		table.insert(r, public.getUnsignedBit(i))
	end
	return r
end

function private.calculatebitsize(self: number)
	return math.floor(math.log(self, 2)) + 1
end





-- Converts a number from "signed" scheme to "unsigned".
function public.convertToUnsigned (self: number)
	return private.convertuns(self)
end
-- Returns only positive bit size of number for target scheme.
function public.getUnsignedBit (self: number) : number
	return private.getunsignedbit(self)
end
-- Returns a table of bits in the "signed" (i) scheme and awaited format.
function public.getSignedBit (self: number, result: 'i+'|'i-')
	return private.getsignedbit(self, result)
end
-- Returns bit-map for 8,16,32,64 unsigned values
function public.getUnsignedBitMap ()
	return private.getUnsignedBitMap()
end
-- Returns 2 functions for read and write, considering the optimal bit size for the number.
function public.getWriteReadFor (self: number)
	return private.getbuffersized(self)
end
-- Returns type for this value from: 'float', 'char', 'short int', 'int', 'long int'
function public.getIntType (self: number)
	return private.getinttype(self)
end
-- Returns optimal bit region for this value.
function public.getDefaultBitRegion (self: number)
	return private.bitsize(self)
end
-- Returns map from 1 to 64 for unsigned values
function public.getSpecialUnsignedBitMap ()
	return private.generateSpecialUnsMap()
end
-- Returns bit size for unsigned value.
function public.getBitSize (self: number)
	return private.calculatebitsize(self)
end


export type numType = 'float' | 'char' | 'short int' | 'int' | 'long int' | nil 
export type self = typeof(public)
export type ancestors = self

return public   
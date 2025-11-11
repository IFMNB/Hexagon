--!strict


local parent = require('./')
local str = require('../str')


local private = {}
local public = {}

setmetatable(public :: unknown, {__index = parent})

function private.fillstring (self: buffer, offtop: number, value: string)
	assert(str.isascii(value))

	local sp = value:split('')
	local ascii = str.getallstr()
	local load = {}
	
	for i=1, #sp do
		local strk = assert(table.find(ascii, sp[i]), 'not ascii symbol detected.')
		table.insert(load, strk)
	end
	
	parent.includeu8(self, offtop, unpack(load))
	
	return self
end







-- Включительно от указанной позиции, заполнит n-позиции числом, которое соответствует string.char(число).
function public.fillStringu8 (self: buffer, offtop: number, value: string)
	return private.fillstring(self,offtop, value)
end

export type self = typeof(public)
export type ancestors = self & parent.ancestors

return public
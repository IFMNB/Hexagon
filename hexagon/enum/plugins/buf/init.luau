--!strict

local private = {}
local public = {}

function private.includebyte (self: buffer, offtop: number, func: any, ...: number)
	local size = buffer.len(self)
	local work = size - offtop
	local insert = {...}
	
	assert(offtop<size, 'offtop out of buffer-bounds')
	assert(#insert<=work, 'out of buffer-bounds from all received values')

	local n=1
	for i=offtop, work do
		if n>#insert then break end
		func(self, i, insert[n]);
		n+=1
	end

	return self
end



-- Заполняет буффер, включительно от указанной позиции, значениями формата u8 столько, сколько было получено значений. Соответственно не проверяет тип битовки значений.
function public.includeu8 (self: buffer, offtop: number, ...: number)
	return private.includebyte(self, offtop, buffer.writeu8, ...)
end
-- Заполняет буффер, включительно от указанной позиции, значениями формата u16 столько, сколько было получено значений. Соответственно не проверяет тип битовки значений.
function public.includeu16 (self: buffer, offtop: number, ...: number)
	return private.includebyte(self, offtop, buffer.writeu16, ...)
end
-- Заполняет буффер, включительно от указанной позиции, значениями формата u32 столько, сколько было получено значений. Соответственно не проверяет тип битовки значений.
function public.includeu32 (self: buffer, offtop: number, ...: number)
	return private.includebyte(self, offtop, buffer.writeu32, ...)
end
-- Заполняет буффер, включительно от указанной позиции, значениями формата f32 столько, сколько было получено значений. Соответственно не проверяет тип битовки значений.
function public.includef32 (self: buffer, offtop: number, ...: number)
	return private.includebyte(self, offtop, buffer.writef32, ...)
end
-- Заполняет буффер, включительно от указанной позиции, значениями формата f64 столько, сколько было получено значений. Соответственно не проверяет тип битовки значений.
function public.includef64 (self: buffer, offtop: number, ...: number)
	return private.includebyte(self, offtop, buffer.writef64, ...)
end


export type ancestors = self
export type self = typeof(public)

return public
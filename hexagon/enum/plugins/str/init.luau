--!strict

local private = {}
local public = {}

function private.getnumstr ()
	local r = {}
	for i= 48, 57 do table.insert(r,string.char(i)) end
	return r
end

function private.getspecstr ()
	local r = {}

	for i= 32, 47 do table.insert(r, string.char(i)) end
	for i= 58, 64 do table.insert(r, string.char(i)) end
	for i= 91, 96 do table.insert(r, string.char(i)) end
	for i= 123, 126 do table.insert(r, string.char(i)) end

	return r
end

function private.getlower ()
	local r = {}
	for i = 97, 122 do table.insert(r, string.char(i)) end
	return r
end

function private.getupper ()
	local r = {}
	for i = 65, 90 do table.insert(r, string.char(i)) end
	return r
end

function private.getletters ()
	local l = private.getlower()
	local u = private.getupper()

	table.move(u,1,#u,#l+1,l)

	return l
end

function private.getallstr ()
	local l = private.getletters()
	local sp = private.getspecstr()
	local nm = private.getnumstr()

	table.move(sp,1,#sp,#l+1,l)
	table.move(nm,1,#nm,#l+1,l)

	return l
end


function private.isascii (self: string)
	for i = 1, #self do
		if string.byte(self, i) >= 128 then
			return false
		end
	end

	return true
end


--[[ -- на данный момент не требуется. А еще это надо пофиксить
function private.toascii (self: string)
	local r = self:split()
	local al = private.getallstr()
	
	for i,v in ipairs(r) do
		r[i] = table.find(al,v) and v or '#'
	end
	
	return table.concat(r)
end


-- Все utf8 символы будут переведены в ascii символ "#"
function public.toascii (self: string)
	
end

]]

-- Проверит, является ли строка полностью ASCII.
function public.isascii (self: string)
	return private.isascii(self)
end
-- Проверит, есть ли в строке UTF-8.
function public.isutf (self: string)
	return not private.isascii(self)
end






-- Вернет все цифры ASCII массивом.
function public.getnumstr ()
	return private.getnumstr()
end
-- Вернет все специальные символы ASCII массивом.
function public.getspecstr ()
	return private.getspecstr()
end
-- Вернет все заглавные символы ASCII массивом.
function public.getupper ()
	return private.getupper()
end
-- Вернет все строчные символы ASCII массивом.
function public.getlower ()
	return private.getlower()
end
-- Вернет все символы ASCII массивом.
function public.getletters ()
	return private.getletters()
end
-- Вернет все ASCII символы массивом.
function public.getallstr ()
	return private.getallstr()
end


export type ancestors = self
export type self = typeof(public)

return public
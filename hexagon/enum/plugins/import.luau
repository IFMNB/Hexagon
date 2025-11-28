--!strict

local enum = require('../')

local private = {}
local public = {}

function private.DoTry (func: (...any)->any, T: number, try: number, ...: any) : any
	local count = T
	
	repeat
		local st, r = pcall(func, function(a0) warn(a0) end,...)
		if st then return r end

		count-=1
		task.wait(try)
	until count > 0
	
	return nil
end


function private.DoTryCatch (catch: any, ...: any)
	local res = private.DoTry(...)
	if res == catch then
		return res
	else
		error('Unable to catch value.')
	end 
end

function private.UnhandledDefaultException (...)
	warn(...)
	error(tostring(enum.Error.Reset))
end


type cases =  {default: ((...any)->any?)?, [any]:  ((...any)->any?)|any}

-- Автозаполнение типов не может подсказывать функцию, если ее тип может быть any помимо функции. Хотя технически switch вполне поддерживает такую реализацию.
function private.DoGetSwitchedValue (value: any, case: cases) : any
	return case[value] or case.default or private.UnhandledDefaultException
end




-- Реализация блока TryCatch -> делай, пока не получишь нужный результат
function public.catch <type> (catch: type, func: (...any)->any, try: number, timewait: number, ...: any) : any
	return private.DoTryCatch(catch, func, try, timewait, ...)
end
-- Реализация try, отделенного от try-catch -> делай, пока не успешно.
function public.try (func: (...any)->any, try: number, timewait: number, ...: any) : any
	return private.DoTry(func, try, timewait, ...)
end
-- Реализация блока switch из разных языков.
function public.switch (value: any, case: cases) : any
	return private.DoGetSwitchedValue(value, case)
end

export type self = typeof(public)
export type ancestors = self

return public
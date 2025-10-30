--!strict

local private = {}
local public = {}

function private.DoTry (func: (...any)->any, wait: number, try: number, ...: any)
	for i=1, try do
		local st, r = pcall(function(...)
			return func(...)
		end, ...)

		if st then
			return r
		else
			warn(r)
		end
		
		task.wait(wait)
	end

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


-- Автозаполнение типов не может подсказывать функцию, если ее тип может быть any помимо функции. Хотя технически switch вполне поддерживает такую реализацию.
function private.DoGetSwitchedValue (value: any, case: {default: (...any)->any?, [any]:  ((...any)->any?)|any}, ...: any) : any
	local instruction = case[value]
	local result = type(instruction) == 'function' and instruction(...) or instruction or case.default(...)
	return result
end




-- Реализация блока TryCatch
function public.tryCatch (catch: any, func: (...any)->any, try: number, wait: number, ...: any)
	return private.DoTryCatch(catch, func, try, wait, ...)
end
-- Реализация try, отделенного от try-catch
function public.try (func: (...any)->any, try: number, wait: number, ...: any)
	return private.DoTry(func, try, wait, ...)
end
-- Реализация блока switch из разных языков.
function public.switch (value: any, case: {default: (...any)->any?, [any]:  ((...any)->any?)|any}, ...: any) : any
	return private.DoGetSwitchedValue(value, case, ...)
end

export type self = typeof(public)
export type ancestors = self

return public
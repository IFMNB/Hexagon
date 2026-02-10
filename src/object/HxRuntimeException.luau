local main = require('./');

local private = {};
local class = {}; setmetatable(class,class);
local interface = {};

type HxRuntimeException <T=nil , U=DefDesc> = typeof(interface.new(''::T))

type function REG (MY_NANE: type, DEF_NAME: type)
	local types = types
	return (MY_NANE:is('singleton') or MY_NANE:is('string')) and MY_NANE or DEF_NAME
end
type DefDesc=typeof(class.Description)
type DefCode=typeof(class.Code);

function private.new <T,U> (Name : T?, Description: U?)
	return main.new({
		Code = Name :: REG<T,DefCode | string>,
		Counter = 0,
		Description = Description :: REG<U,DefDesc | string>
	}, class)
end

-- Causes a error if it throws.
function private:throw () : never
	local self = self :: HxRuntimeException;
	self.Counter+=1
	class.GlobalCounter+=1
	warn(self.Code, self.Description)
	error(self)
end
-- Equalent to assert. Throws self if assertion is failed.
function private:assert <T> (assertion: T) : typeof(assert(nil::T))
	local self = self :: HxRuntimeException;
	if not assertion then
		return self:Throw()
	else
		return assertion
	end
end

function private.Get_throwed ()
	return class.GlobalCounter
end

class.__index=main.Objects.class;
class.ClassName=main.ClassNames.HxRuntimeException;
class.Source=script;
class.Throw = private.throw;
class.Code = 'RuntimeException'::'RuntimeException';
class.Description = 'An unknown error occurred while executing the program.' :: 'An unknown error occurred while executing the program.';
class.Counter = 0;
class.GlobalCounter = 0;
class.Assert = private.assert;

interface.class=class;
interface.new=private.new;
interface.throwed = private.Get_throwed;

return main:expand({HxRuntimeException=interface})
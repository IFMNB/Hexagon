local main = require('./');

local private = {};
local class = {}; setmetatable(class,class);
local interface = {};

type HxRuntimeException <T=nil , U=DefDesc> = typeof(interface.new(''::T))
private.https = game:GetService('HttpService')

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
function private:throw ()
	local self = self :: HxRuntimeException;
	self.Counter+=1
	class.GlobalCounter+=1
	warn(self.Code, self.Description)
	return error(private.https:JSONEncode(self))
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

function private:warn (text: any)
	local self = self :: HxRuntimeException;
	self.WarnCounter +=1
	warn(string.format('Exception %s : %q \n Additional info: %q', self.Code, self.Description, tostring(text)))
end

class.__index=main.Objects.class;
class.ClassName=main.ClassNames.HxRuntimeException;
class.Source=script;


class.Throw = private.throw;
class.Assert = private.assert;
class.Warn = private.warn;

class.Code = 'RuntimeException'::'RuntimeException';
class.Description = 'An unknown error occurred while executing the program.' :: 'An unknown error occurred while executing the program.';

class.Counter = 0;
class.WarnCounter = 0;
class.GlobalCounter = 0;



interface.class=class;
interface.new=private.new;
interface.throwed = private.Get_throwed;

return main:expand({HxRuntimeException=interface})
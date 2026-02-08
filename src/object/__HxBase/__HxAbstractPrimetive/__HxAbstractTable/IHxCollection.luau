local main = require('./');

local private = {};
local class = {}; setmetatable(class,class);
local interface = {};

type IHxCollection = typeof(class)

function private:set (index: string, value: any)
	local self = self :: IHxCollection;
	assert(self.Value, '')
	assert(self.Value[index]==nil, '')
	self.Value[index] = value
end

function private:get (index: string)
	local self = self :: IHxCollection;
	assert(self.Value, '')
	return self.Value[index]
end

class.__index=main.__HxAbstractTable.class;
class.ClassName = main.ClassNames.IHxCollection;
class.Source = script;
class.Value = nil :: {[string]: any}?;
class.Get = private.get;
class.Set = private.set;

interface.class = class;

return main:expand({_IHxCollection=interface})
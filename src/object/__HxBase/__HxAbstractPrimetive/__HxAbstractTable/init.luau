local main = require('./');

local private = {};
local class = {}; setmetatable(class,class);
local interface = {};

type HxAbstractTable = typeof(class)

function private:get_count ()
	local self = self :: HxAbstractTable;
	assert(self.Value, 'Value is nil')
	
	local count = 0
	for i,v in self.Value do
		count+=1
	end
	
	return count
end

function private:clear ()
	local self = self :: HxAbstractTable;
	assert(self.Value, 'Value is nil')
	
	for i,v in self.Value do
		self.Value[i] = nil
	end
end

function private:contains (value: any)
	local self = self :: HxAbstractTable;
	assert(self.Value, 'Value is nil')
	
	for i,v in self.Value do
		if v == value then
			return true
		end
	end
	
	return false
end

function private:has_type (typename: string)
	local self = self :: HxAbstractTable;
	assert(self.Value, 'Value is nil')
	
	for i,v in self.Value do
		if typeof(v) == typename then
			return true
		end
	end
	
	return false
end

function private:has_key_type (typename: string)
	local self = self :: HxAbstractTable;
	assert(self.Value, 'Value is nil')
	
	for i,v in self.Value do
		if typeof(i) == typename then
			return true
		end
	end
	
	return false
end

class.__index = main.__HxAbstractPrimetive.class;
class.ClassName = main.ClassNames.HxAbstractTable;
class.Source = script;
class.Value = nil :: {[any]:any}?;
class.Count = private.get_count;
class.Clear = private.clear;
class.Contains = private.contains;
class.HasVType = private.has_type;
class.HasIType = private.has_key_type;
class.Set = main.Abstract.SelfOverride;
class.Get = main.Abstract.SelfOverride;

interface.class = class;


table.freeze(private)
table.freeze(class)
table.freeze(interface)
return main:expand({__HxAbstractTable=interface})
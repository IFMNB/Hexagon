local main = require('./HxComponent')

local private = {};
local class = {};
class.__index = main.__HxAbstractECS.class;
setmetatable(class,class);
local interface = {};

type HxEntity = typeof(interface.new());
type HxObject = typeof(main.Objects.new({}))

function private.new (Next: HxEntity?)
	return main.new({
		EntityId = tostring(tick());
		Components = {} :: typeof(class.Components);
		NextEntity = Next;
	},class)
end

function private:add (Name: string, Component)
	local self = self :: HxEntity;
	
	assert(not self.Components[Name], '')
	self.Components[Name]=Component
	return self
end

function private:rem (Name: string)
	local self = self :: HxEntity;
	self.Components[Name]=nil
	return self
end

class.RemComponent = private.rem;
class.AddComponent = private.add;
class.ClassName = main.ClassNames.HxEntity;
class.Source = script;
class.EntityId = '';
class.NextEntity = nil :: HxEntity?;
class.Components = {};

interface.class = class;
interface.new = private.new;

table.freeze(class)
table.freeze(interface)
table.freeze(private)

return main:expand({HxEntity=interface})
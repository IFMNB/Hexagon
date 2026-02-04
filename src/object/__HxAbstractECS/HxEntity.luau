local main = require('./__HxAbstractComponent')

local private = {};
local class = {};
class.__index = main.__HxAbstractECS.class;
setmetatable(class,class);
local interface = {};

type HxEntity = typeof(private.new())

function private.new (Next: HxEntity?)
	return main.new({
		EntityId = tostring(newproxy());
		Components = {};
		NextEntity = Next;
	},class)
end

class.ClassName = main.ClassNames.HxEntity;
class.Source = script;
class.EntityId = '';
class.NextEntity = nil :: HxEntity?;
class.Components = {} :: {[string]: typeof(main.__HxAbstractComponent.class)};

interface.class = class;
interface.new = private.new;

return main:expand({HxEntity=interface})
local main = require('./__HxAbstractComponent');

local private = {};
local class = {};
class.__index=main.__HxAbstractECS.class;
setmetatable(class,class);
local interface = {};
interface.class = class;


class.Components = {} :: {[string]: typeof(main.__HxAbstractComponent.class)}; -- pack of system requirements
class.SystemCall = main.Abstract.ShouldOverrided;
class.ClassName = main.ClassNames.HxAbstractSystem;
class.Source = script;

return main:expand({__HxAbstractSystem = interface})
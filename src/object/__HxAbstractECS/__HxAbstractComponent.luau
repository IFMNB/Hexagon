local main = require('./');

local private = {};
local class = {};
class.__index=main.__HxAbstractECS.class;
setmetatable(class,class);
local interface = {};
interface.class = class;


class.Replicatable = true :: true;
class.ComponentName = '';
class.ClassName = main.ClassNames.HxAbstractComponent;
class.Source = script;

return main:expand({__HxAbstractComponent = interface})
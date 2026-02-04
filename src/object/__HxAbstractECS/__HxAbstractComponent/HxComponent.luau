local main = require('./');

local private = {};
local class = {};
class.__index=main.__HxAbstractComponent.class;
setmetatable(class,class);
local interface = {};
interface.class = class;

class.EntityId = nil :: string?;
class.ClassName = main.ClassNames.HxComponent;
class.Source = script;

interface.new = main.Abstract.ShouldOverrided;

return main:expand({HxComponent = interface})
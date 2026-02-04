local main = require('./');


local private = {};
local class = {};
class.__index=main.Objects.class;
setmetatable(class,class);
local interface = {};
interface.class = class;


class.ClassName = main.ClassNames.HxAbstractECS;
class.Source = script;

return main:expand({__HxAbstractECS = interface, I_Base=require('../interface/src_base')})
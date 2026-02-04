local main = require('./')

local private = {};
local class = {}; class.__index=main.__AbstractBase.class; setmetatable(class,class);
local interface = {}; interface.class = class;

--[[

Classes in this class cannot use their neighbours due to their specifys.

]]

class.ClassName=main.ClassNames.HxAbstractProperty;
class.Source=script;

return main:expand({__HxAbstractProperty=interface})
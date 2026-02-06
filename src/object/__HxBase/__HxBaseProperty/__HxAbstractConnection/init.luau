local main = require('./')

-- local class for events.

local private = {};
local class = {}; class.__index = main.__HxBaseProperty.class; setmetatable(class, class);
local interface = {}; interface.class = class;

class.Source = script
class.ClassName = main.ClassNames.HxAbstractConnection
class.WatchConnected = main.Abstract.SelfOverride
class.Connected = false
class.Owner = nil :: unknown

return main:expand({__HxAbstractConnection=interface})
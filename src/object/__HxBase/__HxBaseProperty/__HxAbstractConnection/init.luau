local main = require('./')

-- local class for events.

local private = {};
local class = {}; class.__index = main.__HxBaseProperty.class; setmetatable(class, class);
local interface = {}; interface.class = class;

class.Source = script
class.ClassName = main.ClassNames.HxAbstractConnection
class.Connected = false
class.Disconnect = main.Abstract.SelfOverride

export type HxAbstractConnection = typeof(class)

return main:expand({__HxAbstractConnection=interface})
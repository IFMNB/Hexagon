local main = require('./')
local obj=main.Objects

local private = {}
local class = {}; class.__index=obj.class;setmetatable(class,class);
local interface = {}; interface.class=class


function private.new <value,data,class> (value: value, class: class)
	return main.new({Value = value},class)
end

class.ClassName=main.ClassNames.HxAbstractPrimetive
class.Source=script
class.Value = nil :: unknown
interface.new = private.new

table.freeze(private)
table.freeze(class)
table.freeze(interface)
return main:expand({
	__HxAbstractPrimetive=interface,
	Events = require('./__HxAbstractProperty/events').Events,
	Hooks = require('./__HxAbstractProperty/hook').Hooks,
	Shade = require('./__HxAbstractProperty/shade').Shade,
	Snapshot = require('./__HxAbstractProperty/snapshot').Snapshot,
	MetalinkCreator = require('./__HxAbstractProperty/__HxAbstractMetalink/HxMetalinkCreator').HxMetalinkCreator
})
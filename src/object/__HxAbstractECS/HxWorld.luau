local main = require('./__HxAbstractSystem')

local private = {};
local class = {};
class.__index=main.__HxAbstractECS.class;
setmetatable(class,class);
local interface = {};

function private.new ()
	
end





class.AddSystem = private.add_sys;
class.RemSystem = private.remove_sys;
class.DoSystem = private.do_system;

class.AddEntity = private.add_ent;
class.RemEntity = private.remove_ent;
class.GetEntity = private.get_ent;

class.ClassName = main.ClassNames.HxWorld;
class.Source = script;

interface.class = class;
interface.new = private.new;

return main:expand({HxWorld = interface})
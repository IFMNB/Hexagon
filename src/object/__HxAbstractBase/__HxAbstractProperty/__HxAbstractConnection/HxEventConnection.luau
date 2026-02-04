local main = require('./')

local private = {};
local class = {};
class.__index=main.__HxAbstractConnection.class;
setmetatable(class,class);
local interface={};
interface.class=class;

class.ClassName=main.ClassNames.HxEventConnection;
class.Source=script;
class.Parent=nil::unknown;

type HxEventConnection=typeof(class)

function private:Disconnect ()
	local self=self::HxEventConnection
	
end

@deprecated
function private.new <parent, type, reference> (parent: parent, type: type, reference: reference)
	return main.new({
		Parent = parent,
		Type = type,
		Reference = reference
	}, class)
end

--interface.new = private.new


return main:expand({[class.ClassName]=interface})
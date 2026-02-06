local main = require('./')

local private = {};
local class = {};
class.__index=main.__HxAbstractConnection.class;
setmetatable(class,class);
local interface={};
interface.class=class;

class.ClassName=main.ClassNames.HxReferencedConnection;
class.Source=script;

function private:Disconnect ()

end

function private.new <parent, type, reference> (parent: parent, reference: reference)
	return main.new({
		Owner = parent,
		Reference = reference
	}, class)
end

interface.new = private.new

return main:expand({[class.ClassName]=interface})
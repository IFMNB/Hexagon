local main = require('./');

local private = {};
local class = {}; setmetatable(class,class);
local interface = {};

function private.new <Y,T,U> (value: Y?, BackNode: T?, NextNode: U?)
	return main.new({
		Value = value :: Y,
		BackNode = BackNode :: T,
		NextNode = NextNode :: U,
	}, class)
end

class.__index=main.__HxAbstractTable.class;
class.ClassName=main.ClassNames.HxNode;
class.Source=script;

interface.class = class;
interface.new = private.new;

return main:expand({HxNode=interface})
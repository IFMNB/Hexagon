local main = require('./');

local private = {};
local class = {}; setmetatable(class,class);
local interface = {};

function private.new ()
	return main.new({
		Value = setmetatable({}, {__mode='v'::'v'}) :: typeof(class.Value);
	}, class)
end

class.__index=main._IHxCollection.class;
class.ClassName=main.ClassNames.HxWeakCollection;
class.Source=script;

interface.class = class;
interface.new = private.new;

return main:expand({HxWeakCollection=interface})
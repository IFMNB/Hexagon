local main = require('./')

local private = {};
local class = {}; class.__index=main.__AbstractBase.class;setmetatable(class,class)
local interface = {}; interface.class=class

private._snapshots = setmetatable({}::{[Snapshot]:any},{__mode='vs'})
type Snapshot = typeof(private.new({}::any))



function private.new <data> (object: data)
	local self = main.new({
		Snapshot = setmetatable(table.clone(object),getmetatable(object)),
		Data = os.time()
	}, class)
	
	private._snapshots[self]=object
	
	return self
end

function private:origin()
	return private._snapshots[self::Snapshot] :: typeof(self.Snapshot)
end

class.Origin = private.origin
class.Snapshot = nil :: any
class.Data = os.time() :: number
class.Source=script
class.ClassName = main.ClassNames.HxSnapshot
interface.new = private.new

table.freeze(class)
table.freeze(private)
table.freeze(interface)
return main:expand({Snapshot=interface})
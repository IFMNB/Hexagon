local main = require('./HxEntity')

local private = {};
local class = {};
class.__index=main.__HxAbstractECS.class;
setmetatable(class,class);
local interface = {};

type HxEntity = typeof(main.HxEntity.new())
export type SystemCall = (HxEntity: HxEntity) -> ()

function private.new <Dependencies...> (SystemCall: SystemCall?, ...: Dependencies...)
	return main.new({
		SystemCall = SystemCall or warn :: SystemCall,
		Dependencies = table.freeze({...})
	},class)
end

class.Dependencies = {} :: {any}; -- pack of system requirements
class.SystemCall = main.Abstract.SelfOverride;
class.ClassName = main.ClassNames.HxSystem;
class.Source = script;

interface.new = private.new;
interface.class = class;

table.freeze(class)
table.freeze(interface)
table.freeze(private)

return main:expand({HxSystem = interface})
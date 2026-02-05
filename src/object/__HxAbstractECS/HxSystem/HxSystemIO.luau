local main = require('./')
local event = main.I_Base.Classes.Event()

local private = {};
local class = {};
class.__index=main.HxSystem.class;
setmetatable(class,class);
local interface = {}

type HxEntity = typeof(main.HxEntity.new())
export type IOSystemCall = (InputEventProperties: typeof(private.event), OutputEventProperties: typeof(private.event), HxEntity: HxEntity) -> ()

function private.new <Dependencies...> (SystemCall: IOSystemCall?, ...: Dependencies...)
	local input, iproperties = event.new(private.eventname)
	local output, oproperties = event.new(private.eventname)
	local SystemCall = SystemCall or warn :: IOSystemCall;
	local function Outline (HxEntity: HxEntity) return SystemCall(iproperties, oproperties, HxEntity) end
	return main.new({
		SystemCall = Outline,
		Dependencies = table.freeze({...}),
		OnInputEvent = input,
		OnOutputEvent = output
	}, class)
end

private.eventname = 'IOEvent'::'IOEvent';
class.OnInputEvent, private.event = event.new(private.eventname); private.event:Destroy()
class.OnOutputEvent = class.OnInputEvent; 
class.ClassName=main.ClassNames.HxSystemIO;
class.Source=script


interface.class = class;
interface.new = private.new;


table.freeze(class)
table.freeze(interface)
table.freeze(private)

return main:expand({HxSystemIO = interface})
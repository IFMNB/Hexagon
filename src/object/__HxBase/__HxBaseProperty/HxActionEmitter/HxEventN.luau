local main = require('./');

local private = {};
local class_properties = {}; setmetatable(class_properties,class_properties);
local subclass_event = {}; setmetatable(subclass_event,subclass_event);
local interface = {};

private.mk = {__mode='k'}
local HxConnection = main.HxConnection

type HxEventProperties = typeof(class_properties)
type HxEvent <HEP=HxEventProperties,HEN=Name> = typeof(private.new_event(nil::HEP, nil::HEN))
type HxEventConnection = typeof(HxConnection.new())
type HxActionEmitter = typeof(main.HxActionEmitter.new())

type Name <T=string> = T
type DefaultFunction <SF=(...any)->()> = SF
type F = (...any)->()
type ConType = 'Connection'|'Once'
type RunType = 'Parallel'|'Serial'
type ListenerConnection = {
	Connection: HxEventConnection,
	Type: ConType,
	Run: RunType,
	Func: F
}
type Listener = ()->ListenerConnection
type Connect = (self: HxEvent, Function: F)->HxEventConnection
type SelfDefF <T=()->...any> = {DefaultFunction: T} | any

function private.call_properties (Properties: HxEventProperties, ...)
	for i,v in Properties.Listeners do
		local this = v();
		
		if this.Run == 'Serial' then
			task.spawn(this.Func, ...)
		elseif this.Run == 'Parallel' then
			task.spawn(function (...) task.desynchronize() this.Func(...) end,...)
		else
			warn('Invalid Connection RunType', this.Run)
			Properties:RemListener(v)
			continue
		end
		
		if this.Type == 'Once' then
			Properties:RemListener(v)
		end
	end
end

function private.new_event <T, Signa> (Properties: SelfDefF<Signa>, Name: T)
	local this = {}

	function this:Connect (Function: Signa?)
		return private.connect(Properties, Function or Properties.DefaultFunction, 'Connection', 'Serial')
	end
	
	function this:Once (Function: Signa?)
		return private.connect(Properties, Function or Properties.DefaultFunction, 'Once', 'Serial')
	end
	
	function this:ConnectParallel (Function: Signa?)
		return private.connect(Properties, Function or Properties.DefaultFunction, 'Connection', 'Parallel')
	end
	
	function this:OnceParallel (Function: Signa?)
		return private.connect(Properties, Function or Properties.DefaultFunction, 'Once', 'Parallel')
	end
	
	function this:Wait () : ...unknown
		local thread = coroutine.running()
		this:Once(function ()
			return coroutine.resume(thread)
		end)
		return coroutine.yield()
	end
	
	return main.new(this, subclass_event)
end

function private.connect <Signa> (Properties: SelfDefF<Signa>, Function: F, ConType: ConType, RunType: RunType)
	local this : ListenerConnection = {} :: any
	
	local function Listener ()
		return this
	end
	local Connection = HxConnection.new(function(HxConnection) 
		Properties:RemListener(Listener)
	end);

	Properties:AddListener(Listener)
	
	this.Connection = Connection;
	this.Type = ConType;
	this.Run = RunType;
	this.Func = Function;
	
	return Connection;
end



function private.new_event_properties <U, T> (Name: U|Name?, DefaultFunction: T|DefaultFunction?)
	local raw = {}
	raw.EventsWatchers = setmetatable({}, private.mk);
	raw.Name = Name :: U;
	raw.Alive = true;
	raw.DefaultFunction = DefaultFunction :: T;
	
	local this = main.new(raw, class_properties)
	return this
end

local a = private.new_event_properties('a', function(a: string) return 23 end)
local b = private.new_event(a, '')
local c = a:CreateEvent()

c:Connect()

function private.create_event <T> (self: SelfDefF<T>)
	local Event = private.new_event(self, '');
	local self = self :: HxEventProperties;
	
	local HxActionEmitter = main.HxActionEmitter.new();
	
	HxActionEmitter.OnceAction = true;
	self.EventsWatchers[Event] = HxActionEmitter;
	return Event
end

function private:kill_event (HxEvent: HxEvent)
	local self = self :: HxEventProperties;
	local Event = self.EventsWatchers[HxEvent];
	if Event then
		Event:Process()
		self.EventsWatchers[HxEvent] = nil;
	end
	
	if game["Run Service"]:IsStudio() then
		warn('HxEventProperties does not have received HxEvent', debug.traceback())
	end
end




class_properties.__index = main.HxActionEmitter.class;
class_properties.ClassName = main.ClassNames.HxEvent;
class_properties.Source = script;
class_properties.Listeners = {} :: {Listener};
class_properties.EventsWatchers = setmetatable({} :: {[HxEvent]: HxActionEmitter}, private.mk);
class_properties.DefaultFunction = warn :: DefaultFunction;
class_properties.Name = '' :: Name;
class_properties.Alive = false;
class_properties.CreateEvent = private.create_event;
class_properties.DoCall = private.call_properties;
class_properties.DoDestroy = nil; 

subclass_event.__index = main.__HxBaseProperty.class;
subclass_event.ClassName = main.ClassNames.HxEvent;
subclass_event.Source = script;

subclass_event.Connect = main.Abstract.SelfNotImplemented;
subclass_event.Once = main.Abstract.SelfNotImplemented;
subclass_event.ConnectParallel = main.Abstract.SelfNotImplemented;
subclass_event.OnceParallel = main.Abstract.SelfNotImplemented;
subclass_event.Wait = main.Abstract.SelfNotImplemented;

subclass_event.IsAlive = nil;
subclass_event.DoAfterEventDie = nil;

interface.class = class_properties;
interface.subclass = subclass_event;
interface.new = private.new_event_properties;

return main:expand({HxEvent = interface})
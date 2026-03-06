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
type DefaultFunction = (...any)->()
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

function private:call_properties (...)
	local self = self :: HxEventProperties
	for i,v in self.Listeners do
		local this = v();
		
		if this.Run == 'Serial' then
			--coroutine.resume(coroutine.create(this.Func),...)
			task.spawn(function (...) this.Connection.Output = this.Func(...) end, ...)
		elseif this.Run == 'Parallel' then
			task.spawn(function (...) task.desynchronize() this.Connection.Output = this.Func(...) end,...)
		else
			warn('Invalid Connection RunType', this.Run)
			self:RemListener(v)
			continue
		end
		
		if this.Type == 'Once' then
			self:RemListener(v)
		end
	end
end

function private.new_event <T, Signa> (Properties: SelfDefF<Signa>, Name: T)
	local this = {}
	local labmda : HxEvent

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
	
	function this:WatchDeath (Function: (HxEvent: HxEvent)->())
		local nolint_Properties = Properties :: HxEventProperties
		local emitter = nolint_Properties.EventsWatchers[labmda]
		emitter:AddListener(Function)
		-- Removes the function from the event.
		return function ()
			emitter:RemListener(Function)
		end
	end
	
	this.Alive = true;
	this.Name = Name;
	
	function this:Wait () : ...unknown
		local thread = coroutine.running()
		this:Once(function ()
			return coroutine.resume(thread)
		end)
		return coroutine.yield()
	end
	
	local result = main.new(this, subclass_event)
	labmda = result
	return result
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
	
	table.freeze(this)
	
	return Connection;
end



function private.new_event_properties <U, T> (DefaultFunction: T|DefaultFunction?, Name: U|Name?)
	local raw = {}
	raw.EventsWatchers = setmetatable({}, private.mk);
	raw.Name = Name :: U;
	raw.Alive = true;
	raw.DefaultFunction = DefaultFunction :: T;
	
	local this = main.new(raw, class_properties)
	return this
end


function private.create_event <T> (self: SelfDefF<T>)
	local Event = private.new_event(self, self.Name);
	local self = self :: HxEventProperties;
	
	local HxActionEmitter = main.HxActionEmitter.new();
	HxActionEmitter.OnceAction = true;
	
	self.EventsWatchers[Event] = HxActionEmitter;
	return Event
end


function private:destroy_event (HxEvent)
	local self = self :: HxEventProperties;
	local HxEvent = assert(self.IsA(HxEvent, 'HxEvent'), 'Invalid HxEvent') and HxEvent :: HxEvent;
	local Event = self.EventsWatchers[HxEvent];
	if Event then
		HxEvent.Alive = false;
		table.freeze(HxEvent)
		Event:Process(HxEvent)
		self.EventsWatchers[HxEvent] = nil;
	else
		if game["Run Service"]:IsStudio() then
			warn('HxEventProperties does not have received HxEvent \n', debug.traceback())
		end
	end
end

function private:clear_listeners ()
	local self = self :: HxEventProperties;
	for i,v in self.Listeners do
		local this = v();
		this.Connection:Disconnect()
	end
	class_properties.__index.ClearListeners(self)
end

function private:destroy_properties ()
	local self = self :: HxEventProperties;
	for i,v in self.EventsWatchers do
		self:RemEvent(i);
	end
	
	print(self.EventsWatchers)
	table.clear(self.EventsWatchers)
	
	self.Alive = false
	self:ClearListeners()
	
	table.freeze(self)
	table.freeze(self.Listeners)
	table.freeze(self.EventsWatchers)
end


class_properties.__index = main.HxActionEmitter.class;
class_properties.ClassName = main.ClassNames.HxEvent;
class_properties.Source = script;
class_properties.Listeners = {} :: {Listener};
class_properties.EventsWatchers = setmetatable({} :: {[HxEvent]: HxActionEmitter}, private.mk);
class_properties.DefaultFunction = warn :: DefaultFunction;
class_properties.Name = '' :: Name;
class_properties.Alive = false;
class_properties.AddEvent = private.create_event;
class_properties.RemEvent = private.destroy_event;
class_properties.DoCall = private.call_properties;
class_properties.Destroy = private.destroy_properties; 
class_properties.ClearListeners = private.clear_listeners;

subclass_event.__index = main.__HxBaseProperty.class;
subclass_event.ClassName = main.ClassNames.HxEvent;
subclass_event.Source = script;

subclass_event.Connect = main.Abstract.SelfNotImplemented;
subclass_event.Once = main.Abstract.SelfNotImplemented;
subclass_event.ConnectParallel = main.Abstract.SelfNotImplemented;
subclass_event.OnceParallel = main.Abstract.SelfNotImplemented;
subclass_event.Wait = main.Abstract.SelfNotImplemented;

subclass_event.Alive = false;
subclass_event.WatchDeath = main.Abstract.SelfNotImplemented;

interface.class = class_properties;
interface.subclass = subclass_event;
interface.new = private.new_event_properties;


table.freeze(class_properties)
table.freeze(subclass_event)
table.freeze(interface)
table.freeze(private)

return main:expand({HxEvent = interface})
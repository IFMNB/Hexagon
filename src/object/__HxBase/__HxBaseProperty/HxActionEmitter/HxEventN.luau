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
type Connect = (Function: F)->HxEventConnection

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

function private.new_event (Properties: HxEventProperties, Name: Name)
	return main.new({
		
	}, subclass_event)
end

function private:connect (Properties: HxEventProperties, Function: F, ConType: ConType, RunType: RunType)
	local self = self :: HxEvent;
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





function private.new_event_properties (Name: Name?, DefaultFunction: DefaultFunction?)
	local raw = {}
	raw.EventsWatchers = setmetatable({}, private.mk);

	
	local this = main.new(raw, class_properties)
	return this
end

function private:create_event ()
	local self = self :: HxEventProperties;
	local Event = private.new_event(self, self.Name);
	self.EventsWatchers[Event] = main.HxActionEmitter.new();
	return Event
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

subclass_event.__index = main.__HxBaseProperty.class;
subclass_event.ClassName = main.ClassNames.HxEvent;
subclass_event.Source = script;

subclass_event.Connect = main.Abstract.NotImplemented :: Connect;
subclass_event.Once = main.Abstract.NotImplemented :: Connect;
subclass_event.ConnectParallel = main.Abstract.NotImplemented :: Connect;
subclass_event.OnceParallel = main.Abstract.NotImplemented :: Connect;
subclass_event.Wait = main.Abstract.NotImplemented :: Connect;

subclass_event.IsAlive = nil;
subclass_event.DoAfterEventDie = nil;

interface.class = class_properties;
interface.subclass = subclass_event;
interface.new = private.new_event_properties;

return main:expand({HxEvent = interface})
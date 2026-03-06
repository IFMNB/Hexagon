local main = require('./');

local private = {};
local class = {}; setmetatable(class,class);
local interface = {};

type HxConnection = typeof(require('./HxConnection').HxConnection.new())
type ConType = 'Connection'|'Once'
type RunType = 'Parallel'|'Serial'
type DefaultFunction = (...any)->()
type FReactor = (DefaultFunction: DefaultFunction, ConnectionType: ConType, RunType: RunType)->HxConnection
type HxEvent <Reacor_ = FReactor> = typeof(private.new(nil::Reacor_))
type DeadWatch = (HxEvent: HxEvent)->()

function private.new <T,U> (Reactor: FReactor, DefaultFunction: T|DefaultFunction?, Name: U?)
	local this = {}
	local labmda : HxEvent
	local watchers = {} :: {DeadWatch}
	local alive = true
	
	this.DefaultFunction = DefaultFunction or warn :: T
	
	function this:Connect (Function: T?)
		return alive and Reactor(Function or this.DefaultFunction, 'Connection', 'Serial') or error('Event is dead')
	end
	
	function this:Once (Function: T?)
		return alive and Reactor(Function or this.DefaultFunction, 'Once', 'Serial') or error('Event is dead')
	end
	
	function this:ConnectParallel (Function: T?)
		return alive and Reactor(Function or this.DefaultFunction, 'Connection', 'Parallel') or error('Event is dead')
	end
	
	function this:OnceParallel (Function: T?)
		return alive and Reactor(Function or this.DefaultFunction, 'Once', 'Parallel') or error('Event is dead')
	end
	
	function this:WatchDeath (Function: (HxEvent: HxEvent)->())
		if not alive then error('Event is dead') end
		
		table.insert(watchers,Function)
		
		-- Removes the function from the event.
		return function ()
			table.remove(watchers, table.find(watchers,Function))
		end
	end
	
	
	this.Alive = alive;
	this.Name = Name;
	
	function this:Wait () : ...unknown
		local thread = coroutine.running()
		this:Once(function ()
			return coroutine.resume(thread)
		end)
		return coroutine.yield()
	end
	
	local result = main.new(this, class)
	labmda = result
	return result, function ()
		alive = nil;
		this.Alive = false;
		table.freeze(this);
		for i,v in watchers do
			task.spawn(v, result)
		end
		watchers = nil
	end
end

class.__index = main.__HxBase.class;
class.ClassName = main.ClassNames.HxEvent;
class.Source = script;
class.DefaultFunction = warn :: DefaultFunction;
class.Connect = main.Abstract.SelfNotImplemented;
class.Once = main.Abstract.SelfNotImplemented;
class.ConnectParallel = main.Abstract.SelfNotImplemented;
class.OnceParallel = main.Abstract.SelfNotImplemented;
class.WatchDeath = main.Abstract.SelfNotImplemented;
class.Wait = main.Abstract.SelfNotImplemented;

interface.class = class;
interface.new = private.new;

return main:expand({HxEvent = interface})
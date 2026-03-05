local main = require('./')

local private = {};
local class = {}; setmetatable(class,class);
local interface = {};

type F = (...any)->()|any
type HxActionEmitter = typeof(interface.new())
-- Create new HxActionEmitter object.
function private.new ()
	return main.new({
		Listeners = {} :: typeof(class.Listeners);
		OnceAction = false;
	},class)
end
-- Add listener.
function private:add_listener (Listener: F)
	local self = self :: HxActionEmitter
	table.insert(self.Listeners,Listener)
	return self
end
-- Remove listener.
function private:rem_listener (Listener: F)
	local self = self :: HxActionEmitter
	local index = table.find(self.Listeners,Listener)
	if index then table.remove(self.Listeners,index) end
	return self
end
-- Clear all listeners.
function private:clear_listeners ()
	local self = self :: HxActionEmitter;
	table.clear(self.Listeners)
end

-- Emit event to all listeners.
function private:process (...: any)
	local self = self :: HxActionEmitter
	for i,v in self.Listeners do
		task.spawn(v, ...)
	end
	if self.OnceAction then
		table.clear(self.Listeners)
	end
	return self
end

class.__index = main.__HxBaseProperty.class;
class.ClassName = main.ClassNames.HxActionEmmiter;
class.Source=script;
class.Listeners = {} :: {F};

class.AddListener = private.add_listener;
class.RemListener = private.rem_listener;
class.ClearListeners = private.clear_listeners;

class.Process = private.process;
class.OnceAction = false;

interface.class = class;
interface.new = private.new;

return main:expand({HxActionEmitter=interface})
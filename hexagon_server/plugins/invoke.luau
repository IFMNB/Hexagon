--!strict

local private = {}
local public = {}

private.debugname = script.Parent.Name..'_'..script.Name..'.'
private.time = 6
private.coroutine_fail = private.debugname..'coroutine_fail'





function private.doInvokeClient (Event: RemoteEvent, player: Player, ...: any)
	local this = coroutine.running()
	local current
	
	current = task.spawn(function()
		local event, received, act
		event = Event.OnServerEvent:Connect(function(plr: Player, ...: any)
			if player == plr then
				(event::RBXScriptConnection):Disconnect()
				received = ...
				act = true
				
				coroutine.resume(this, received)
				coroutine.close(current::thread)
			end
		end)
		
		task.wait(private.time)
		
		if not act then
			event:Disconnect()
			coroutine.resume(this, private.coroutine_fail)
		end
	end)
	
	
	Event:FireClient(player, ...)
	local received = coroutine.yield()

	
	return received
end

function private.doInvokeClients (Event: RemoteEvent, Clients: {Player}, ...: any)
	debug.profilebegin(private.debugname..'InvokeClients')
	
	local this = coroutine.running()
	local result = {}
	local fail = {}
	
	for i=1, #Clients do
		task.spawn(function(...: any)
			debug.profilebegin(private.debugname..'InvokeManage')
			
			local player = Clients[i]
			
			local received = private.doInvokeClient(Event, player, ...)
			if received == private.coroutine_fail then
				table.insert(fail, player)
			else
				result[player] = received
			end
			
			if i == #Clients then
				coroutine.resume(this)
			end
			debug.profileend()
		end, ...)
	end
	
	coroutine.yield()
	debug.profileend()
	
	return result, fail
end

function private.doInvokeAll (self: RemoteEvent, ...: any)
	return private.doInvokeClients(self, game.Players:GetPlayers(), ...)
end










function public.InvokeClient (self: Player, Event: RemoteEvent, ...: any)
	return private.doInvokeClient(Event, self, ...)
end

function public.InvokeList (self: {Player}, Event: RemoteEvent, ...: any)
	return private.doInvokeClients(Event, self, ...)
end

function public.InvokeAll (self: RemoteEvent, ...: any)
	return private.doInvokeAll(self, ...)
end




public.ErrorCode = private.coroutine_fail




export type ancestors = self
export type self = typeof(public)

return public
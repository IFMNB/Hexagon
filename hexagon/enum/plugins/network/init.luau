--!strict

assert(not game["Run Service"]:IsServer(), 'server cant use this api')

local private = {}
local plugin = {}
local path = script

plugin.PathToRemote = path

private.error = 'ping-pong fail' :: 'ping-pong fail'

function private.DoRequestPingToPlayer (to: Player)
	local request = os.clock()
	local is, result = pcall(function ()
		return path.Ping:InvokeServer(to)
	end)
	
	return is and result-request or private.error
end

function private.DoRequestPing ()
	local request = os.clock()
	local is, result = pcall(function(...) 
		return path.Ping:InvokeServer()
	end)
	
	return is and result-request or private.error
end








-- Возвращает результат сетевого запроса между клиентом и сервером.
function plugin.GetPing ()
	return private.DoRequestPing()
end
-- Возвращает время между сетевыми запросами от клиента до сервера, а затем к цели и обратно.
function plugin.GetPlayerPing (to: Player) 
	return private.DoRequestPingToPlayer(to)
end

export type ancestors = self
export type self = typeof(plugin)


return plugin
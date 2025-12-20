--!strict

local enum = require('../')

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

function private.DoOnlyInClient (func: (...any)->()|any?, ...: any) : any
	assert(not game["Run Service"]:IsServer(), 'server cant use this api')
	return func(...)
end







-- Returns ping between server and client
function private.GetPing ()
	return private.DoOnlyInClient(private.DoRequestPing)
end
-- Returns ping between two players
function private.GetPlayerPing (to: Player) 
	return private.DoOnlyInClient(private.DoRequestPingToPlayer,to)
end

plugin.GetPing = private.GetPing
plugin.GetPlayerPing = private.GetPlayerPing

export type ancestors = self
export type self = typeof(plugin)


return plugin
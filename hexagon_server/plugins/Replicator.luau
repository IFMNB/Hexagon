--!strict

local replica = require('../replica_link')
local enum = replica.GetEnums()

local private = {}
local public = {}

private.playerlist = {}

function private.Name (pl: Player)
	return tostring(pl.UserId)
end

function private.Assertion (pl: Player, path: Instance, p2: Instance?)
	local msg = tostring(enum.Error.Forbidden)
	assert(not path:FindFirstChild(tostring(pl.UserId)),msg)
	assert(p2 and path:IsDescendantOf(p2) or true,msg)
end

function private.NewEvent (pl: Player, path: Instance,p2: Instance?, type: 'RemoteEvent'|'UnreliableRemoteEvent')
	private.Assertion(pl,path,p2)
	
	local event = Instance.new(type)
	event.Parent = path
	event.Name = private.Name(pl)
	

	
	game.Players.PlayerRemoving:Connect(function(player: Player, reason: Enum.PlayerExitReason) 
		if pl==player then
			event:Destroy()
		end
	end)
	
	return event
end

function private.SearchEvent (player: Player, path: Instance)
	local name = private.Name(player)
	return path:FindFirstChild(name) or assert(path:WaitForChild(name,5),tostring(enum.Error.Reset))
end


-- Creates a remote event for the player at the specified location. Can additionally check that the specified location belongs to a specific object.
function public.Create (player: Player, path: Instance, DescendatOf: Instance?) : RemoteEvent
	return private.NewEvent(player,path,DescendatOf, 'RemoteEvent')
end
-- Creates a remote event for the player at the specified location, given that the specified location is a descendant of the Hexagon library.
function public.ProtectedCreate (player: Player, path: Instance) : RemoteEvent
	return public.Create(player,path,replica.Path)
end
-- Creates an unreliable remote event for the player at the specified location. Can additionally check that the specified location belongs to a specific 
function public.CreateUnreliable (player: Player, path: Instance, DescendatOf: Instance?) : UnreliableRemoteEvent
	return private.NewEvent(player,path,DescendatOf,'UnreliableRemoteEvent')
end
-- Creates an unreliable remote event for the player at the specified location, given that the specified location is a descendant of the Hexagon library.
function public.ProtectedCreateUnreliable (player: Player, path: Instance) : UnreliableRemoteEvent
	return public.CreateUnreliable(player, path, replica.Path)
end
-- Returns the remote event for the player at the specified location. Waits for the remote event to be created if it does not exist.
function public.GetEvent (player: Player, fromPath: Instance) : RemoteEvent
	return private.SearchEvent(player, fromPath) :: any
end

return public
local main = require('./')

-- why this is not equal to HxLocalEnum?


local private = {};
local class = {};
class.__index = main.LocalEnum.class;
setmetatable(class,class);
local interface = {};
interface.class=class;

type HxEnum = typeof(interface.new(''))
local Event : RemoteEvent

private.c = -1
private.all = {} :: {[string]: HxEnum}

-- This object automatically replicates from server to client.
function private.new <t0> (identity: t0)
	assert(game:GetService('RunService'):IsServer(), 'cannot create new enum on client')
	assert(not main.LocalEnum.get(identity), `enum "{identity}" already exists`)
	
	private.c+=1
	
	local this = main.new({}, class)
	this.EnumName = identity
	this.RegValue = private.c
	
	private.all[this.EnumName]=this
	Event:FireAllClients(this)
	return this
end

function private.get <t0> (identity: t0) : HxEnum?
	return private.all[identity]
end

class.ClassName=main.ClassNames.HxEnum
class.Source = script
class.Replicatable=true::true

interface.new = ( game:GetService('RunService'):IsServer() and private.new or error ) :: typeof(private.new)
interface.get = private.get
table.freeze(class)
table.freeze(interface)
table.freeze(private)

if game:GetService('RunService'):IsClient() then
	Event = assert(script:FindFirstChildOfClass('RemoteEvent'), 'no remote event')
	Event.OnClientEvent:Connect(function(data: typeof(class))
		private.all[data.EnumName]= (main.new(data,class)::any)::HxEnum
	end)
	Event:FireServer()
else
	Event = Instance.new 'RemoteEvent'
	Event.Parent = script
	Event.OnServerEvent:Connect(function(player: Player) 
		for i,v in private.all do
			Event:FireClient(player, v)
		end
	end)
end

return main:expand({Enum=interface})
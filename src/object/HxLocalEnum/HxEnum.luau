local main = require('./')

local private = {};
local class = {};
class.__index = main.LocalEnum.class;
setmetatable(class,class);
local interface = {};
interface.class=class;

type HxEnum = typeof(interface.new())

if game:GetService('RunService'):IsClient() then
	script.AutoReplicator.OnClientEvent:Connect(function(data: string) 
		private.all[data]=main.LocalEnum.new(data)
	end)
else
	script.AutoReplicator.OnServerEvent:Connect(function(player: Player) 
		for i,v in private.all do
			script.AutoReplicator:FireClient(player, v.EnumName)
		end
	end)
end

private.all = {} :: {[string]: HxEnum}
if game:GetService('RunService'):IsClient() then script.AutoReplicator:FireServer() end

-- This object automatically replicates from server to client.
function private.new <t0> (identity: t0?)
	assert(game:GetService('RunService'):IsServer(), 'HxEnum cannot be created on the client')
	if identity then assert(not main.LocalEnum.get(identity), `enum "{identity}" already exists`) end
	
	local this = main.LocalEnum.new(identity)
	this.ClassName = main.ClassNames.HxEnum
	private.all[this.EnumName]=this
	script.AutoReplicator:FireAllClients(this)
	return this
end

function private.get <t0> (identity: t0) : HxEnum?
	return private.all[identity]
end

class.ClassName=main.ClassNames.HxEnum
class.Source = script
class.Replicatable=true::true
interface.new = private.new 
interface.get = private.get
table.freeze(class)
table.freeze(interface)
table.freeze(private)
return main:expand({Enum=interface})
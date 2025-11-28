--!strict

local main = require('./')
local arch = main :: main.ancestors

local debris = game:GetService('Debris')

local obj = arch.GetObject()
local ent = main.GetClass()
local enum = arch.Enum()
local plugin = arch.GetPluginProvider()

local oop = plugin.GetOOP()
local imp = plugin.GetImported()
local shad = plugin.GetShadow()
local rbxl = world.GetRobloxLink().GetClass()
local lnk = plugin.GetLinker()

local private = {}
local public = {}
local class = {}
local root = {}



function private.DoWork (self: TrailClone)
	return coroutine.create(function ()
		local shadow : Shadow = shad.Get(self)
		
		local target = self.At:GetRobloxInstance() :: CanPlayAt?
		if not target then self.State = enum.State.Dead; coroutine.close(coroutine.running()) return end
		local clone : CanPlayAt = target:Clone()
		local list = clone:GetDescendants()
		
		for i=1, #list do
			local this : Instance = list[i]
			if this:IsA('BasePart') then
				this.Anchored = true
				this.CanCollide = false
				this.CanQuery = false
				this.CanTouch = false
				this.CastShadow = false
			elseif this:IsA('Humanoid') then
				this:Destroy()
			end
		end
		
		
		clone.Destroying:Once(function() shadow._clones -=1 end)
		shadow._clones += 1
		debris:AddItem(clone, shadow.Lifetime)
		clone.Parent = target.Parent
	end)
end

function private.DoIdle (self: TrailClone)
	self.State = enum.State.Idle
	local sh : Shadow = shad.Get(self)
	sh._task = false
	return
end

function private.CreateNewInstance (at: CanPlayAt) : TrailClone
	local Data = {} :: Data
	Data.State = enum.State.Pause
	Data.At = rbxl.New(at)
	
	local entity = ent.New(oop.Expanding(Data, public))
	local shadow = {} :: Shadow
	shadow._coroutine = coroutine.create(private.DoWork)
	shadow._task = false
	shadow._clones = 0
	shadow.MaxCount = 1
	shadow.Timeout = 1
	shadow.Lifetime = 1
	
	local shadow = shad.New(entity, ent.New(shadow))
	shadow.ChangedSignal:Connect(function(self: Shadow, index, newindex, oldindex) 
		if self._clones > self.MaxCount then
			if entity.State ~= enum.State.Pause then
				private.DoIdle(entity)
			end
		else
			
		end
	end)
	
	return entity
end

function private.DoPlayTrail (self: TrailClone)
	local shadow : Shadow = shad.Get(self)
	shadow._task = true
	self.State = enum.State.Run
	coroutine.resume(shadow._coroutine, self)
	return self
end

function private.DoStopPlayTrail (self: TrailClone)
	local shadow : Shadow = shad.Get(self)
	shadow._task = false
	self.State = enum.State.Pause
	return self
end

function private.DoSet(self: TrailClone, at: keyof<CanSet>, to: number)
	local shadow : Shadow = shad.Get(self)
	shadow[at]=to
	return self
end







function public:Play ()
	return private.DoPlayTrail(self)
end

function public:Stop ()
	return private.DoStopPlayTrail(self)
end

function public:Set(at: keyof<CanSet>, to: number)
	return private.DoSet(self,at,to)
end


function class.New (at: CanPlayAt)
	return private.CreateNewInstance(at)	
end


type CanPlayAt = Model | BasePart
type RobloxLink = typeof(rbxl.New(Instance.new('Model')))

type Shadow = typeof(ent.New({}::{
	_coroutine: thread,
	_task: boolean,
	_clones: number
})) & CanSet
type CanSet = {
	Timeout: number,
	MaxCount: number,
	Lifetime: number
}
type Data = {
	State: typeof(enum.State.Run)|typeof(enum.State.Pause)|typeof(enum.State.Dead)|typeof(enum.State.Idle),
	At: RobloxLink
} & public
export type TrailClone = typeof(ent.New({}::Data))


export type ancestors = root & main.ancestors
export type root = typeof(root)
export type public = typeof(public)
export type self = typeof(class)


-- Класс был дропнут от разработки в период более важных задач.
@deprecated
function root.GetClass () return class end
return root
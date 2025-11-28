--!strict

local main = require('../')
local arch = main :: main.ancestors
local plugin = arch.GetPluginProvider()

local enum = arch.Enum()
local obj = main.GetObject()
local oop = plugin.GetOOP()
local lnk = plugin.GetLinker()
local shadow = plugin.GetShadow()
local mt = plugin.GetMeta()

local private = {}
local public = {}
local class = {}
local root = {}

private.HookClassName = 'Hook' :: 'Hook'
private.HookParamsClassName  = 'HookParams' :: 'HookParams'
private.Meta = {}
private.Meta.__metatable = 'Hook'

type selfHook = {}

@native
function private.Meta .__index (self: selfHook, i: any) : any?
	local shadeHook : ShadeHook = shadow.Get(self)
	local shadeParams : ShadeParams = shadow.Get(shadeHook._params)
	local result : any
	
	if private.ParamsDoVerifyState(shadeHook._params) and private.ParamsDoVerifyMod(shadeHook._params, enum.Metamethode.Index) then
		private.ParamsDoCall(shadeHook._params, shadeHook._at, i, nil, nil)
	end
	
	result = shadeHook._at[i]
	
	assert(shadeHook._at, tostring(enum.Error.GarbageCollected))
	return result
end

@native
function private.Meta .__newindex (self: selfHook, i: any, n: any) : ()
	local shadeHook : ShadeHook = shadow.Get(self)
	local shadeParams : ShadeParams = shadow.Get(shadeHook._params)
	
	assert(shadeHook._at, tostring(enum.Error.GarbageCollected))
	local old = shadeHook._at[i]
	shadeHook._at[i]=n
	
	if private.ParamsDoVerifyState(shadeHook._params) and private.ParamsDoVerifyMod(shadeHook._params, enum.Metamethode.NewIndex) then
		private.ParamsDoCall(shadeHook._params, shadeHook._at, i, n, old)
	end
	
end

@native
function private.Meta .__call (self: selfHook, ...: any) : any?
	local shadeHook : ShadeHook = shadow.Get(self)
	local shadeParams : ShadeParams = shadow.Get(shadeHook._params)
	local result : any
	
	assert(shadeHook._at, tostring(enum.Error.GarbageCollected))
	result = (shadeHook._at::any)(...)
	
	if private.ParamsDoVerifyState(shadeHook._params) and private.ParamsDoVerifyMod(shadeHook._params, enum.Metamethode.Call) then
		private.ParamsDoCall(shadeHook._params, shadeHook._at, ...)
	end
	
	
	return result
end






function private.ParamsDoVerifyState (self: HookParams)
	return (shadow.Get(self)::ShadeParams)._state == enum.State.Run
end
function private.ParamsDoVerifyMod (self: HookParams, enum: metamodify)
	return (shadow.Get(self)::ShadeParams)._modify == enum
end
function private.ParamsDoCall (self: HookParams, ...: any)
	(shadow.Get(self)::ShadeParams)._react(...)
end











function private.CreateParams (reactor: func, modify: metamodify) : HookParams
	local object = obj.New(oop.Expanding({}::public, public), private.HookParamsClassName)
	local shade : ShadeParams = shadow.New(object)	
	shade._state = enum.State.Pause
	shade._react = reactor
	shade._modify = modify
	
	return object
end

function private.CreateHook <t0> (at: t0, params: HookParams) : Hook<t0>
	local hook = {}
	--local object = obj.New(hook::t0, private.HookClassName)
	
	local shade : ShadeHook = shadow.New(hook, mt.SetMode({},'v'))
	shade._at = at
	shade._params = params

	lnk.Link(hook, params)
	setmetatable(hook, private.Meta )

		
	return hook
end













function private.ResumeParams (self: HookParams)
	local shade : ShadeParams = shadow.Get(self)
	shade._state = enum.State.Run
	return self
end

function private.PauseParams (self: HookParams)
	local shade : ShadeParams = shadow.Get(self)
	shade._state = enum.State.Pause
	return self
end




-- Resuming operation of parameters. Does not affect proxy operation.
function public:Resume ()
	return private.ResumeParams(self)
end
-- Pause of parameters operation. Does not affect proxy operation.
function public:Pause ()
	return private.PauseParams(self)
end
-- Creates a react instance that calls the passed function when the event specified in the modification mode occurs.
function public:Create <t0> (at: t0) : Hook<t0>
	return private.CreateHook(at, self)
end



-- Creates an instance of the class. Accepts a reactor (a function that is called when an event occurs) and a modification mode (the type of event that triggers the reactor).
function class.New (reactor: func, modify: metamodify) : HookParams
	return private.CreateParams(reactor, modify)
end


type metamodify = typeof(enum.Metamethode.Index)|typeof(enum.Metamethode.NewIndex)|typeof(enum.Metamethode.Call)
type func = (self: {[any]:any}, ...any)->()

type ShadeHook = typeof(mt.SetMode({}::{
	_at: {[any]:any},
	_params: HookParams
},'v'))
type ShadeParams = {
	_state: typeof(enum.State.Run)|typeof(enum.State.Pause),
	_react: func,
	_modify: metamodify
}

export type Hook <t0> = --[[typeof(obj.New({}, private.HookClassName))&]]t0
export type HookParams = typeof(obj.New({}::public, private.HookParamsClassName))

export type ancestors = root & main.ancestors
export type public = typeof(public)
export type root = typeof(root)
export type self = typeof(class)

-- The HookParams class provides tools for creating proxy reactants.
function root.GetClass () return class end
oop.Expanding(root,arch)
return root
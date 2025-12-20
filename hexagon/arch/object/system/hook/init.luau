--!strict
--!optimize 0

local main = require('../')
local plugin = main.GetPluginProvider()

local enum = main.Enum()
local obj = main.GetObject()
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
private.hpm = {__index=public, __metatable=enum.Error.Forbidden.Name}

@native
function private.Meta .__index <t0,t1> (self: t0, i: t1) : any
	debug.profilebegin(script.Name..' .__index')
	
	local shadeHook : ShadeHook = shadow.Get(self)
	local shadeParams : ShadeParams = shadow.Get(shadeHook._params)
	local result : any
	
	if private.ParamsDoVerifyState(shadeHook._params) and private.ParamsDoVerifyMod(shadeHook._params, enum.Metamethode.Index) then
		debug.profilebegin(script.Name..' .__index .ParamsDoCall')
		private.ParamsDoCall(shadeHook._params, shadeHook._at, i, nil, nil)
		debug.profileend()
	end
	
	result = shadeHook._at[i]
	
	assert(shadeHook._at, tostring(enum.Error.GarbageCollected))
	debug.profileend()
	return result
end

@native
function private.Meta .__newindex <t0,t1,t2> (self: t0, i: t1, n: t2) : ()
	debug.profilebegin(script.Name..' .__newindex')
	
	local shadeHook : ShadeHook = shadow.Get(self)
	local shadeParams : ShadeParams = shadow.Get(shadeHook._params)
	
	assert(shadeHook._at, tostring(enum.Error.GarbageCollected))
	local old = shadeHook._at[i]
	shadeHook._at[i]=n
	
	if private.ParamsDoVerifyState(shadeHook._params) and private.ParamsDoVerifyMod(shadeHook._params, enum.Metamethode.NewIndex) then
		debug.profilebegin(script.Name..' .__newindex .ParamsDoCall')
		private.ParamsDoCall(shadeHook._params, shadeHook._at, i, n, old, self)
		debug.profileend()
	end
	
	debug.profileend()
end

@native
function private.Meta .__call <t0,t1> (self: t0, ...: any) : any?
	debug.profilebegin(script.Name..' .__call')
	
	local shadeHook : ShadeHook = shadow.Get(self)
	local shadeParams : ShadeParams = shadow.Get(shadeHook._params)
	local result : any
	
	assert(shadeHook._at, tostring(enum.Error.GarbageCollected))
	result = (shadeHook._at::any)(...)
	
	if private.ParamsDoVerifyState(shadeHook._params) and private.ParamsDoVerifyMod(shadeHook._params, enum.Metamethode.Call) then
		debug.profilebegin(script.Name..' .__call .ParamsDoCall')
		private.ParamsDoCall(shadeHook._params, shadeHook._at, ...)
		debug.profileend()
	end
	
	
	debug.profileend()
	return result
end

private.Meta.__metatable = enum.Error.Forbidden.Name





function private.ParamsDoVerifyState (self: HookParams)
	return (shadow.Get(self)::ShadeParams)._state == enum.State.Run
end
function private.ParamsDoVerifyMod (self: HookParams, enum: metamodify)
	return (shadow.Get(self)::ShadeParams)._modify == enum
end
function private.ParamsDoCall (self: HookParams, ...: any)
	(shadow.Get(self)::ShadeParams)._react(...)
end










-- Creates an instance of the class. Accepts a reactor (a function that is called when an event occurs) and a modification mode (the type of event that triggers the reactor).
function private.CreateParams (reactor: func, modify: metamodify)
	debug.profilebegin(script.Name..' .CreateParams')
	
	local object = obj.New(setmetatable({},private.hpm), private.HookParamsClassName)
	local shade : ShadeParams = shadow.New(object)	
	shade._state = enum.State.Pause
	shade._react = reactor
	shade._modify = modify
	
	debug.profileend()
	return object
end
-- Creates a react instance that calls the passed function when the event specified in the modification mode occurs.
function private:CreateHook <t0> (at: t0)
	debug.profilebegin(script.Name..' .CreateHook')
	
	local hook = {} :: t0
	local shade : ShadeHook = shadow.New(hook, mt.SetMode({},'v'))
	shade._at = at
	shade._params = self

	lnk.Link(hook, self)
	setmetatable(hook, private.Meta)

	debug.profileend()
	return hook
end












-- Resuming operation of parameters. Does not affect proxy operation.
function private:ResumeParams ()
	local shade : ShadeParams = shadow.Get(self)
	shade._state = enum.State.Run
end
-- Pause of parameters operation. Does not affect proxy operation.
function private:PauseParams ()
	local shade : ShadeParams = shadow.Get(self)
	shade._state = enum.State.Pause
end


public.Resume = private.ResumeParams
public.Pause = private.PauseParams
public.Create = private.CreateHook
class.New = private.CreateParams
table.freeze(public)
table.freeze(class)

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
type HookParams = typeof(private.CreateParams((nil::any)::func, (nil::any)::metamodify))--typeof(obj.New({}::public, private.HookParamsClassName))
type inject = {
	_TypeCheck: {
		HookParamsSignature: HookParams,
		Public: typeof(public),
		ShadeForParams: ShadeParams,
		ShadeForHook: ShadeHook,
		ExpectedFunction: func,
		ExpectedMetamodify: metamodify
	}
}

-- The HookParams class provides tools for creating proxy reactants.

return table.freeze(setmetatable({
	GetHook = function ()
		return class :: typeof(class) & inject
	end,
},{__index=main}))
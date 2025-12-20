--!strict
--!optimize 0

local main = require('./')
local plugin = require('./plugin')

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
private.hpm = {__index=public, __metatable='forbidden'}

@native
function private.Meta .__index <t0,t1> (self: t0, i: t1) : any
	debug.profilebegin(script.Name..' .__index')
	
	local shadeHook : ShadeHook = shadow.Get(self)
	local shadeParams : ShadeParams = shadow.Get(shadeHook._params)
	local result : any
	
	if shadeParams._signalbehavior then
		if shadeParams._signalbehavior == 'before' then
			result = shadeHook._at[i]
		end
	else
		result = shadeHook._at[i]
	end
	
	if private.ParamsDoVerifyState(shadeHook._params) and private.ParamsDoVerifyMod(shadeHook._params, 'index') then
		debug.profilebegin(script.Name..' .__index .ParamsDoCall')
		private.ParamsDoCall(shadeHook._params, shadeHook._at, i, nil, nil)
		debug.profileend()
	end
	
	if shadeParams._signalbehavior then
		if shadeParams._signalbehavior == 'after' then
			result = shadeHook._at[i]
		end
	end
	
	assert(shadeHook._at, '_GC error')
	debug.profileend()
	return result
end

@native
function private.Meta .__newindex <t0,t1,t2> (self: t0, i: t1, n: t2) : ()
	debug.profilebegin(script.Name..' .__newindex')
	
	local shadeHook : ShadeHook = shadow.Get(self)
	local shadeParams : ShadeParams = shadow.Get(shadeHook._params)
	
	assert(shadeHook._at,  '_GC error')
	local old = shadeHook._at[i]
	
	if shadeParams._signalbehavior then
		if shadeParams._signalbehavior == 'before' then
			shadeHook._at[i]=n
		end
	else
		shadeHook._at[i]=n
	end
	
	
	if private.ParamsDoVerifyState(shadeHook._params) and private.ParamsDoVerifyMod(shadeHook._params, 'newindex') then
		debug.profilebegin(script.Name..' .__newindex .ParamsDoCall')
		private.ParamsDoCall(shadeHook._params, shadeHook._at, i, n, old, self)
		debug.profileend()
	end
	
	if shadeParams._signalbehavior then
		if shadeParams._signalbehavior == 'after' then
			shadeHook._at[i]=n
		end
	end
	
	debug.profileend()
end

@native
function private.Meta .__call <t0,t1> (self: t0, ...: any) : any?
	debug.profilebegin(script.Name..' .__call')
	
	local shadeHook : ShadeHook = shadow.Get(self)
	local shadeParams : ShadeParams = shadow.Get(shadeHook._params)
	local result : any
	
	assert(shadeHook._at,'_Gc error')
	
	if shadeParams._signalbehavior then
		if shadeParams._signalbehavior == 'before' then
			result = (shadeHook._at::any)(...)
		end
	else
		result = (shadeHook._at::any)(...)
	end
	
	if private.ParamsDoVerifyState(shadeHook._params) and private.ParamsDoVerifyMod(shadeHook._params, 'call') then
		debug.profilebegin(script.Name..' .__call .ParamsDoCall')
		private.ParamsDoCall(shadeHook._params, shadeHook._at, ...)
		debug.profileend()
	end
	
	if shadeParams._signalbehavior then
		if shadeParams._signalbehavior == 'after' then
			result = (shadeHook._at::any)(...)
		end
	end
	
	
	debug.profileend()
	return result
end

private.Meta.__metatable = 'forbidden'





function private.ParamsDoVerifyState (self: HookParams)
	return (shadow.Get(self)::ShadeParams)._state == 'run'
end
function private.ParamsDoVerifyMod (self: HookParams, enum: metamodify)
	return (shadow.Get(self)::ShadeParams)._modify == enum
end
function private.ParamsDoCall (self: HookParams, ...: any)
	(shadow.Get(self)::ShadeParams)._react(...)
end










-- Creates an instance of the class. Accepts a reactor (a function that is called when an event occurs) and a modification mode (the type of event that triggers the reactor).
function private.CreateParams <t0> (reactor: func, modify: t0&metamodify)
	debug.profilebegin(script.Name..' .CreateParams')
	
	local HookParameters = setmetatable({}, private.hpm)
	HookParameters.Metamethode = modify :: t0
	
	local InstanceHookParameters = obj.New(HookParameters, private.HookParamsClassName)
	
	local shade : ShadeParams = shadow.New(InstanceHookParameters)
	shade._state = 'pause'
	shade._react = reactor
	shade._modify = modify
	
	debug.profileend()
	return InstanceHookParameters
end


-- Creates a react instance that calls the passed function when the event specified in the modification mode occurs.
function private:CreateHook (ForTarget: any) : any
	debug.profilebegin(script.Name..' .CreateHook')
	
	local hook = {}
	local shade : ShadeHook = shadow.New(hook, mt.SetMode({},'v'))
	shade._at = ForTarget
	shade._params = self

	setmetatable(hook , private.Meta)
	--local HookInstance = obj.New(hook, private.HookClassName)
	lnk.Link(hook, self)

	debug.profileend()
	return hook
end

-- Resuming operation of parameters. Does not affect proxy operation.
function private:ResumeParams ()
	local shade : ShadeParams = shadow.Get(self)
	shade._state = 'run'
end
-- Pause of parameters operation. Does not affect proxy operation.
function private:PauseParams ()
	local shade : ShadeParams = shadow.Get(self)
	shade._state = 'pause'
end

type EnterTypes = 'after' | 'before'
-- For supported types, defines the behavior of the proxy when activate reactor.
function private:Define <t0> (SignalBehavior: EnterTypes)
	local shade : ShadeParams = shadow.Get(self :: t0)
	shade._signalbehavior = SignalBehavior
	return self
end


public.Resume = private.ResumeParams
public.Pause = private.PauseParams
public.Create = private.CreateHook
public.DefineBehavior = private.Define
class.New = private.CreateParams
table.freeze(public)
table.freeze(class)

type metamodify = 'index'|'newindex'|'call'
type states = 'run'|'pause'
type func = (self: {[any]:any}, ...any)->()
type ShadeHook = typeof(mt.SetMode({}::{
	_at: {[any]:any},
	_params: HookParams
},'v'))
type ShadeParams = {
	_state: states,
	_react: func,
	_modify: metamodify,
	_signalbehavior: EnterTypes?
}
type HookParams = typeof(private.CreateParams((nil::any)::func, (nil::any)::metamodify))--typeof(obj.New({}::public, private.HookParamsClassName))
type inject = {
	_TypeCheck: {
		HookParamsSignature: HookParams,
		Public: typeof(public),
		ShadeForParams: ShadeParams,
		ShadeForHook: ShadeHook,
		ExpectedFunction: func,
		ExpectedMetamodify: metamodify,
		ExpectedEnterType: EnterTypes,
		SystemDefaultEnterType: 'before'
	}
}

-- The HookParams class provides tools for creating proxy reactants.

return table.freeze(setmetatable({
	GetHook = function ()
		return class :: typeof(class) & inject
	end,
},{__index=main}))
--!strict

local main = require('./')
local define = {}

local private = {}
local protected = {}
local public = {}
local class = {}

local hook = main.GetHook()
local plugin = require('../plugin')
local obj = main.GetObject()
local lnk = plugin.GetLinker()
local shadow = plugin.GetShadow()
local mt = plugin.GetMeta()
local imp = plugin.GetImported()

private.ChangedClassName = 'ChangedSignal' :: 'ChangedSignal'
private.ConnectionClassName = 'Connection' :: 'Connection'
private.Connections = mt.SetMode({} :: {[any]:{Connection}}, 'k')
private.mt_protected = {__index = protected}
private.mt_public = {__index = public}

function private.NewCon (self: {})
	private.Connections[self]=private.Connections[self] or {}
	return private.Connections[self]
end
function private.GetCon (self: {})
	return private.Connections[self]
end
function private.DelCon (self: {})
	private.Connections[self] = if #private.Connections[self] == 0 then nil else private.Connections[self]
end
function private.AddCon (self: {}, t: Connection)
	table.insert(private.GetCon(self),t)
end
function private.RemCon (self: {}, t: Connection)
	local get = assert(private.GetCon(self),'never')
	table.remove(get, table.find(get, t))
	private.DelCon(self)
end

function private.ErrorMessageField (w0,...)
	warn(w0, ...)
end

function private.Call (f: func, ...: any) : never
	xpcall(coroutine.wrap(f::any),function (a0,...) private.ErrorMessageField(string.format('%q,%s,%s, in ChangedSignalHandler',tostring(f),a0,...)) end,...)
	return nil :: never
end

type originalTable = {[any]:any}
--[[ Since we're handling a reactive request directly within the metamethod, we can't pause its execution.
RBXScriptSignal likely wraps each connected handler in a separate coroutine before starting its execution.
This is directly confirmed by the fact that debug.traceback() doesn't return debug information for our handlers before activation.

Compared to direct access directly in the metatable, this can have both advantages and disadvantages.
Obviously, there are fewer freezes, but data staleness can also occur.
]]
@native
function private.ChangedSignalHandler (self: originalTable, ...: any)
	debug.profilebegin(script.Name..' .ChangedSignalHandler')

	local Connections = private.GetCon(self)

	if Connections then
		debug.profilebegin(script.Name .. ' .ChangedSignalHandler .Connections')

		local all = {...}

		--[[
			self = table under hook
			all[1]=index
			all[2]=new
			all[3]=old
			all[4]=entity
		]]

		for i,v in ipairs(Connections) do
			debug.profilebegin(script.Name..' .ChangedSignalHandler .Connections .For')
			local shade : ShadowCon = shadow.Get(v)

			if shade._type == 'for' or shade._type == 'at' then
				local index = all[1]
				if not (index == shade._keys._key) then
					continue
				end
			end

			local send = {all[4], all[1],all[2],all[3]}
			local keyrelated = {all[4], all[2], all[3]}
			local switch = imp.switch(shade._type, {
				default = send,
				['at'] = keyrelated,
				['for'] = keyrelated
			}
			)

			do
				debug.profilebegin(script.Name..' .ChangedSignalHandler .Connections .For .Call')

				private.Call(shade._f, unpack(switch))

				debug.profileend()
			end

			if shade._type == 'once' or shade._type == 'at' then
				(v::Connection):Disconnect()
			end

			debug.profileend()
		end

		debug.profileend()
	end

	debug.profileend()
end


















function private.CreateInterlayer <t0, t1,t2> (DataToInterplayer: t0, ChangedSignal: ChangedSignal, HookParams: typeof(hook._TypeCheck.HookParamsSignature))
	debug.profilebegin(script.Name..' .CreateInterlayer')
	
	local Interlayer = {}
	Interlayer.Changed = ChangedSignal
	Interlayer = mt.setrelatedmetatable(Interlayer, DataToInterplayer)
	
	
	local Hook = HookParams:Create(Interlayer)
	local InstanceChangedInterlayer = obj.New(Hook :: typeof(Interlayer), ChangedSignal.ClassName)
	lnk.Link(InstanceChangedInterlayer,Interlayer)
	
	debug.profileend()
	return InstanceChangedInterlayer
end

function private.CreateChanged <t0,t1> (Relative: t0, SignalBehavior: t1|typeof(hook._TypeCheck.ExpectedEnterType)?)
	local ChangedSignal = setmetatable({},private.mt_public)
	ChangedSignal.SignalBehavior = SignalBehavior :: t1
	
	local InstanceChangedSignal = obj.New(ChangedSignal, private.ChangedClassName)
	local ShadeRaw : ShadowChanged = shadow.New(InstanceChangedSignal, mt.SetMode({},'v'))
	ShadeRaw._relative = Relative
	
	return InstanceChangedSignal
end

-- Creates new Instance that incapsulates data with .Changed signal parameter that related to this data. For every data exists unique signals. Changes in another signals that related to this data does not fire this current signal.
function private.CreateSignal <t0,t1> (Relative: t0, SignalBehavior: t1|typeof(hook._TypeCheck.ExpectedEnterType)?)
	debug.profilebegin(script.Name..' .CreateChanged')
	
	local InstanceHookParams = hook.New(private.ChangedSignalHandler, 'newindex')
	local InstanceChangedSignal = private.CreateChanged(Relative, SignalBehavior)
	local InstanceInterlayer = private.CreateInterlayer(Relative, InstanceChangedSignal, InstanceHookParams :: typeof(hook._TypeCheck.HookParamsSignature))
	
	InstanceHookParams:Resume()

	debug.profileend()
	return InstanceInterlayer
end

function private.CreateConnection (to: ChangedSignal, t: signaltype, f: func)
	debug.profilebegin(script.Name..' .CreateConnection')

	local Connection = setmetatable({}, private.mt_protected)
	local InstanceConnection = obj.New(Connection, private.ConnectionClassName)
	local ShadeRaw : ShadowCon = shadow.New(InstanceConnection, mt.SetMode({},'v'))
	ShadeRaw._f = f
	ShadeRaw._type = t
	ShadeRaw._sig = to
	ShadeRaw._keys = {}

	local shadeChanged : ShadowChanged = shadow.Get(to)

	lnk.Link(InstanceConnection,f)
	private.NewCon(shadeChanged._relative)
	private.AddCon(shadeChanged._relative, InstanceConnection)


	debug.profileend()
	return InstanceConnection
end










function private.OnKeyChangedHandler (to: ChangedSignal, t: signaltype, f: funcWhile, k: whileKey)
	local conn = private.CreateConnection(to, t, f)
	local shade : ShadowCon = shadow.Get(conn)
	shade._keys._key=k
	return conn
end

function private.WaitHandler (to: ChangedSignal, t: signaltype, k: whileKey?)
	local cor = coroutine.running()
	local ret = function (self, a1, a2, a3)
		local c,s

		if t=='follow' then
			warn(k,a1,a2)
			c,s = coroutine.resume(cor,a1,a2)
		elseif t=='wait' then
			c,s = coroutine.resume(cor,a1,a2,a3)
		end

		if not c then
			private.ErrorMessageField('unstable coroutine',s, debug.traceback('\n'))
		end
	end

	if t == 'follow' then
		to:At(k, ret)
	elseif t == 'wait' then
		to:Once(ret)
	else
		error('Unknown signal type')
	end

	return coroutine.yield()
end




















-- Destroys the connection.
function private:DoConnectionDisconnect () : ()
	debug.profilebegin(script.Name..' .DoConnectionDisconnect')

	local shade : ShadowChanged = shadow.Get((shadow.Get(self)::ShadowCon)._sig)
	private.RemCon(shade._relative, self)

	debug.profileend()
	--private.DelCon(shade._relative)
end





-- Creates a persistent connection to entity changes
function private:Connect (F:func) : Connection
	return private.CreateConnection(self, 'conn',F)
end
--Creates a one-time connection to entity changes
function private:Once (F:func) : Connection
	return private.CreateConnection(self, 'once',F)
end
-- Creates a persistent connection to changes in a specific entity parameter
function private:For( key: whileKey, F: funcWhile) : Connection
	return private.OnKeyChangedHandler(self, 'for', F, key)
end
-- Creates a one-time connection to changes in a specific entity parameter
function private:At( key: whileKey, F: funcWhile) : Connection
	return private.OnKeyChangedHandler(self, 'at', F, key)
end
-- Waits for a change in the entity. Returns the key, new and old values.
function private:Wait () : (any,any,any)
	return private.WaitHandler(self, 'wait')
end
-- Waits for a change in a specific entity parameter. Returns the new and old values.
function private:Follow (key: whileKey) : (any,any)
	return private.WaitHandler(self,'follow',key)
end



protected.Disconnect = private.DoConnectionDisconnect

public.Connect = private.Connect
public.Once = private.Once
public.For = private.For
public.At = private.At
public.Wait = private.Wait
public.Follow = private.Follow
class.New = private.CreateSignal

table.freeze(private)
table.freeze(protected)
table.freeze(public)
table.freeze(class)


type signaltype = 'conn' | 'once' | 'for' | 'at' | 'wait' | 'follow'
type func = (self: any, index: any, newindex: any, oldindex: any)->()
type funcWhile = (self: any, newindex: any, oldindex: any)->()
type whileKey = any
type whileExp = any?


type ShadowChanged = {
	_relative: {}
}
type ShadowCon = {
	_type: signaltype,
	_f: func,
	_sig: ChangedSignal,
} & KeyReact

type KeyReact = {
	_keys: {
		_key: any,
		--_exp: any?
	}
}

type ChangedSignal = typeof(private.CreateChanged({}))
type Connection = typeof(private.CreateConnection({}::ChangedSignal,''::signaltype,(nil::any)::func))

type typecheck = {
	_typecheck:{
		
	}
}

return table.freeze(setmetatable({
	GetChangedSignal = function ()
		return class :: typeof(class) & typecheck
	end,
}, {__index=main}))
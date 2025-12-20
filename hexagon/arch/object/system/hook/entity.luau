--!strict

local main = require('./')

local hook = main.GetHook()
local enum = main.Enum()
local plugin = main.GetPluginProvider()
local obj = main.GetObject()

local mt = plugin.GetMeta()
local lnk = plugin.GetLinker()
local shadow = plugin.GetShadow()
local imp = plugin.GetImported()

local private = {}

function private.NewCon (self: {})
	private.cons[self]=private.cons[self] or {}
	return private.cons[self]
end
function private.GetCon (self: {})
	return private.cons[self]
end
function private.DelCon (self: {})
	private.cons[self] = if #private.cons[self] == 0 then nil else private.cons[self]
end
function private.AddCon (self: {}, t: Connection)
	table.insert(private.GetCon(self),t)
end
function private.RemCon (self: {}, t: Connection)
	local get = assert(private.GetCon(self),tostring(enum.Error.Never))
	table.remove(get, table.find(get, t))
	private.DelCon(self)
end

function private.ErrorMessageField (w0,...)
	warn(w0, ...)
end

function private.Call (f: func, ...: any) : never
	xpcall(coroutine.wrap(f::any),function (a0,...) private.ErrorMessageField(string.format('%q,%s,%s, in MainEntityHandler',tostring(f),a0,...)) end,...)
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
function private.MainEntityHandler (self: originalTable, ...: any)
	debug.profilebegin(script.Name..' .MainEntityHandler')
	
	local cons = private.GetCon(self)

	if cons then
		debug.profilebegin(script.Name .. ' .MainEntityHandler .Cons')
		
		local all = {...}
		
		--[[
			self = table under hook
			all[1]=index
			all[2]=new
			all[3]=old
			all[4]=entity
		]]
		
		for i,v in ipairs(cons) do
			debug.profilebegin(script.Name..' .MainEntityHandler .Cons .For')
			local shade : ShadowCon = shadow.Get(v)

			if shade._type == enum.Signal.For or shade._type == enum.Signal.At then
				local index = all[1]
				if not (index == shade._keys._key) then
					continue
				end
			end

			local send = {all[4], all[1],all[2],all[3]}
			local keyrelated = {all[4], all[2], all[3]}
			local switch = imp.switch(shade._type, {
				default = send,
				[enum.Signal.At] = keyrelated,
				[enum.Signal.For] = keyrelated
			}
			)
			
			do
				debug.profilebegin(script.Name..' .MainEntityHandler .Cons .For .Call')
			
				private.Call(shade._f, unpack(switch))
			
				debug.profileend()
			end

			if shade._type == enum.Signal.Once or shade._type == enum.Signal.At then
				(v::Connection):Disconnect()
			end
			
			debug.profileend()
		end
		
		debug.profileend()
	end
	
	debug.profileend()
end

private.EntityClassName = 'Entity' :: 'Entity'
private.ChangedClassName = 'ChangedSignal' :: 'ChangedSignal'
private.ConnectionClassName = 'Connection' :: 'Connection'
private.cons = mt.SetMode({} :: {[any]:{Connection}}, 'k')
private.Params = hook.New(private.MainEntityHandler, enum.Metamethode.NewIndex)
private.Params:Resume()






function private.CreateSignalsInterlayer <t0> (DataToProtect: t0)
	local Interlayer = {}
	Interlayer.Changed = private.CreateChanged(Interlayer)
	
	local meta = mt.CreateMetaTo(DataToProtect)
	setmetatable(Interlayer, meta)
	
	return Interlayer
end
function private.CreateHookedLayer <t0> (Interlayer: t0)
	return private.Params:Create(Interlayer) :: t0 
	--TODO: fix hook error typechecker
end


-- Creates new entity.  
function private.CreateNewEntity <t0> (DataToProtect: t0)
	debug.profilebegin(script.Name .. ' .CreateNewEntity')
	
	local Interlayer = private.CreateSignalsInterlayer(DataToProtect)
	local HookedLayer = private.CreateHookedLayer(Interlayer)
	local Entity = obj.New(HookedLayer, private.EntityClassName)
	
	debug.profileend()
	return Entity
end


function private.CreateChanged <t0> (Relative: t0)
	debug.profilebegin(script.Name..' .CreateChanged')

	local ChangedSignal = obj.New(setmetatable({},private.mt_pub_sg), private.ChangedClassName)
	local ShadeRaw : ShadowChanged = shadow.New(ChangedSignal, mt.SetMode({},'v'))
	ShadeRaw._relative = Relative
	
	debug.profileend()
	return ChangedSignal
end


function private.CreateConnection (to: ChangedSignal, t: signaltype, f: func)
	debug.profilebegin(script.Name..' .CreateConnection')

	local Connection = obj.New(setmetatable({}, private.mt_pub_con), private.ConnectionClassName)
	local ShadeRaw : ShadowCon = shadow.New(Connection, mt.SetMode({},'v'))
	ShadeRaw._f = f
	ShadeRaw._type = t
	ShadeRaw._sig = to
	ShadeRaw._keys = {}
	
	local shadeChanged : ShadowChanged = shadow.Get(to)
	
	lnk.Link(Connection,f)
	private.NewCon(shadeChanged._relative)
	private.AddCon(shadeChanged._relative, Connection)
	
	
	debug.profileend()
	return Connection
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
		
		if t==enum.Signal.Follow then
			warn(k,a1,a2)
			c,s = coroutine.resume(cor,a1,a2)
		elseif t==enum.Signal.Wait then
			c,s = coroutine.resume(cor,a1,a2,a3)
		end
		
		if not c then
			private.ErrorMessageField(tostring(enum.Error.Unstable),s, debug.traceback('\n'))
		end
	end
	
	if t == enum.Signal.Follow then
		to:At(k, ret)
	elseif t == enum.Signal.Wait then
		to:Once(ret)
	else
		error(enum.Error.Forbidden)
	end

	return coroutine.yield()
end




















-- Destroys the connection.
function private.DoConnectionDisconnect (self) : ()
	debug.profilebegin(script.Name..' .DoConnectionDisconnect')
	
	local shade : ShadowChanged = shadow.Get((shadow.Get(self)::ShadowCon)._sig)
	private.RemCon(shade._relative, self)
	
	debug.profileend()
	--private.DelCon(shade._relative)
end





-- Creates a persistent connection to entity changes
function private:Connect (F:func) : Connection
	return private.CreateConnection(self, enum.Signal.Conn,F)
end
--Creates a one-time connection to entity changes
function private:Once (F:func) : Connection
	return private.CreateConnection(self, enum.Signal.Once,F)
end
-- Creates a persistent connection to changes in a specific entity parameter
function private:For( key: whileKey, F: funcWhile) : Connection
	return private.OnKeyChangedHandler(self, enum.Signal.For, F, key)
end
-- Creates a one-time connection to changes in a specific entity parameter
function private:At( key: whileKey, F: funcWhile) : Connection
	return private.OnKeyChangedHandler(self, enum.Signal.At, F, key)
end
-- Waits for a change in the entity. Returns the key, new and old values.
function private:Wait () : (any,any,any)
	return private.WaitHandler(self, enum.Signal.Wait)
end
-- Waits for a change in a specific entity parameter. Returns the new and old values.
function private:Follow (key: whileKey) : (any,any)
	return private.WaitHandler(self,enum.Signal.Follow,key)
end


local pub_con = {}
local pub_signal = {}
local class = {}
private.mt_pub_con = {__index = pub_con}
private.mt_pub_sg = {__index = pub_signal}
pub_con.Disconnect = private.DoConnectionDisconnect
pub_signal.Connect = private.Connect
pub_signal.Once = private.Once
pub_signal.For = private.For
pub_signal.At = private.At
pub_signal.Wait = private.Wait
pub_signal.Follow = private.Follow
class.New = private.CreateNewEntity
table.freeze(pub_con)
table.freeze(pub_signal)
table.freeze(private)
table.freeze(class)

type signaltype = index<typeof(enum.Signal), keyof<typeof(enum.Signal)>>
type func = (self: Entity<any>, index: any, newindex: any, oldindex: any)->()
type funcWhile = (self: Entity<any>, newindex: any, oldindex: any)->()
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
type Connection = typeof(private.CreateConnection({}::ChangedSignal,{}::signaltype,(nil::any)::func))
type Entity<t0> = typeof(private.CreateNewEntity({}::t0))

type typecheck = {
	_typecheck:{
		
	}
}

return table.freeze(setmetatable({
	-- ECS reactive like object.
	GetEntity = function ()
		return class :: typeof(class) & typecheck
	end,
}, {__index=main}))
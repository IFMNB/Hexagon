--!strict

local parent = require('./')
local main = parent :: parent.ancestors
local hook = parent.GetClass()

local enum = main.Enum()
local plugin = main.GetPluginProvider()
local obj = main.GetObject()
local oop = plugin.GetOOP()
local mt = plugin.GetMeta()
local lnk = plugin.GetLinker()
local shadow = plugin.GetShadow()

local private = {}
local pub_con = {}
local pub_signal = {}
local public = {}
local class = {}
local root = {}

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

function private.ChangedSetRelative <t0> (self: ChangedSignal, relative: {})
	local shadeRaw : ShadowChanged = shadow.Get(self)
	shadeRaw._relative = relative
end

function private.ErrorMessageField (a0)
	warn(a0)
end

function private.Call (f: func, ...: any)
	if private.studio then
		coroutine.wrap(f)(...)
	else
		xpcall(f::(...any)->(), private.ErrorMessageField, ...)
	end
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
	local cons = private.GetCon(self)

	if cons then
		local all = {...}
		
		for i,v in ipairs(cons) do
			local shade : ShadowCon = shadow.Get(v)

			if shade._type == enum.Signal.For or shade._type == enum.Signal.At then
				local index = all[1]
				if not (index == shade._keys._key) then
					continue
				end
			end

			private.Call(shade._f, self, ...)

			if shade._type == enum.Signal.Once or shade._type == enum.Signal.At then
				(v::Connection):Disconnect()
			end
		end
	end
end

private.studio = game["Run Service"]:IsStudio()
private.EntityClassName = 'Entity' :: 'Entity'
private.ChangedClassName = 'ChangedSignal' :: 'ChangedSignal'
private.ConnectionClassName = 'Connection' :: 'Connection'
private.cons = mt.SetMode({} :: {[any]:{Connection}}, 'k')
private.Params = hook.New(private.MainEntityHandler, enum.Metamethode.NewIndex):Resume()






function private.CreateNewEntity <t0> (element: t0) : Entity<t0>
	local inject = {} :: EntityData
	inject.Changed = private.CreateChanged()
	
	local hook = private.Params:Create(mt.DoProxy(element, inject))
	--local entity = obj.New(mt.DoProxy(hook), private.EntityClassName)
	
	--lnk.Link(hook,inject)
	private.ChangedSetRelative(inject.Changed,inject)
	local object = obj.New(hook, private.EntityClassName)
	
	return object
end
function private.CreateChanged <t0> ()
	local Raw = oop.Expanding({}, pub_signal)
	
	local ChangedSignal = obj.New(oop.Expanding({},pub_signal)::pub_signal, private.ChangedClassName)
	local ShadeRaw : ShadowChanged = shadow.New(ChangedSignal, mt.SetMode({},'v'))
	
	return ChangedSignal
end
function private.CreateConnection (to: ChangedSignal, t: signaltype, f: func) : Connection
	local Raw = oop.Expanding({}, pub_con)

	local Connection = obj.New(oop.Expanding({},pub_con)::pub_con, private.ConnectionClassName)
	local ShadeRaw : ShadowCon = shadow.New(Connection, mt.SetMode({},'v'))
	ShadeRaw._f = f
	ShadeRaw._type = t
	ShadeRaw._sig = to
	ShadeRaw._keys = {}
	
	local shadeChanged : ShadowChanged = shadow.Get(to)
	
	lnk.Link(Connection,f)
	private.NewCon(shadeChanged._relative)
	private.AddCon(shadeChanged._relative, Connection)
	
	return Connection
end

function private.SpecifyWhile (to: ChangedSignal, t: signaltype, f: funcWhile, k: whileKey)
	local conn = private.CreateConnection(to, t, f)
	local shade : ShadowCon = shadow.Get(conn)
	--shade._while._exp=e
	shade._keys._key=k
	return conn
end

function private.SignalWait (to: ChangedSignal, t: signaltype, k: whileKey?)
	local cor = coroutine.running()
	local ret = function () coroutine.resume(cor) end
	
	if t == enum.Signal.Follow then
		to:At(k, ret)
	elseif t == enum.Signal.Wait then
		to:Once(ret)
	else
		error(enum.Error.Forbidden)
	end
	
	coroutine.yield()
	return
end





















function private.DoConnectionDisconnect (self: Connection)
	local shade : ShadowChanged = shadow.Get((shadow.Get(self)::ShadowCon)._sig)
	private.RemCon(shade._relative, self)
	--private.DelCon(shade._relative)
end




-- Destroys the connection.
function pub_con:Disconnect() : ()
	return private.DoConnectionDisconnect(self)
end
-- Creates a persistent connection to entity changes
function pub_signal:Connect (F:func) : Connection
	return private.CreateConnection(self, enum.Signal.Conn,F)
end
--Creates a one-time connection to entity changes
function pub_signal:Once (F:func) : Connection
	return private.CreateConnection(self, enum.Signal.Once,F)
end
-- Creates a persistent connection to changes in a specific entity parameter
function pub_signal:For( key: whileKey, F: funcWhile) : Connection
	return private.SpecifyWhile(self, enum.Signal.For, F, key)
end
-- Creates a one-time connection to changes in a specific entity parameter
function pub_signal:At( key: whileKey, F: funcWhile) : Connection
	return private.SpecifyWhile(self, enum.Signal.At, F, key)
end
-- Waits for a change in the entity
function pub_signal:Wait () : ()
	return private.SignalWait(self, enum.Signal.Wait)
end
-- Waits for a change in a specific entity parameter
function pub_signal:Follow (key: whileKey)
	return private.SignalWait(self,enum.Signal.Follow,key)
end




--[[
Creates an instance of an entity. An entity is an object that can respond to changes in the data within it.
]]
function class.New <t0> (element: t0) : Entity<t0>
	return private.CreateNewEntity(element)
end


type signaltype = index<typeof(enum.Signal), keyof<typeof(enum.Signal)>>
type func = (self: {[any]:any}, index: any, newindex: any, oldindex: any)->()
type funcWhile = func --(self: {[any]:any}, newindex: any, oldindex: any)->()
type whileKey = any
type whileExp = any?

type EntityData = {
	Changed: ChangedSignal
}


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

type ChangedSignal = typeof(obj.New({}::pub_signal,private.ChangedClassName))&{

}


type Connection = typeof(obj.New({}::pub_con, private.ConnectionClassName))
export type Entity<t0> = typeof(obj.New({}::public, private.EntityClassName))&t0&EntityData


type pub_signal = typeof(pub_signal)
type pub_con = typeof(pub_con)

export type ancestors = root & parent.ancestors
export type public = typeof(public)
export type root = typeof(root)
export type self = typeof(class)

-- Used in reactions
function root.GetClass () return class end
oop.Expanding(root,main)
return root
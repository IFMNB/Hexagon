--!strict

local http = game:GetService('HttpService')

local parent = require('./')

local provider = parent.GetPluginProvider()
local mt = provider.GetMeta()
local link = provider.GetLinker()
local enum = parent.Enum()

local private = {}
local public = {}
local class = {}


private.COClassName = 'AbstractObject' :: 'AbstractObject'
private.lock = enum.Error.Forbidden
private.Hierarchy = mt.SetMode({} :: {[userdata]: userdata}, 'kv')

if game["Run Service"]:IsStudio() then
	type interlayer = typeof(({}::TypeSolver)._TypeCheck.GetInterlayerSignature({},''))
	
	function private.DebugNew (id: string, to: interlayer, self: {[any]:any}, object: typeof(({}::TypeSolver)._TypeCheck.ObjectSignature))
		local debuginformation = mt.SetMode({
			Stack =debug.traceback(),
			Interlayer =to,
			DataToProtect = self,
			RawMetatable = getmetatable(self),
			RealObject = object,
			MetaCoroutine=not coroutine.isyieldable()
		}, 'v');

		(private.DebugID::any)[id]=object;
		(private.DebugTrace::any)[object]=debuginformation;

		return debuginformation
	end
	
	type debug = typeof(private.DebugNew('',{}::interlayer,{},{}:: typeof(({}::TypeSolver)._TypeCheck.ObjectSignature)))
	private.DebugID = mt.SetMode({} :: {[string]: any}, 'v')
	private.DebugTrace = mt.SetMode({} :: {[any]: debug}, 'k')

	
	
	-- If function called in StudioMode, return debug info about this object.
	function public:__DebugInfo () : debug?
		return private.DebugTrace and private.DebugTrace[self]
	end
	
	-- If function called in StudioMode, you can catch any object by id.
	function class.__ById (id: string) : typeof(({}::TypeSolver)._TypeCheck.ObjectSignature)?
		return private.DebugID and private.DebugID[id]
	end
end








function private.DoRelativeTo <t0,t1> (self: t0, to: t1)
	private.Hierarchy[self]=to
end
function private.DoGetRelative <t0> (self: t0)
	return private.Hierarchy[self]
end




-- Creates interlayer for DTP and object. Interlayer used to get access to public object data (global object functions)
function private.CreateInterlayer <t0,t1> (DataToProtect: t0, ClassName: t1)
	debug.profilebegin(script.Name..'.CreateInterlayer')
	
	local Injector = table.clone(public)
	Injector.ClassName = ClassName
	Injector.Identificator = http:GenerateGUID(false)
	
	local metatable = mt.CreateMetaTo(DataToProtect)
	setmetatable(Injector, metatable)
	
	
	debug.profileend()
	return Injector
end

-- Creates real userdata object, that used to protect DTP and incapsulate it.
function private.CreateObject <t0> (DataToProtect: t0) : setmetatable<{}, {
		__index: t0,
		__newindex: t0,
		__call: t0,
		__tostring: typeof(private.MT_GetClassName),
		__metatable: typeof(private.lock)
	}>
	debug.profilebegin(script.Name..'.CreateObject')
	
	local object = newproxy(true)
	local meta = getmetatable(object)

	meta.__index = DataToProtect
	meta.__newindex = DataToProtect
	meta.__call = DataToProtect
	meta.__tostring = private.MT_GetClassName
	meta.__metatable = private.lock
	
	
	debug.profileend()
	return object
end

-- Returns the name of this class.
function private.MT_GetClassName (self)
	return self.ClassName
end 



-- Creates a new instance. Basicly, just protect this data and incapsulate to userdata.
function private.NewBaseObject <t0, t1> (DataToProtect: t0, ClassName: t1)-- : CodeObject<t0,t1>
	debug.profilebegin(script.Name..'.CreateAbstractInstance')
	
	local Interlayer = private.CreateInterlayer(DataToProtect, ClassName)
	local Object = private.CreateObject(Interlayer)
	
	private.DoRelativeTo(Object, DataToProtect)
	link.Link(Object,DataToProtect,Interlayer)
	
	if private.DebugNew then
		debug.profilebegin(script.Name..'.DebugNew')
		private.DebugNew(Interlayer.Identificator, Interlayer, DataToProtect, Object)
		debug.profileend()
	end

	debug.profileend()
	return Object
end











-- Returns the parent of this instance if it exists.
function private:GetAncestor () : typeof(({}::TypeSolver)._TypeCheck.GetObjectSignature({},''))?
	local origin = private.DoGetRelative(self) :: userdata
	return origin
end




public.GetAncestor = private.GetAncestor
class.New = private.NewBaseObject



type userdata = any
type TypeSolver = {
	_TypeCheck: {
		GetObjectSignature: <t0,t1> (DataToProtect: t0, ClassName: t1)->typeof(private.NewBaseObject({}::t0,''::t1)),
		GetInterlayerSignature: <t0,t1> (DataToInterlayer: t0, ClassName: t1)->typeof(private.CreateInterlayer({}::t0,''::t1)),
		ObjectSignature: typeof(private.NewBaseObject({},'')),
		PublicSignature: typeof(public)
	}
}

table.freeze(public)
table.freeze(class)
table.freeze(private)
return table.freeze(setmetatable({
	GetObject = function ()
		return class :: typeof(class) & TypeSolver
	end,
}, {__index = parent}))
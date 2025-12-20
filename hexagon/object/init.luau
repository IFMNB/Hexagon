--!strict

local http = game:GetService('HttpService')

local private = {}
local public = {}
local class = {}


private.lock = 'Access denied' :: 'Access denied'
private.datas = setmetatable({} :: {[any]:any}, 'v')
private.Hierarchy = setmetatable({} :: {[userdata]: userdata}, 'kv')
private.studio = game["Run Service"]:IsStudio()





function private.DoRelativeTo <t0,t1> (self: t0, to: t1)
	private.Hierarchy[self]=to
end
function private.DoGetRelative <t0> (self: t0)
	return private.Hierarchy[self]
end

function private.NewId ()
	return http:GenerateGUID(false)
end



-- Creates interlayer for DTP and object. Interlayer used to get access to public object data (global object functions)
function private.CreateInterlayer <t0,t1> (DataToProtect: t0, ClassName: t1)
	debug.profilebegin(script.Name..'.CreateInterlayer')
	
	local Injector = table.clone(public)
	Injector.ClassName = ClassName
	Injector.Identificator = private.NewId()
	--Injector.Parent = type(DataToProtect) == 'userdata' and DataToProtect or nil
	setmetatable(Injector :: unknown, {__index = DataToProtect, __metatable = private.lock, __newindex = DataToProtect, __call = DataToProtect})
	
	debug.profileend()
	return Injector :: typeof(Injector) & t0
end

-- Creates real userdata object, that used to protect DTP and incapsulate it.
function private.CreateObject <t0> (DataToProtect: t0) 
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
	private.datas[Interlayer] = DataToProtect
	private.datas[DataToProtect]=Object
	
	type Interlayer = typeof(Interlayer) & t0
	type Object = Interlayer

	debug.profileend()
	return Object :: Object
end






-- Returns the parent of this instance if it exists.
function private.GetAncestor (self: any) : typeof(({}::TypeSolver)._TypeCheck.GetObjectSignature({},''))?
	local origin = private.DoGetRelative(self) :: userdata
	return origin
end
-- Returns all ancestors of this instance.
function private.GetAllAncestors (self: any)
	local list = {}
	while true do
		local origin = private.DoGetRelative(self) :: userdata
		if not origin then break end
		table.insert(list, origin)
	end
	return list
end


--public.GetAncestor = private.GetAncestor
class.New = private.NewBaseObject

type userdata = any
type TypeSolver = {
	_TypeCheck: {
		GetObjectSignature: <t0,t1> (DataToProtect: t0, ClassName: t1)->typeof(private.NewBaseObject({}::t0,''::t1)),
		GetInterlayerSignature: <t0,t1> (DataToInterlayer: t0, ClassName: t1)->typeof(private.CreateInterlayer({}::t0,''::t1)),
		ObjectSignature: typeof(private.NewBaseObject({},'')),
		PublicSignature: typeof(public),
		IdentificatorSignature: typeof(private.NewId())
	}
}

table.freeze(public)
table.freeze(class)
table.freeze(private)
return table.freeze({
	GetObject = function ()
		return class :: typeof(class) & TypeSolver
	end,
})
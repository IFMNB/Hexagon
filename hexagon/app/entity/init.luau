--!strict

local app = require('./')
local plugin = app.GetPluginProvider()
local arch = app.GetArchProvider()
local sys = arch.GetSystem()

local oop = plugin.GetOOP()
local obj = arch.GetObject()
local chg = sys.GetChanged().GetClass()

local private = {}
local public = {}
local class = {}
local root = {}

private.EntityClassName = 'Entity' :: 'Entity'


function private.DoCreateNewEntity <this> (self: this)
	local sig = chg.New(self)
	return obj.New(sig, private.EntityClassName)
end





function class.New <this> (self: this) : Entity<this>
	return private.DoCreateNewEntity(self)
end


local a = {pis = 'da'}
local b = class.New(a)

type _ent = Entity<{}> & {
	
}



type ChangedSig = typeof(chg.New({}))
export type Entity<this> = typeof(obj.New({} :: public & ChangedSig, private.EntityClassName)) & this

export type ancestors = root & app.all
export type public = typeof(public)
export type root = typeof(root)
export type self = typeof(class)

function root.GetClass () return class end
oop.Expanding(root,app)
return root
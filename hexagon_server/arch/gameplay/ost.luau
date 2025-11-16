--!strict

local main = require('../')

local arch = main.GetArchProvider()
local app = main.GetAppProvider()
local plugin = main.GetPluginProvider()
local enum = main.GetEnums()

local oop = plugin.GetOOP()
local ent = app.GetEntity().GetClass()
--local obj = arch.GetObject()
local stack = arch.GetSystem().GetStack().GetClass()

local private = {}
local public = {}
local class = {}
local root = {}








function class.New <hexEnum> (Music: hexEnum&HexagonEnum) : AmbientMusic<hexEnum>
	
end

class.New(enum.Roblox.Camera.SmoothFollow)


type HexagonEnum<t1,t2> = typeof(enum.Create('' :: t1, '' :: t2))

type _private = {
	
}
type AmbientPublic <tp1> = {Music: tp1}
export type AmbientMusic <type1> = typeof(ent.New({}::public)) & AmbientPublic<type1>

export type ancestors = root & main.hierarchy_server_start
export type public = typeof(public)
export type self = typeof(class)
export type root = typeof(root)

function root.GetClass () return class end
oop.Expanding(root, main)
return root
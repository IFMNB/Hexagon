--!strict

-- Overwatch is a signaled version of the collection class. Like a collection + Watcher class.

local app = require('../')
local arch = app.GetArchProvider()
local plugin = app.GetPluginProvider()

local sys = arch.GetSystem()
local col = sys.GetCollection().GetCollections()
local hook = sys.GetHook().GetHooks()
local obj = arch.GetObject()
local oop = plugin.GetOOP()

local private = {}
local public = {}
local class = {}
local root = {}

private.OverwatchClassName = 'Overwatch' :: 'Overwatch'

function private.DoCreateNewOverwatch ()
	local col = col.New()
	
end





function class.New ()
	
end

export type Collection = typeof(col.New())
export type Overwatch = typeof(obj.New({} :: Collection & public, private.OverwatchClassName))

export type public = typeof(public)
export type ancestors = root & app.all
export type root = typeof(root)
export type self = typeof(class)

function root.GetClass () return class end
oop.Expanding(root, app)
return root
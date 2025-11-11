--!strict

local parent = require('./')
local ancestors = parent :: parent.ancestors
local arch = ancestors.GetArchProvider()
local plugin = ancestors.GetPluginProvider()

local uis = game:GetService('UserInputService')

local ent = parent.GetClass()
local system = arch.GetSystem()
local oop = plugin.GetOOP()

local private = {}
local public = {}
local class = {}
local root = {}



type _inp = Input & {
	
}
export type Input = typeof(ent.New({} :: public))

export type public = typeof(public)
export type ancestors = root & parent.ancestors
export type root = typeof(root)
export type self = typeof(class)

function root.GetClass () return class end
oop.Expanding(root, ancestors)
return root
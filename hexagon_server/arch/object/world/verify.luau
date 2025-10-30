--!strict

local parent = require('./')
local ancestors = parent :: parent.ancestors

local plugins = ancestors.GetPluginProvider()
local oop = plugins.GetOOP()

local private = {}
local public = {}
local class = {}
local root = {}






type public = typeof(public)
export type ancestors = root & parent.ancestors
export type root = typeof(root)
export type self = typeof(class)

--
function root.GetVerify () return class end
oop.Expanding(root, ancestors)
return root
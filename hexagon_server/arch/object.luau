--!strict

local arch = require('./')
local obj = arch.GetArchProvider().GetObject()
local oop = arch.GetPluginProvider().GetOOP()

local private = {}
local public = {}
local root = {}



export type ancestors = root & arch.hierarchy_server_start
export type root = typeof(root)
export type self = typeof(public)
oop.Expanding(root, arch)
return root
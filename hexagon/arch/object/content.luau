--!strict

local parent = require('./')
local ancestors = parent :: parent.ancestors

local obj = parent.GetObject()
local plugin = ancestors.GetPluginProvider()

local provider : RemoteFunction = script.provider

local private = {}
local public = {}






export type ancestors = self & parent.ancestors
export type self = typeof(public)

return public
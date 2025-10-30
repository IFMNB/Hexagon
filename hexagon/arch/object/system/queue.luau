--!strict

local parent = require('./')
local ancestors = parent :: parent.ancestors

local plugin = ancestors.GetPluginProvider()

local oop = plugin.GetOOP()

local private = {}
local public = {}
local class = {}
local root = {}
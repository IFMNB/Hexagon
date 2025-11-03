--!strict

local app = require('../')
local arch = app.GetArchProvider()
local plugin = app.GetPluginProvider()

local system = arch.GetSystem()
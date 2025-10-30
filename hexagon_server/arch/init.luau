--!strict

local replica_link = require('./replica_link')
local plugins = require('./plugins')

local root = {}





type root = typeof(root)
export type hierarchy_server_start = root & replica_link.project_all & plugins.root
replica_link.GetPluginProvider().GetOOP().Expanding(root, replica_link, plugins)

return root :: hierarchy_server_start
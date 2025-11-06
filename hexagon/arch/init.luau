--!strict

-- Самостоятельные низкоуровневые классы.

local plugins = require('./plugins')

local root = {}

root.GetArch = script

export type project_hierarchy_start = typeof(root) & plugins.root

plugins.GetPluginProvider().GetOOP().Expanding(root, plugins)
return root :: project_hierarchy_start
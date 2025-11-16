--!strict

-- Самостоятельные низкоуровневые классы.

local plugins = require('./enum/plugins')

local root = {}

root.GetArch = script

local _G = {}

-- Контейнер _G для arch части.
function root.Global ()
	return _G
end
-- Возвращает перечисление HexagonEnum.
function root.Enum ()
	return require('./enum')
end

export type project_hierarchy_start = typeof(root) & plugins.root

plugins.GetPluginProvider().GetOOP().Expanding(root, plugins)
return root :: project_hierarchy_start
--!strict

local plugins = require('./enum/plugins')

local root = {}
root.PathArch = script

-- All default HexagonEnums.
function root.Enum ()
	return require('./enum')
end

setmetatable(root,{__index=plugins})
return root
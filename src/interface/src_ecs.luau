local src_b=require('./src_base')
local root = {}
root.Classes = setmetatable({},{__index=src_b.Classes})
root.Abstract = setmetatable({},{__index=src_b.Abstract})


function root.Classes.HxComponent ()
	return require('..//object/__HxAbstractECS/__HxAbstractComponent/HxComponent').HxComponent
end



function root.Abstract.HxAbstractECS ()
	return require('..//object/__HxAbstractECS').__HxAbstractECS
end
function root.Abstract.HxAbstractComponent ()
	return require('..//object/__HxAbstractECS/__HxAbstractComponent').__HxAbstractComponent
end
function root.Abstract.HxAbstractSystem ()
	return require('..//object/__HxAbstractECS/__HxAbstractSystem').__HxAbstractSystem
end

return root
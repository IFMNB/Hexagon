local src_object = require('./src_object')
local src = {};
src.Classes = setmetatable({},{__index=src_object.Classes});
src.Abstract = setmetatable({},{__index=src_object.Abstract});
src.Interface = setmetatable({}, {__index=src_object.Interface});

function src.Classes.HxNumber ()
	return require('..//object/__HxBase/___GHxPrimetive/_IHxPrimetive/HxNumber').HxNumber
end

function src.Classes.HxBoolean ()
	return require('..//object/__HxBase/___GHxPrimetive/_IHxPrimetive/HxBoolean').HxBoolean
end

function src.Classes.HxString ()
	return require('..//object/__HxBase/___GHxPrimetive/_IHxPrimetive/HxString').HxString
end

function src.Classes.HxEvent ()
	return require('..//object/__HxBase/HxEvent').HxEvent
end
function src.Classes.HxConnection ()
	return require('..//object/__HxBase/HxConnection').HxConnection
end

function src.Classes.HxSignal ()
	return require('..//object/__HxBase/___GHxProperty/__HxBaseProperty/HxActionEmitter/HxSignal').HxSignal
end

-- Does not have any analog.
@deprecated
function src.Classes.HxHooker ()
	return require('..//object/__HxBase/___GHxProperty/__HxBaseProperty/HxHooker').HxHooker
end
function src.Classes.HxShade ()
	return require('..//object/__HxBase/___GHxProperty/__HxBaseProperty/HxShade').HxShade
end

function src.Classes.HxActionEmitter ()
	return require('..//object/__HxBase/___GHxProperty/__HxBaseProperty/HxActionEmitter').HxActionEmitter
end
function src.Classes.HxMap ()
	return require('..//object/__HxBase/__HxBaseCollection/IHxMap/HxMap').HxMap
end
function src.Classes.HxWeakMap ()
	return require('..//object/__HxBase/__HxBaseCollection/IHxMap/HxWeakMap').HxWeakMap
end
function src.Classes.HxNode ()
	return require('..//object/__HxBase/__HxBaseCollection/HxNode').HxNode
end
function src.Classes.HxList ()
	return require('..//object/__HxBase/__HxBaseCollection/IHxList/HxList').HxList
end
function src.Classes.HxWeakList ()
	return require('..//object/__HxBase/__HxBaseCollection/IHxList/HxWeakList').HxWeakList
end


function src.Abstract.HxBaseProperty ()
	return require('..//object/__HxBase/___GHxProperty/__HxBaseProperty').__HxBaseProperty
end

function src.Abstract.HxBase ()
	return require('..//object/__HxBase').__HxBase
end
function src.Abstract.HxBaseCollection ()
	return require('..//object/__HxBase/__HxBaseCollection').__HxBaseCollection
end

function src.Interface.IHxPrimetive ()
	return require('..//object/__HxBase/___GHxPrimetive/_IHxPrimetive')._IHxPrimetive
end
function src.Interface.IHxMap ()
	return require('..//object/__HxBase/__HxBaseCollection/IHxMap')._IHxMap
end
function src.Interface.IHxList ()
	return require('..//object/__HxBase/__HxBaseCollection/IHxList')._IHxList
end


return src
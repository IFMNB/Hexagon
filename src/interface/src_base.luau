local src_object = require('./src_object')
local src = {};
src.Classes = setmetatable({},{__index=src_object.Classes});
src.Abstract = setmetatable({},{__index=src_object.Abstract});
src.Interface = {};

function src.Classes.HxInstance ()
	return require('..//object/__HxBase/HxInstance').HxInstance
end
function src.Classes.HxWorldStorage ()
	return require('..//object/__HxBase/HxInstance/__HxAbstractDataTree/HxWorldStorage').HxWorldStorage
end
function src.Classes.HxParallelWorker ()
	return require('..//object/__HxBase/HxInstance/__HxBaseParallel/HxParallelWorker').ParallelWorker
end
--function src.Classes.HxParallelConstantWorker ()
	--return require('..//object/__HxBase/HxInstance/__HxAbstractParallel/HxParallelConstantWorker').ParallelConstantWorker
--end
function src.Classes.NumberObject ()
	return require('..//object/__HxBase/__HxAbstractPrimetive/number').Number
end
function src.Classes.ModifiedNumberObject ()
	return require('..//object/__HxBase/__HxAbstractPrimetive/number/mnumber').ModifiedNumber
end
function src.Classes.StringObject ()
	return require('..//object/__HxBase/__HxAbstractPrimetive/string').String
end
function src.Classes.TranslationStringObject ()
	return require('..//object/__HxBase/__HxAbstractPrimetive/string/tstring').TString
end
function src.Classes.Event ()
	return require('..//object/__HxBase/__HxBaseProperty/HxEvent').Events
end
function src.Classes.Hook ()
	return require('..//object/__HxBase/__HxBaseProperty/HxHooker').Hooks
end
function src.Classes.Shade ()
	return require('..//object/__HxBase/__HxBaseProperty/HxShade').Shade
end
function src.Classes.Snapshot ()
	return require('..//object/__HxBase/__HxBaseProperty/HxSnapshot').Snapshot
end
function src.Classes.HxMap ()
	return require('..//object/__HxBase/__HxAbstractPrimetive/__HxBaseCollection/IHxMap/HxMap').HxMap
end
function src.Classes.HxWeakMap ()
	return require('..//object/__HxBase/__HxAbstractPrimetive/__HxBaseCollection/IHxMap/HxWeakMap').HxWeakMap
end
function src.Classes.HxNode ()
	return require('..//object/__HxBase/__HxAbstractPrimetive/__HxBaseCollection/HxNode').HxNode
end
function src.Classes.HxList ()
	return require('..//object/__HxBase/__HxAbstractPrimetive/__HxBaseCollection/IHxList/HxList').HxList
end
function src.Classes.HxWeakList ()
	return require('..//object/__HxBase/__HxAbstractPrimetive/__HxBaseCollection/IHxList/HxWeakList').HxWeakList
end


function src.Abstract.HxAbstractDataTree ()
	return require('..//object/__HxBase/HxInstance/__HxAbstractDataTree').__HxAbstractDataTree
end
function src.Abstract.HxBaseParallel ()
	return require('..//object/__HxBase/HxInstance/__HxBaseParallel').__HxBaseParallel
end
function src.Abstract.HxBaseProperty ()
	return require('..//object/__HxBase/__HxBaseProperty').__HxBaseProperty
end
function src.Abstract.HxAbstractPrimetive ()
	return require('..//object/__HxBase/__HxAbstractPrimetive').__HxAbstractPrimetive
end
function src.Abstract.HxBase ()
	return require('..//object/__HxBase').__HxBase
end
function src.Abstract.HxAbstractConnection ()
	return require('..//object/__HxBase/__HxBaseProperty/__HxAbstractConnection').__HxAbstractConnection
end
function src.Abstract.HxBaseCollection ()
	return require('..//object/__HxBase/__HxAbstractPrimetive/__HxBaseCollection').__HxBaseCollection
end


function src.Interface.IHxMap ()
	return require('..//object/__HxBase/__HxAbstractPrimetive/__HxBaseCollection/IHxMap')._IHxMap
end
function src.Interface.IHxArray ()
	return require('..//object/__HxBase/__HxAbstractPrimetive/__HxBaseCollection/IHxList')._IHxList
end


return src
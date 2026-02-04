local src_object = require('./src_object')
local src = {};
src.Classes = setmetatable({},{__index=src_object.Classes});
src.Abstract = setmetatable({},{__index=src_object.Abstract});

function src.Classes.HxInstance ()
	return require('..//object/__HxAbstractBase/HxInstance').HxInstance
end
function src.Classes.HxWorldStorage ()
	return require('..//object/__HxAbstractBase/HxInstance/__HxAbstractDataTree/HxWorldStorage').HxWorldStorage
end
function src.Classes.HxParallelWorker ()
	return require('..//object/__HxAbstractBase/HxInstance/__HxAbstractParallel/HxParallelWorker').ParallelWorker
end
--function src.Classes.HxParallelConstantWorker ()
	--return require('..//object/__HxAbstractBase/HxInstance/__HxAbstractParallel/HxParallelConstantWorker').ParallelConstantWorker
--end
function src.Classes.NumberObject ()
	return require('..//object/__HxAbstractBase/__HxAbstractPrimetive/number').Number
end
function src.Classes.ModifiedNumberObject ()
	return require('..//object/__HxAbstractBase/__HxAbstractPrimetive/number/mnumber').ModifiedNumber
end
function src.Classes.StringObject ()
	return require('..//object/__HxAbstractBase/__HxAbstractPrimetive/string').String
end
function src.Classes.TranslationStringObject ()
	return require('..//object/__HxAbstractBase/__HxAbstractPrimetive/string/tstring').TString
end
function src.Classes.Event ()
	return require('..//object/__HxAbstractBase/__HxAbstractProperty/events').Events
end
function src.Classes.Hook ()
	return require('..//object/__HxAbstractBase/__HxAbstractProperty/hook').Hooks
end
function src.Classes.Shade ()
	return require('..//object/__HxAbstractBase/__HxAbstractProperty/shade').Shade
end
function src.Classes.Snapshot ()
	return require('..//object/__HxAbstractBase/__HxAbstractProperty/snapshot').Snapshot
end


function src.Abstract.HxAbstractDataTree ()
	return require('..//object/__HxAbstractBase/HxInstance/__HxAbstractDataTree').__HxAbstractDataTree
end
function src.Abstract.HxAbstractParallel ()
	return require('..//object/__HxAbstractBase/HxInstance/__HxAbstractParallel').__HxAbstractParallel
end
function src.Abstract.HxAbstractProperty ()
	return require('..//object/__HxAbstractBase/__HxAbstractProperty').__HxAbstractProperty
end
function src.Abstract.HxAbstractPrimetive ()
	return require('..//object/__HxAbstractBase/__HxAbstractPrimetive').__HxAbstractPrimetive
end
function src.Abstract.HxAbstractBase ()
	return require('..//object/__HxAbstractBase').__AbstractBase
end
function src.Abstract.HxAbstractConnection ()
	return require('..//object/__HxAbstractBase/__HxAbstractProperty/__HxAbstractConnection').__HxAbstractConnection
end


return src
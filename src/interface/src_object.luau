local src = {};
src.Classes = {};
src.Abstract = {};

function src.Classes.HxObject ()
	return require('..//object/').Objects
end

function src.Classes.HxLocalEnum ()
	return require('..//object/HxLocalEnum').LocalEnum
end

function src.Classes.HxEnum ()
	error('refactor')
	--return require('..//object/HxLocalEnum/HxEnum').Enum
end

return src
local src = {};
src.Classes = {};
src.Abstract = {};

function src.Classes.HxObject ()
	return require('..//object/').Objects
end

function src.Classes.HxLocalEnum ()
	return require('..//object/HxLocalEnum').LocalEnum
end


--function src.Classes.HxEnum () return require('../HxLocalEnum/HxEnum').Enum end -- on build

return src
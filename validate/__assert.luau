local hexagon = require('../')
local checker = {};

-- used as a validator for all classes in build versions

function checker.classes (target: any)
	for _i,_v in target do
		local r : ()->any = assert(type(_v)=='function' and _v, 'class requester '.._i..' is not a function') :: any
		local v = r()
		
		assert(type(v) == 'table', 'class '.._i..' is not a table')
		assert(type(getmetatable(v))=='nil', 'class '.._i..' have a metatable in interface')
		
		local class : any = assert(type(v.class) == 'table' and v.class, 'class '.._i..' is not a table')
		local constr : any = assert(type(v.new) == 'function' and v.new, 'class '.._i..' does not have a constructor')
		
		assert(rawget(class, 'ClassName'), 'class '.._i..' does not have a ClassName')
		assert(not string.match(class.ClassName, 'Abstract'), 'class '.._i..' is abstract')
		assert(typeof(rawget(class, 'Source')) == 'Instance', 'class '.._i..' does not have a Source')
		assert(class.Source:IsA('ModuleScript'), 'class '.._i..' have a Source that is not a ModuleScript')
		
		if v.get then assert(type(v.get) == 'function', 'class '.._i..' does not have a getter as a function') end
		
		print('class '.._i..' is valid')
	end
	
	local meta = getmetatable(target)
	if type(meta) == 'table' and type(meta.__index) == 'table' then
		return checker.classes(meta.__index)
	end
	
	return true
end

function checker.abstracts (target: any)
	for _i,_v in target do
		local r : ()->any = assert(type(_v)=='function' and _v, 'class requester '.._i..' is not a function') :: any
		local v = r()
		
		assert(type(v) == 'table', 'class '.._i..' is not a table')
		assert(type(getmetatable(v))=='nil', 'class '.._i..' has a metatable in interface')
		
		local class : any = assert(type(v.class) == 'table' and v.class, 'class '.._i..' is not a table')
		local classname = assert(type(class.ClassName) == 'string' and class.ClassName, 'class '.._i..' does not have a ClassName')
		assert(string.match(classname, 'Abstract'), 'class '.._i..' is not abstract')
		
		print('abstract class '.._i..' is valid')
	end
	
	local meta = getmetatable(target)
	if type(meta) == 'table' and type(meta.__index) == 'table' then
		return checker.abstracts(meta.__index)
	end
	
	return true
end

function checker.mapping (target: any)
	for i,v in target do
		assert(type(i) == 'string', 'class '..i.. ' mapping key is not a string')
		assert(type(v) == 'string', 'class ' ..i.. ' mapping value is not a string')
		print('classname '..i..' is valid')
	end
	
	return true
end


checker.mapping(hexagon.Mapping);
checker.classes(hexagon.Classes);
checker.abstracts(hexagon.Abstract);

return checker
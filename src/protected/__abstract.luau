local private = {}
local abstract = {}

-- You should define this property as a procedure or default function. Without this, you will get an error.
function private.class_abstract_field (...: any)
	error('Descendant didnt override this abstract property')
end
-- You should define this property as a methode. Without this, you will get an error.
function private:class_self_abstract (...: any)
	error('Descendant didnt override this abstract property for himself')
end

private._i_overload=setmetatable({},{__mode='ks'})::any
function private.__index_overload (self,i)
	local target : any = private._overload[self][i];
	table.insert(private._i_overload[self],{req=i,rec=target})
	return target
end
private._n_overload=setmetatable({},{__mode='ks'})::any
function private.__new_overload (self, i,n)
	table.insert(private._n_overload[self], {new=i,old=self[i]})
	self[i]=n
end

private._overload=setmetatable({},{__mode='ks'})::any
private.mt={__index=private.__index_overload}
-- Logs read and write operations on the table.
@deprecated
function private.overload <t0,t1> (this:t0, target:t1)
	private._overload[this]=target
	private._i_overload[this]={}
	private._n_overload[this]={}

	setmetatable(this,private.mt)
	return this :: setmetatable<t0,t1>
end

@deprecated
function private.chain_Find (this, target)
	assert(type(this)=='table', string.format('@p1 must be a table, got %q', typeof(this)))
	warn(string.format('%q for %s, __index is %s', tostring(target), typeof(this), typeof(this.__index)))
	warn('Table', this, '__index', this.__index)

	if this[target] then
		warn('Found', this[target])
		return this[target]
	else
		if this.__index then
			return abstract.Find(this.__index :: any,target)
		else
			return nil
		end
	end
end
-- You should never call this function, because class does not involve its use
function private.class_overrided_error (...)
	return error('This function was overrided and cant be called')
end
-- You should never call this methode, because object does not involve its use
function private:class_self_overrided_error (...)
	return private.class_overrided_error(...)
end

abstract.ShouldOverrided = private.class_abstract_field
abstract.SelfOverride = private.class_self_abstract
abstract.LogM2 = private.overload
abstract.Find = private.chain_Find
abstract.ToNeverUse = private.class_overrided_error
abstract.SelfNeverUse = private.class_self_overrided_error

return abstract
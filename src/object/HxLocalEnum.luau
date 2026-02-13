local main = require('./')

local private = {}
local class = {}; class.__index=main.Objects.class; setmetatable(class,class);class.ClassName=main.ClassNames.HxLocalEnum
local interface = {}; interface.class=class

type function reg (name: type)
	local types = types
	return name:is('singleton') and name or types.string
end

private.registry = {}

function private.new <t0> (Name: t0?)
	local registryname = Name :: unknown
	assert(not private.registry[registryname], `enum "{registryname}" already exists`)
	
	
	local this = table.freeze(main.new({
		EnumName = (registryname or tostring(newproxy())) :: reg<t0>,
	},class))
	
	private.registry[registryname] = this::any
	return this 
end

function private.get <t0> (registryname: t0 & string) : typeof(private.new(''::t0))
	return private.registry[registryname::any]
end

function private:isEn (this: any) : boolean
	for i,v in private.registry do
		if v == this then
			return true
		end
	end
	return false
end


class.Source = script
class.EnumName = '';

interface.get=private.get
interface.IsEnum=private.isEn
interface.new=private.new

table.freeze(class)
table.freeze(private)
table.freeze(interface)

return main:expand({LocalEnum=interface})
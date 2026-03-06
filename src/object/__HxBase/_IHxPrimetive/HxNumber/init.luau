

local main = require('./')

local private = {}
local class = {};setmetatable(class,class);
local interface = {};

private.default = 0

type HxNumber = typeof(private.new())

--[[
	Creates new HxNumber object.

	@class HxNumber
	@return Instance (@P HxNumber)
]]
function private.new (value: number?)
	return main.new({Value = value :: number}, class)
end


--[[
	Post-increment (aka i++) is a function that returns the value of the HxNumber and then increments it.

	@class HxNumber
	@return number
]]
function private:ipp ()
	local self = self :: HxNumber
	local value = self.Value
	self.Value+=1
	return value
end

--[[
	Post-decrement (aka i--) is a function that returns the value of the HxNumber and then decrements it.

	@class HxNumber
	@return number
]]
function private:imm ()
	local self = self :: HxNumber
	local value = self.Value
	self.Value-=1
	return value
end

--[[
	Smoothly lerping that HxNumber to target value.

	@class HxNumber
	@return ()
]]
function private:smoothLerp (to: number)
	local self = self :: HxNumber 
	local c0 : RBXScriptConnection
	local runservice = game:GetService('RunService')
	c0 = runservice.Heartbeat:Connect(function(deltaTime: number) 
		self.Value=math.lerp(self.Value,to,deltaTime)
		if math.round(self.Value)==math.round(to) then
			c0:Disconnect()
		end
	end)
end
--[[
	Pushes HxNumber value to target value.	

	@class HxNumber
	@return ()
]]
function private:push (ToValue: number)
	local self = self :: HxNumber
	self.Value = ToValue
end

class.__index=main._IHxPrimetive.class
class.ClassName=main.ClassNames.HxNumber
class.Source=script
class['i++']=private.ipp
class['i--']=private.imm
class.Glide = private.smoothLerp
class.Push = private.push;

interface.class=class;
interface.new = private.new

return main:expand({Number=interface})
--!strict

local main = {}

function main.laucnh(at: Instance)
	for i,v in ipairs(at:GetDescendants()) do
		if v:IsA('ModuleScript') then
			local c = xpcall(require,function(a0) warn(a0,v) end,v) :: any
		end
	end
end

main.laucnh(script.Parent)
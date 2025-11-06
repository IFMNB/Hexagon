--!strict

local parent = require('./')

local private = {}
local plugin = {}




function private.DoCreateNewModel (self: element)
	local model = Instance.new('Model')
	
	model.Name = self.Name
	model.Parent = self.Parent
	self.Parent = model
	
	return model
end

function private.DoInsertPrimary (self: BasePart, mdl: Model)
	mdl.PrimaryPart = self
	return self
end














function private.DoCheck (self: element)
	return self:IsA('BasePart') or self:IsA('Attachment')
end


function private.DoRootModel (self: element)
	assert(private.DoCheck(self),'cant create model for unsupported type')
	return private.DoCreateNewModel(self)
end




function plugin.DoInjectToModel (self: element, to: Model)
	
end

function plugin.DoNewModel (self: element)
	return private.DoRootModel(self)
end



type element =  BasePart | Attachment

export type ancestors = self
export type self = typeof(plugin)

return plugin
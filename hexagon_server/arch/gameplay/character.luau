--!strict

local parent = require('../')
local ancestors = parent :: parent.hierarchy_server_start

local plugin = ancestors.GetPluginProvider()
local arch = ancestors.GetArchProvider()
local app = ancestors.GetAppProvider()
local wrd = arch.GetWorld()

local oop = plugin.GetOOP()
local rbxl = wrd.GetRobloxLink().GetClass()
local ent = app.GetEntity().GetClass()
local imp = plugin.GetImported()

local private = {}
local public = {}
local class = {}
local root = {}

function private.DoCreate (obj: obj)
	local function DoNewPart (obj: PVInstance)
		local part = Instance.new('Part')
		part.Name = obj.Name
		part.Size = Vector3.new(1, 1, 1)
		part.Parent = obj
		
		return part
	end
	
	local res = imp.switch(assert(obj.Parent, 'parent is nil').ClassName, {
		default = function (self: obj, parent: Instance)
			local mdl = Instance.new('Model')
			mdl.Name = 'Character'
			mdl.Parent = parent
			self.Parent = mdl
			return mdl
		end,
		Model = function (self: obj, parent: Model)
			if parent.PrimaryPart ~= self then
				if self:IsA('BasePart') then
					parent.PrimaryPart = self
				end
			end
		end,
	}, obj, obj.Parent)
end

function private.DoCreateNewCharacter (object: PVInstance)
	local char = {} :: _plChar
	
	oop.Expanding(char, public)
	return ent.New(char)
end































function public.GetFloorMaterial ()
	
end




function class.New (object: PVInstance) --: PlayeableCharacter
	
end



type obj = PVInstance|BasePart|Model

type _plChar = PlayeableCharacter & {
	_model: Model,
	_primary: PVInstance
}
export type PlayeableCharacter = typeof(ent.New({} :: public))

export type public = typeof(public)
export type ancestors = root & parent.hierarchy_server_start
export type root = typeof(root)
export type self = typeof(class)

function root.GetClass () return error('dev') end
oop.Expanding(root,ancestors)
return root
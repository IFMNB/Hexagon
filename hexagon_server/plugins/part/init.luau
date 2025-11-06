--!strict

local private = {}
local plugin = {}


function private.DoCreateNewPart (at: any)
	local cord : CFrame|Vector3? = at.CFrame or at.Position
	local t = typeof(cord)
	
	local part = Instance.new('Part')
	part.Name = at.Name
	part.Size = Vector3.new(1, 1, 1)
	part.Parent = at.Parent
	
	part:PivotTo(not t and CFrame.new() or t == 'Vector3' and CFrame.new(cord :: Vector3) or (cord :: CFrame))
	
	return part
end

function private.DoSetPhysic (at: Part)
	at.Massless = true
	at.CastShadow = false
	at.AudioCanCollide = false
	at.Transparency = 1
	return at
end


-- Указанный парт не будет взаимодействовать с другими объектами. Парт все еще доступен для физических операций.
function plugin.DoNonInteractable (at: Part) : Part
	return private.DoSetPhysic(at)
end

-- Создает парт, который копирует положение в пространстве другого объекта.
function plugin.Clone (at: Instance | PVInstance) : Part
	return private.DoCreateNewPart(at)
end

export type ancestors = self
export type self = typeof(plugin)

return plugin
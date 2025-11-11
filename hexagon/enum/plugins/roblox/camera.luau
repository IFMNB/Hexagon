--!strict

local hexEnum = require('../..')

local private = {}
local plugin = {}

private.CameraPriority = Enum.RenderPriority.Camera.Value-1
private.CurrentCameraFollow = nil

function private.DoGetCurrentCamera () : (Camera, CFrame)
	local camera = workspace.CurrentCamera or error(hexEnum.Roblox.Camera.Error.CurrentCamera)
	return camera, camera.CFrame
end

function private.DoUnbindCamera ()
	local camera = private.DoGetCurrentCamera()
	camera.CameraSubject = nil
	camera.CameraType = Enum.CameraType.Scriptable
	return
end

function private.CheckCurrentCamera ()
	return private.DoGetCurrentCamera().CameraSubject ~= nil
end

function private.DoCheckContext (name: string)
	if private.CheckCurrentCamera() then
		game["Run Service"]:UnbindFromRenderStep(name)
		return true
	end
	return false
end

function private.BindToSmooth ()
	local name = hexEnum.Roblox.Camera.SmoothMovement.Name
	local am = .8
	local fr = am^2
	local loc = {}

	function loc.calcDef (x:number,y:number) : number
		return (x*y)
	end

	game["Run Service"]:BindToRenderStep(name, private.CameraPriority, function (deltaTime: number)
		local cam, cfm = private.DoGetCurrentCamera()
		local t = deltaTime * fr

		local y = math.sin(t*am)
		local x = math.cos(math.abs(cfm.Y)) * am 
		local z = (x*y) * am
		
		cam.CFrame = CFrame.Angles(x*t, y*t, z*t) * cfm
	end)
	
	return name
end

function private.BindToFollow (follow: follow)
	private.DoUnbindCamera()
	local name = hexEnum.Roblox.Camera.SmoothFollow.Name
	local am, fr = 1.5, 2
	local min, max = 8, 15
	
	game["Run Service"]:BindToRenderStep(name, private.CameraPriority, function (deltaTime: number)
		local cam, cfm = private.DoGetCurrentCamera()
		local t = deltaTime * fr
		local d = t/am

		local lerpedPosition = cfm.Position:Lerp(follow.CFrame.Position, d)
		
		local offsetVector = lerpedPosition - follow.CFrame.Position
		local currentDistance = offsetVector.Magnitude
		local clampedDistance = math.clamp(currentDistance, min, max)

		if clampedDistance ~= currentDistance then
			local clampedOffset = offsetVector.Unit * clampedDistance
			lerpedPosition = follow.CFrame.Position + clampedOffset
		end

		cam.CFrame = cfm:Lerp(CFrame.lookAt(lerpedPosition, follow.CFrame.Position + (cam.CFrame.LookVector * 10)),d)
	end)
	
	return name
end

function private.BindToRotate (x: number?, y: number?, z: number?)
	--private.DoUnbindCamera()
	local name = hexEnum.Roblox.Camera.SmoothRotate.Name
	local am, fr = 1.5, 2
	local min, max = 8, 15

	game["Run Service"]:BindToRenderStep(name, private.CameraPriority, function (deltaTime: number)
		local cam, cfm = private.DoGetCurrentCamera()
		local t = deltaTime * fr
		cam.CFrame = cfm:Lerp(cfm*CFrame.Angles(x or 0,y or 0,z or 0), t/am)
	end)

	return name
end






type follow = BasePart
--
function plugin.DoCameraFollow (follow: follow)
	return private.BindToFollow(follow)
end

function plugin.DoSmoothCameraMovement ()
	return private.BindToSmooth()
end

function plugin.DoSmoothRotation (x:number?,y:number?,z:number?)
	return private.BindToRotate(x,y,z)
end

export type ancestors = self
export type self = typeof(plugin)

return plugin
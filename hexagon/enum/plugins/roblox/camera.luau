--!strict

local hexEnum = require('../..')

local private = {}
local plugin = {}

private.CameraPriority = Enum.RenderPriority.Camera.Value-1
private.CurrentCameraFollow = nil

function private.DoGetCurrentCamera ()
	local camera = workspace.CurrentCamera or error(tostring(hexEnum.Error.Never))
	return camera
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




function private.BindToSmooth (am: number?, fr: number?)
	local name = hexEnum.Roblox.Camera.SmoothMovement.Name
	local am = am or .8
	local fr = fr or 1.2
	local loc = {}

	function loc.calcDef (x:number,y:number) : number
		return (x*y)
	end

	game["Run Service"]:BindToRenderStep(name, private.CameraPriority, function (deltaTime: number)
		local cam = private.DoGetCurrentCamera()
		local cfm = cam.CFrame
		local t = deltaTime * fr

		local y = math.sin(t*am)
		local x = math.cos(math.abs(cfm.Y)) * am 
		local z = (x*y) * am
		
		cam.CFrame = CFrame.Angles(x*t, y*t, z*t) * cfm
	end)
	
	return name
end

type follow = BasePart|Attachment
function private.BindToFollow (follow: follow, am: number?, fr: number?, mind: number?, maxd: number?)
	private.DoUnbindCamera()
	local name = hexEnum.Roblox.Camera.SmoothFollow.Name
	local am, fr = am or 1.5, fr or  2
	local min, max = mind or 8, maxd or 15
	
	game["Run Service"]:BindToRenderStep(name, private.CameraPriority, function (deltaTime: number)
		local cam = private.DoGetCurrentCamera()
		local cfm = cam.CFrame
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

function private.BindToRotate (x: Radian?, y: Radian?, z: Radian?, am: number?, fr: number?)
	private.DoUnbindCamera()
	local name = hexEnum.Roblox.Camera.SmoothRotate.Name
	local am, fr = am or 1.5, fr or 2
	local min, max = 8, 15

	game["Run Service"]:BindToRenderStep(name, private.CameraPriority, function (deltaTime: number)
		local cam = private.DoGetCurrentCamera()
		local cfm = cam.CFrame
		local t = deltaTime * fr
		cam.CFrame = cfm:Lerp(cfm*CFrame.Angles(x or 0,y or 0,z or 0), t/am)
	end)

	return name
end

function private.BindLookToCam (element: BasePart, am: number?, fr: number?)
	private.DoUnbindCamera()
	local name = hexEnum.Roblox.Camera.SmoothWatchCamera.Name
	local fr, am = fr or .5, am or .5

	game["Run Service"]:BindToRenderStep(name, private.CameraPriority, function(deltaTime: number) 
		local cam = private.DoGetCurrentCamera()
		local cfm = cam.CFrame
		local cur = element.CFrame
		local delta = deltaTime/fr

		local tar = cfm.Position+cfm.LookVector*50
		element.CFrame = cur:Lerp(CFrame.lookAt(cur.Position,tar),delta*am)
	end)

	return name
end


type BindCameraToLockAt = BasePart | Attachment
function private.BindCameraToLockAt (element: BindCameraToLockAt,am: number?, fr: number?)
	private.DoUnbindCamera()
	local name = hexEnum.Roblox.Camera.SmoothWatchCamera.Name
	local fr, am = fr or .5, am or.5
	
	game["Run Service"]:BindToRenderStep(name, private.CameraPriority, function (deltaTime: number)
		local cam = private.DoGetCurrentCamera()
		local cfm = cam.CFrame
		local cur = element.CFrame
		local delta = deltaTime/fr
		
		cam.CFrame = cfm:Lerp(CFrame.lookAt(cfm.Position, element.CFrame.Position), delta*am)
	end)
	
	return name
end

function private.BindCameraToPosAt (element: BindCameraToLockAt, am: number?, fr: number?)
	private.DoUnbindCamera()
	local name = hexEnum.Roblox.Camera.SmoothCameraPosition.Name
	local am, fr = am or .5, fr or .7
	
	game["Run Service"]:BindToRenderStep(name, private.CameraPriority, function (deltaTime: number)
		local cam = private.DoGetCurrentCamera()
		local cfm = cam.CFrame
		local cur = element.CFrame
		local delta = deltaTime/fr
		
		cam.CFrame = cfm:Lerp(CFrame.new(element.Position)*cfm.Rotation, delta*am)
	end)
	
	return name
end



-- Камера будет двигаться сглаженней чем обычно.
function plugin.DoSmoothMovement (Frequency: number?, Amplitude: number?)
	return private.BindToSmooth(Amplitude, Frequency)
end
-- Камера будет постоянно поворачиваться в указанном направлении.
function plugin.DoSmoothRotation (x:number?,y:number?,z:number?, Frequency: number?, Amplitude: number?)
	return private.BindToRotate(x,y,z, Amplitude, Frequency)
end




-- Указанная цель будет иметь постоянный плавный поворот в точку, в которую смотрит камера на данный момент.
function plugin.SetSmoothWatchToCamera (target: BasePart, Frequency: number?, Amplitude: number?)
	return private.BindLookToCam(target, Amplitude, Frequency)
end



-- Камера будет следовать за целью, сохраняя дистанцию и проворачиваясь по направлению к цели.
function plugin.BindSmoothFollowTo (follow: follow, MinDistance: number?, MaxDistance: number?, Frequency: number?, Amplitude: number?)
	return private.BindToFollow(follow, Amplitude, Frequency, MinDistance, MaxDistance)
end
-- Камера будет сглаженно смотреть в сторону цели.
function plugin.BindSmoothCameraToLook (at: BindCameraToLockAt, Frequency: number?, Amplitude: number?)
	return private.BindCameraToLockAt(at, Amplitude, Frequency)
end
-- Камера будет сглаженно двигаться в текущую позицию цели.
function plugin.BindSmoothCameraToPosition (at: BindCameraToLockAt, Frequency: number?, Amplitude: number?)
	return private.BindCameraToPosAt(at, Amplitude, Frequency)
end



function plugin.GetCamera ()
	return private.DoGetCurrentCamera()
end

type Radian = number

export type ancestors = self
export type self = typeof(plugin)

return plugin
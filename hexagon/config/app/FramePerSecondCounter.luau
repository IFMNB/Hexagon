--!strict

local app = require('./')
local ent = app.Arch().GetSystem().GetEntity()
local cfg = app.Config()
local shd = app.GetPluginProvider().GetShadow()

local main = {}
local counter = ent.New({
	Current = 0,
	PreviousSecond = 0,
	FrameId = 0,
	InThisSecondCounted = 0,
	CheckTime = 0
}::raw)
local shade : shade = shd.New(counter)


function main.Update ()
	counter.FrameId += 1
	counter.InThisSecondCounted += 1
end

function main.Task ()
	while task.wait(1) do
		counter.CheckTime = tick()
		counter.Current = counter.InThisSecondCounted
		counter.InThisSecondCounted = 0
		counter.PreviousSecond = counter.Current
	end
end

function main.Handler (self: { [any]: any }, index, newindex, oldindex) 
	if newindex == true then
		if not shade.RunSignal then
			shade.RunSignal = game["Run Service"].RenderStepped:Connect(main.Update)
			shade.TaskSignal = task.spawn(main.Task)
		end
	else
		if shade.RunSignal then
			shade.RunSignal:Disconnect()
			shade.RunSignal = nil
		end
		if shade.TaskSignal then
			task.cancel(shade.TaskSignal)
			shade.TaskSignal=nil
		end
	end
end

main.Handler({},nil,cfg.FramesPerSecond,nil)
shade.ScriptSignal = cfg.Changed:For('FramesPerSecond', main.Handler)

type shade = {
	ScriptSignal: typeof(cfg.Changed:Connect({}::any)),
	RunSignal: RBXScriptConnection?,
	TaskSignal: thread?
}

type raw = {
	Current: number,
	PreviousSecond: number,
	FrameId: number,
	InThisSecondCounted: number,
	CheckTime: number
}

return counter
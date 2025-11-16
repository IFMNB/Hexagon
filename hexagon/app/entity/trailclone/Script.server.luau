--!strict

local tc = require('./').GetClass()
local b = tc.New(workspace.Part)

print(b.ChangedSignal.Once, b.ChangedSignal, b.ChangedSignal.Reset, b.ChangedSignal.Connect, b.ChangedSignal.ClassName)

b.Lifetime = 6
b.Max = 2

b:Play()
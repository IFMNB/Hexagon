--!strict

local constr = require('./').GetClass()

local b = constr.New(4345)

task.wait(5)

local a = {
	b.ClassName,b.Identificator,b.Pause,b.Resume,b.Reset,b.Identificator,b.ChangedSignal,b.AncestorName
}

print(a, b.time)
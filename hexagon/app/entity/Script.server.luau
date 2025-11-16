--!strict

local ent = require('./').GetClass()

local b = ent.New({c = 4})
local a = {b.ClassName, b.ChangedSignal, b.Identificator, b:AncestorName(), b.c}

print(a)
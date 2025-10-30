--!strict

-- Класс реализует семью базовых персонажей, действующих аналогично коду гуманоида роблокс, но подчиняющийся собственным алгоритмам.

local parent = require('./')
local ancestors = parent :: parent.ancestors

local provider = ancestors.GetArchProvider()
local plugin = ancestors.GetPluginProvider()
local 
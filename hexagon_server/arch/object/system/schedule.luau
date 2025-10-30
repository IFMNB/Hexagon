--!strict


local parent = require('./')
local ancestors = parent :: parent.ancestors

local plugins = ancestors.GetPluginProvider()
local oop = plugins.GetOOP()
local imp = plugins.GetImported()
local mt = plugins.GetMeta()
local obj = ancestors.GetArchProvider().GetObject()

local private = {}
local public = {}
local class = {}
local root = {}

private.ScheduleClassName = 'Schedule' :: 'Schedule'


function private.DoNewScheduleClass () : Schedule
	local Schedule = {} :: _schedule
	
	Schedule._schedule = {}
	
	oop.Expanding(Schedule, public)
	return obj.New(Schedule, private.ScheduleClassName)
end







-- Класс безопасно выполняет 1 задачу параллельно с основным потоком каждый Heartbeat.
function class.New () : Schedule
	return private.DoNewScheduleClass()
end


type func = (...any)->result
type result = any
--[[
type error_msg = string
type manager = (self: task, option: result)->()
type handler = (self: task, option: error_msg)->()
]]
type task = {_f: func, _a: {any}}

type _schedule = Schedule & {
	_schedule: {task},
}
export type Schedule = typeof(obj.New({} :: public, private.ScheduleClassName))

type public = typeof(public)
export type ancestors = root & parent.ancestors
export type root = typeof(root)
export type self = typeof(class)

-- Используется как планировщик задач.
function root.GetSchedule () return class end
oop.Expanding(root, parent)
return root
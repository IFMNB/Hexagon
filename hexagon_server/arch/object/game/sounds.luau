--!strict

local parent = require('./')
local ancestors = parent :: parent.ancestors

local plugin = ancestors.GetPluginProvider()
local oop = plugin.GetOOP()
local mt = plugin.GetMeta()
local imp = plugin.GetImported()


local private = {}
local public = {}
local constr = {}

function private.createNewOstList ()
	
end
















function constr.newOst ()
	
end



type _ostList = {
	
} & OstList
type OstList = public

type public = typeof(public)
export type ancestors = self & parent.ancestors
export type self = typeof(constr)

return constr
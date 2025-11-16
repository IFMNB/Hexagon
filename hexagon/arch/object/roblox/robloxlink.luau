--!strict

local parent = require('../')
local ancestors = parent :: parent.ancestors

local provider = ancestors.GetPluginProvider()
local oop = provider.GetOOP()
local mt = provider.GetMeta()
local obj = ancestors.GetObject()
local lnk = provider.GetLinker()

local private = {}
local public = {}
local class = {}
local root = {}

private.links = {} :: {[Instance]: typeof(mt.SetMode({} :: store, 'v'))}
private.instances = mt.SetMode({} :: {[_rbxLink]: Instance}, 'k')
private.classname = 'RobloxLink' :: 'RobloxLink'

function private.DoNewClientStore (self: Instance)
	local store = mt.SetMode({} :: store, 'v')
	private.links[self]=store
	return store
end

function private.GetClientStore (self: Instance)
	return private.links[self]
end

function private.DoInsertToClientStore (self: store, link: _rbxLink)
	table.insert(self, link)
	return self
end

function private.DoExtendsClient (self: _rbxLink, client: Instance)
	mt.SpecifyTo(self, client)
	private.instances[self]=client
	client.Destroying:Once(function() 
		private.links[client][assert(table.find(private.links[client], self), 'unable to find pos for destroyed RobloxLink')] = nil
	end)
	return self
end

function private.DoNewRobloxLink ()
	local link = {} :: _rbxLink
	oop.Expanding(link, public)
	
	local object = obj.New(link, private.classname)
	lnk.LinkTo(link, object)
	return object
end



function private.DoLinkInstance (self: Instance)
	local link = private.DoNewRobloxLink()
	--local store = private.GetClientStore(self) or private.DoNewClientStore(self)
	--private.DoInsertToClientStore(store, link)
	--private.DoExtendsClient(link, self)
	
	private.instances[link]=self
	self.Destroying:Once(function() 
		private.instances[link]=nil
	end)
	
	return link
end


function private.DoGetRobloxInstance (self: _rbxLink)
	return private.instances[self]
end






-- Returns the original roblox instance.
function public.GetRobloxInstance (self: RobloxLink) : Instance?
	return private.DoGetRobloxInstance(self)
end





-- Instances of this class will be automatically collected if the original roblox instance is deleted.
function class.New (self: Instance) : RobloxLink
	return private.DoLinkInstance(self)
end


type store = {_rbxLink}
type _rbxLink = {} & RobloxLink
export type RobloxLink = public

type public = typeof(public)

export type ancestors = root & parent.ancestors
export type root = typeof(root)
export type self = typeof(class)

-- Wraps the Roblox instance in a working wrapper for __GC.
function root.GetClass () return class end
oop.Expanding(root, parent)
return root
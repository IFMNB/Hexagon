--!strict

-- Категоризирует всех участников раунда и автоматически обрабатывает события в раунде

local parent = require('./')
local ancestors = parent :: parent.ancestors

local plugin = ancestors.GetPluginProvider()
local oop = plugin.GetOOP()
local imp = plugin.GetImported()
local mt = plugin.GetMeta()
local watch = ancestors.GetArchProvider().GetSystem().GetWatcher().GetWatch()
local rbxlink = ancestors.GetArchProvider().GetWorld().GetRobloxLink().GetLink()


type RobloxLink = typeof(rbxlink.New(({}::any) :: Player))

local private = {}
local public = {}
local class = {}
local root = {}



private.links = mt.SetMode({} :: {[Player]: RobloxLink}, 'v')











function public.GetTag (self: Round, name: keyof<_round_tags>)
	return private.GetTaggedByNameFromRound(self :: _round, name)
end

function public.GetRole (self: Round, player: Player)
	return private.GetPlayerRole(self :: _round, private.RootLink(player))
end

function public.SetRole (self: Round, player: Player, role: roles) : Round
	return private.SetNamedRoleToThisPlayer(self :: _round, private.RootLink(player), role)
end

function public.GetAllActive (self: Round) : ActiveRbxLinksPlayers
	return private.GetInsideRound(self :: _round)
end

function public.IsActivePlayer (self: Round, player: Player )
	return private.CheckThisPlayerIsActiveForRound(self :: _round, private.RootLink(player))
end

function public.MakePlayerActive (self: Round, player: Player) : Round
	return private.SetThisPlayerToActiveInThisRound(self :: _round, private.RootLink(player))
end

function public.MakePlayerInactive (self: Round, player: Player) : Round
	return private.DestroyPlayer(self :: _round, private.RootLink(player)) :: Round
end

function public.MakePlayersInactive (self: Round)
	return private.DestroyAllPlayers(self :: _round)
end

function public.SetState (self: Round, state: round_states) : Round
	return private.SetRoundStateTo(self :: _round, state)
end

function public.GetState (self: Round) : round_states
	return private.GetRoundState(self :: _round)
end

function public.End (self: Round)
	return private.CancelThisRound(self :: _round)
end



function class.New (self: ActivePlayers)
	return private.New(self) :: Round
end



type ActivePlayers = {Player}
type ActiveRbxLinksPlayers = {RobloxLink}
type PlayerUsedRole = {[Player]:role_container}
type ContainerName = string
type role_container = {RobloxLink}
type roles = keyof<_round_container>
type round_states = 'run'|'escape'|'last'|'end'|'started'|'canceled'

type _round_container = {
	survivor: role_container,
	murder: role_container,
	watcher: role_container,
	dead: role_container,
	lastlife: role_container,
	revived: role_container,
	unknown: role_container
	--[ContainerName]: role_container
} 
type _round_tags = {
	_roles: PlayerUsedRole
}
type _round = {
	_inside: ActiveRbxLinksPlayers,
	_tags: _round_tags,
	_container: _round_container,
	_invert: {
		[role_container]: ContainerName
	},
	_state: round_states
} & Round
type Round = public

type public = typeof(public)
export type ancestors = self
export type self = typeof(class)

return class
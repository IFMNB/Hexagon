--!strict

-- Категоризирует всех участников раунда и автоматически обрабатывает события в раунде

local parent = require('../')
local ancestors = parent :: parent.hierarchy_server_start

local app = ancestors.GetAppProvider()
local arch = ancestors.GetArchProvider()
local plugin = ancestors.GetPluginProvider()

local oop = plugin.GetOOP()
local imp = plugin.GetImported()
local mt = plugin.GetMeta()
local rbxl = plugin.GetReference()

local ent = arch.GetSystem().GetEntity().GetClass()
local obj = arch.GetObject()
local sys = arch.GetSystem()


type Entity <this> = typeof(ent.New({} :: this))

local private = {}
local public = {}
local class = {}
local root = {}


private.Error = {}
private.Error.PlayerIsNotExists = 'Player is not exists in round'
private.RoundClassName = 'Round' :: 'Round'

function private.DoCreateNewRound () : Round | _round
	local rnd = {} :: _round
	local state : public_state_raw = {} :: any
	state.Is = 'Pre-start'
	
	
	rnd._players = ent.New(mt.SetMode({}, 'v'))
	rnd._roles = mt.SetMode({}, 'k') :: any
	
	rnd._container = {} :: any
	rnd._container.unknown = ent.New(mt.SetMode({}, 'v'))
	rnd._container.murder = ent.New(mt.SetMode({}, 'v'))
	rnd._container.survivor = ent.New(mt.SetMode({}, 'v'))
	rnd._container.spectator = ent.New(mt.SetMode({}, 'v'))
	rnd._container.dead = ent.New(mt.SetMode({}, 'v'))
	--rnd._container.last = ent.New(mt.SetMode({}, 'v'))
	rnd._container.revived = ent.New(mt.SetMode({}, 'v'))
	
	rnd._public = {} :: any
	rnd._public.status = ent.New(state) :: public_state
	
	oop.Expanding(rnd, public)
	return obj.New(rnd, private.RoundClassName)
end

function private.GetPlayerInRound (self: _round, player: Player) : RobloxLink?
	for i=1, #self._players do
		local p = self._players[i]
		if p:GetRobloxInstance() == player then
			return p
		end
	end
	return nil
end

function private.DoAssertGetPlayerInRound (self: _round, player: Player)
	return assert(private.GetPlayerInRound(self, player), private.Error.PlayerIsNotExists)
end

function private.DoGetRole (self: _round, player: Player)
	return self._roles[private.DoAssertGetPlayerInRound(self, player)]
end

function private.CheckIsPlayerInRound (self: _round, player: Player)
	return not not private.GetPlayerInRound(self, player)
end

function private.DoGetRoundEntityRole (self: _round, role: RoundRoles) : RoundEntity
	return (self._container :: {[string]:RoundEntity})[role]
end

function private.DoInsertPlayerToRole (self: _round, player: RobloxLink, role: RoundRoles)
	table.insert(private.DoGetRoundEntityRole(self, role), player)
	self._roles[player]=role
	return self
end

function private.DoInsertNewPlayer (self: _round, player: RobloxLink)
	table.insert(self._players , player)
	private.DoInsertPlayerToRole(self, player, 'unknown')
	return self
end

function private.DoCreateNewPlayer (self: _round, player: Player)
	local plr = rbxl.New(player)
	private.DoInsertNewPlayer(self, plr)
	return self
end

function private.DoGetPublicRoundData (self: _round)
	return self._public
end

function private.DoDestroyPlayerInRound (self: _round, player: Player)
	local plr = private.DoAssertGetPlayerInRound(self, player)
	local rol = self._roles[plr]
	local rE = private.DoGetRoundEntityRole(self, rol)
	self._roles[plr]=nil
	table.remove(self._players, table.find(self._players, plr))
	table.remove(rE, table.find(rE, plr))
	return self
end





function public.DoInsertPlayer (self: Round, player: Player) : Round
	return private.DoCreateNewPlayer(self :: _round, player)
end

function public.DoUninsertPlayer (self: Round, player: Player) : Round
	return private.DoDestroyPlayerInRound(self :: _round, player)
end

function public.DoSetPlayerRole (self: Round, player: Player, Role: RoundRoles) : Round
	return private.DoInsertPlayerToRole(self :: _round, private.DoAssertGetPlayerInRound(self :: _round, player), Role)
end

function public.GetPlayerRole (self: Round, player: Player) : RoundRoles
	return private.DoGetRole(self :: _round, player)
end

function public.IsPlaying (self: Round, player: Player) : boolean
	return private.CheckIsPlayerInRound(self :: _round, player)
end

function public.GetRoleContainer (self: Round, Role: RoundRoles) : RoundEntity
	return private.DoGetRoundEntityRole(self :: _round, Role)
end

function public.GetPublic (self: Round) : RoundPublic
	return private.DoGetPublicRoundData(self :: _round)
end

















function class.New ()
	return private.DoCreateNewRound()
end

type RobloxLink = {}
type RoundPlayerCurrentRole = {[RobloxLink]: RoundRoles}
type RoundEntity = Entity<typeof(mt.SetMode({} :: {RobloxLink}, {}::any))>
type RoundRoles = keyof<RoundObject>
type round_states = 'Run'|'End'|'Last'|'Pre-start'|'Cancel'|'Error'

type RoundObject = {
	survivor: RoundEntity,
	murder: RoundEntity,
	spectator: RoundEntity,
	dead: RoundEntity,
	revived: RoundEntity,
	unknown: RoundEntity
	--[ContainerName]: RoundEntity
} 

type public_state_raw = {Is: round_states}
type public_state = Entity<public_state_raw>
type RoundPublic = {
	status: public_state
}
type _round = Round & {
	_players: RoundEntity,
	_roles: RoundPlayerCurrentRole,
	_container: RoundObject,
	_public: RoundPublic
} 
type Round = typeof(obj.New({} :: public, private.RoundClassName))

export type public = typeof(public)
export type ancestors = root & parent.hierarchy_server_start
export type root = typeof(root)
export type self = typeof(class)


function root.GetClass () return class end
oop.Expanding(root, ancestors)
return root
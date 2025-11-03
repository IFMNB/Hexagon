--!strict

-- Категоризирует всех участников раунда и автоматически обрабатывает события в раунде

local parent = require('./')
local ancestors = parent :: parent.ancestors

local arch = ancestors.GetArchProvider()
local plugin = ancestors.GetPluginProvider()

local oop = plugin.GetOOP()
local imp = plugin.GetImported()
local mt = plugin.GetMeta()

local obj = arch.GetObject()
local sys = arch.GetSystem()
local watch = sys.GetWatcher().GetWatch()
local col = sys.GetCollection().GetCollections()
local rbxlink = arch .GetWorld().GetRobloxLink().GetLink()

type Collection = typeof(col.New())
type RobloxLink = typeof(rbxlink.New(({}::any) :: Player))

local private = {}
local public = {}
local class = {}
local root = {}

private.RoundClassName = 'Round'

function private.DoCreateNewRound () : Round | _round
	local rnd = {} :: _round
	
	rnd._players = col.New()
	rnd._container = col.New()
	rnd._public = {} :: any
	rnd._public._state = {} :: any
	rnd._public._state.state = 'init'
	
	oop.Expanding(rnd, public)
	return obj.New(rnd, private.RoundClassName)
end
















function class.New ()

end



type ActivePlayers = {Player}
type ActiveRbxLinksPlayers = {RobloxLink}
type PlayerUsedRole = {[Player]:role_container}
type ContainerName = string
type role_container = {RobloxLink}
type roles = keyof<_round_container>
type round_states = 'running'|'escaped'|'LMS'|'ended'|'started'|'canceled'|'init'

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
type public_state = {
	state: round_states
}
type _public_round = {
	_state: public_state
}
type _round = {
	_players: Collection,
	_container: Collection, --_round_container,
	_public: _public_round
} & Round
type Round = public

type public = typeof(public)
export type ancestors = self
export type self = typeof(class)

return class
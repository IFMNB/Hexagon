--!strict

-- Категоризирует всех участников раунда и автоматически обрабатывает события в раунде

local parent = require('./')
local ancestors = parent :: parent.ancestors

local app = ancestors.GetAppProvider()
local arch = ancestors.GetArchProvider()
local plugin = ancestors.GetPluginProvider()

local oop = plugin.GetOOP()
local imp = plugin.GetImported()
local mt = plugin.GetMeta()

local ent = app.GetEntity().GetClass()
local obj = arch.GetObject()
local sys = arch.GetSystem()
local rbxl = arch.GetWorld().GetRobloxLink().GetLink()

type Entity <this> = typeof(ent.New({} :: this))
type RobloxLinkPlayer = typeof(rbxl.New(({}::any) :: Player))

local private = {}
local public = {}
local class = {}
local root = {}

private.RoundClassName = 'Round' :: 'Round'

function private.DoCreateNewRound () : Round | _round
	local rnd = {} :: _round
	
	rnd._players = ent.New({})
	
	rnd._container = {} :: any
	rnd._container.unknown = ent.New({})
	rnd._container.murder = ent.New({})
	rnd._container.survivor = ent.New({})
	rnd._container.watcher = ent.New({})
	rnd._container.dead = ent.New({})
	rnd._container.last = ent.New({})
	rnd._container.revived = ent.New({})
	
	rnd._public = {} :: any
	rnd._public.round_status = ent.New({state = 'init'}) :: public_state
	
	oop.Expanding(rnd, public)
	return obj.New(rnd, private.RoundClassName)
end







function class.New ()
	return private.DoCreateNewRound()
end



type RoundEntity = Entity<{RobloxLinkPlayer}>
type RoundRoles = keyof<RoundObject>
type round_states = 'running'|'escaped'|'LMS'|'ended'|'started'|'canceled'|'init'

type RoundObject = {
	survivor: RoundEntity,
	murder: RoundEntity,
	watcher: RoundEntity,
	dead: RoundEntity,
	last: RoundEntity,
	revived: RoundEntity,
	unknown: RoundEntity
	--[ContainerName]: RoundEntity
} 
type public_state = Entity<{state: round_states}>
type _public_round = {
	round_status: public_state
}
type _round = Round & {
	_players: RoundEntity,
	_container: RoundObject,
	_public: _public_round
} 
type Round = typeof(obj.New({} :: public, private.RoundClassName))

export type public = typeof(public)
export type ancestors = root & parent.ancestors
export type root = typeof(root)
export type self = typeof(class)


function root.GetClass () return class end
oop.Expanding(root, ancestors)
return root
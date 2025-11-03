--!strict

local parent = require('./')
local ancestors = parent :: parent.ancestors

local hooks = parent.GetHooks()
local provider = ancestors.GetPluginProvider()
local mt = provider.GetMeta()
local oop = provider.GetOOP()
local obj = ancestors.GetObject()
local tbl = provider.GetTable()

local private = {}
local public_link = {}
local public = {}
local class = {}
local root = {}

private.global = hooks.NewParams()
	:SetIterator(function(fabric, origin): ("never" | any)? 
		local _WatcherParams = private.getWatcherParamsByHook(fabric.hook)
			
		private.doIterateLinks(_WatcherParams._me.once, origin)
		private.doIterateLinks(_WatcherParams._me.cons, origin)
		_WatcherParams._me.once = {}
		
		return 'never'
	end)
	:BindTo('__newindex')
	:DoOverride('never')
	:Resume()
private.WatcherClassName = 'Watcher' :: 'Watcher'
private.WatcherParamsClassName = 'WatcherParams' :: 'WatcherParams'
private.WatcherConnectionClassName = 'WatcherLink' :: 'WatcherLink'
private.watchers = mt.SetMode({} :: {[Watcher]:_WatcherParams}, 'k')
private.links = mt.SetMode({} :: {[WatcherLink]: Watcher}, 'v')
--private.objectlinks = mt.SetMode({} :: {[{}]: WatcherLink}, 'v')

function private.getWatcherParamsByHook (self: Watcher)
	return private.watchers[self]
end

function private.doIterateLinks (self: {func}, origin: any)
	for i=1, #self do
		self[i](origin.client, origin.index, origin.new, origin.old)
	end
end





-- Объект хука с присвоенным private.global
function private.newWatcher (self: _client)
	local watcher = hooks.New(self, private.global)
	private.watchers[watcher]=private.newWatcherParams(watcher)
	return watcher
end
-- Параметры для итератора. Они не совпадают с параметрами самого хука.
function private.newWatcherParams (self: Watcher)
	local params = {} :: _WatcherParams
	
	params._me = {} :: any
	params._me.once = {}
	params._me.cons = {}
	
	oop.Expanding(params, public)
	local object = obj.New(params, private.WatcherParamsClassName)
	
	return object
end


function private.createNewConnectionLink (self: func)
	local link = {} :: _WatcherLink
	
	link._func = self
	link._in = 'never'
	
	oop.Expanding(link, public_link)
	local object = obj.New(link, private.WatcherConnectionClassName)
	--private.objectlinks[object]=link
	
	return object
end

function private.setLinkIn (self: _WatcherLink, linkIn: _in)
	self._in = linkIn
	return self
end


function private.get_me (self: _WatcherParams)
	return self._me :: {[string]: {func}}
end

function private.addNewLink (self: _WatcherParams, func: func, to: keyof<_me>)
	local me = private.get_me(self)
	local link = private.createNewConnectionLink(func)

	table.insert(me[to], func)
	private.setLinkIn(link, to)
	local hook = tbl.getKey(private.watchers, self) :: Watcher
	private.links[link]=hook

	return link
end

function private.addNewOnceConnection (self: _WatcherParams, func: func)
	return private.addNewLink(self, func, 'once')
end

function private.addNewConnection (self: _WatcherParams, func: func)
	return private.addNewLink(self, func, 'cons')
end

function private.disconnectLink (self: _WatcherLink)
	local watcher = private.links[self] :: Watcher 
	local watcherParams = private.getWatcherParamsByHook(watcher)
	
	local me = private.get_me(watcherParams)

	table.remove(me[self._in], table.find(me[self._in], self._func))
	
	return
end

function private.disconnectAll (self: _WatcherParams)
	for i,v in pairs(self._me :: {[string]: {WatcherLink}}) do
		for i,v in v do
			v:Disconnect()
		end
	end
	return self
end






-- Создает одиночное соединение. Возвращает WatcherLink.
function public.Once (self: WatcherParams, func: func)
	return private.addNewOnceConnection(self :: _WatcherParams, func) :: WatcherLink
end
-- Создает постоянное соединение. Возвращает WatcherLink.
function public.Connect (self: WatcherParams, func: func)
	return private.addNewConnection(self :: _WatcherParams, func) :: WatcherLink
end
-- Отключает все WatcherLink.
function public.DoDisconnectAll (self: WatcherParams)
	return private.disconnectAll(self :: _WatcherParams)
end
-- Отключает текущий WatcherLink.
function public_link.Disconnect (self: WatcherLink)
	return private.disconnectLink(self :: _WatcherLink)
end




-- Создает объект Watcher. Аналогичен ScriptSignal.
function class.NewWatcher <this> (self: this & _client)
	return private.newWatcher(self) :: Watched<this>
end
-- Элементы управления Watcher.
function class.GetWatherParams (self: Watcher)
	return private.getWatcherParamsByHook(self) :: WatcherParams
end


type _client = {}|{[any]:any}
type _once = {func}
type _cons = {func}
type _me = {
	once: _once,
	cons: _cons
}
type _in = keyof<_me>|'never'

type func = (self: _client, index: any, newindex: any, oldindex: any)->()

type _WatcherParams = {
	_me: _me
} & WatcherParams
type _WatcherLink = {
	_func: func,
	_in: _in
} & WatcherLink


export type WatcherLink = public_link
export type WatcherParams = public
export type Watcher = parent.Hook
type Watched <this> = this & Watcher

type public_link = typeof(public_link)
type public = typeof(public)
export type ancestors = self & parent.ancestors
export type self = typeof(class)

-- Сохраняет идею хуков, но по факту представляет Signal класс в другом виде. Не поддерживается. Используется для отслеживания изменений в объекте. Эмулирует RBXScriptSignal.
@deprecated
function root.GetWatch () return class end
oop.Expanding(root, ancestors)
return root
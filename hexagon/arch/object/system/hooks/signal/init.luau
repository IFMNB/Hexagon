--!strict

-- Классы этого типа должны быть инжекнуты в объект для использования.
-- TODO: Когда-нибудь класс должен будет автоматически подтягивать собственные сигнатуры функций для своих детей,
-- но сейчас мне лень возиться с типами.

local parent = require('./')
local ancestors = parent :: parent.ancestors

local plugin = ancestors.GetPluginProvider()

local hook = parent.GetHooks()
local obj = ancestors.GetObject()

local imp = plugin.GetImported()
local oop = plugin.GetOOP()
local mt = plugin.GetMeta()

local private = {}
local public_link = {}
local public_protect = {}
local public = {}
local protected = {}
local class = {}
local root = {}

private.SignalClassName = 'Signal' :: 'Signal'
private.SignalLinkClassName = 'SignalLink' :: 'SignalLink'

private.links = mt.SetMode({} :: links, 'v')
private.sigp = mt.SetMode({} :: sigp, 'k')

type links = {[_sig_l]: _sig}
type sigp = {[_sig]: parent.HookParams}


function private.DoGetAllObservers (self: _sig) : obs_typ
	return self._observers :: any
end

function private.DoGetOriginParams (self: _sig)
	local params = private.sigp[self]
	assert(params, 'fail to catch HookParams.')
	return params
end

function private.DoSaveOriginParams (self: {}, params: parent.HookParams)
	private.sigp[self]=params
	return self
end

function private.DoCreateNewSignal () : Signal | SignalProtected | _sig
	local sig = {} :: _sig
	
	sig._observers = {} :: any
	sig._observers._once = {}
	sig._observers._cons = {}
	
	local params = hook.NewParams()
	
	params:SetIterator(function(fabric, origin): ("never" | any)? 
		local observers = private.DoGetAllObservers(sig)
		
		for i,v in pairs(observers) do
			for i=1, #v do
				local l = v[i]
				l._f(origin.client,origin.index,origin.new,origin.old)
			end
			
			imp.switch(i, {
				default = function (i, v) error(tostring(i)..' - unknown list') end,
				_once = function (i, v: listSL) for i=1, #v do v[i]=nil end end
			}, i,v)
		end
		
		return 'never'
	end)
	

	oop.Expanding(sig, params)
	oop.Expanding(sig, public_protect)
	local o = obj.New(sig, private.SignalClassName)
	private.DoSaveOriginParams(o, params)
	return o
end















function private.DoCreateNewLink (func: func) : SignalLink | _sig_l
	local link = {} :: _sig_l
	
	link._f = func
	
	oop.Expanding(link, public_link)
	return obj.New(link, private.SignalLinkClassName)
end

function private.DoSetTypeLink (self: _sig_l, to: keyof<observers>)
	self._t = to
	return self
end

function private.DoSetSignalLink (self: _sig_l, to: _sig)
	private.links[self]=to
	return self
end

function private.DoSetNewLink (self: _sig, func: func, to: keyof<observers>)
	local link = private.DoCreateNewLink(func) :: _sig_l
	local obs = private.DoGetAllObservers(self)
	
	private.DoSetSignalLink(link, self)
	private.DoSetTypeLink(link, to)
	table.insert(obs[to], link)
	
	return link
end

function private.DoGetSignalFromLink (self: _sig_l)
	return private.links[self]
end

function private.DoGetTypeFromLink (self: _sig_l)
	return self._t
end


function private.DoDisconnectSelf (self: _sig_l)
	local sig = private.DoGetSignalFromLink(self)
	local obs = private.DoGetAllObservers(sig)
	local typ = private.DoGetTypeFromLink(self)
	
	table.remove(obs[typ], table.find(obs[typ], self))
end

function private.DoResetAll (self: _sig)
	local obs = private.DoGetAllObservers(self)
	
	for i,v in pairs(obs) do
		for i=1, #v do
			v[i]:Disconnect()
		end
	end
	return self
end




-- Создает одиночное соединение
function public.Once (self: Signal, func: func) : SignalLink
	return private.DoSetNewLink(self :: _sig, func, '_once')
end
-- Создает постоянное соединение
function public.Connect (self: Signal, func: func) : SignalLink
	return private.DoSetNewLink(self :: _sig, func, '_cons')
end
-- Отключает все подписки на сигнале
function public.Reset (self: Signal) : Signal
	return private.DoResetAll(self :: _sig)
end
-- Возвращает оригинальный объект параметров хука.
function public_protect.GetParams (self: SignalProtected) : HookParams
	return private.DoGetOriginParams(self :: _sig)
end

-- Отключает текущий SignalLink
function public_link.Disconnect (self: SignalLink) : ()
	return private.DoDisconnectSelf(self :: _sig_l)
end

-- Создает экземпляр сигнала. Должен быть инжектнут внутрь объекта на этапе его создания. 
function protected.NewSignal () : Signal
	return private.DoCreateNewSignal()
	
	-- Для корректной работы сигнала, нужно встроить его как параметр в изначальной таблице объекта
	-- А затем получить хук от встраивания этого объекта. Т.к хук наследует от оригинала прототипно,
	-- нужно обернуть именно хук в object.
end

type client = {}|{[any]:any}
type func = (self: {}|{[any]:any}, index: any, newindex: any, oldindex: any)->()
type listSL = {_sig_l}
type obs_typ = {[string]: listSL}
type observers = {
	_once: listSL,
	_cons: listSL,
	--[string]: listSL
}

type _sig = SignalProtected & {
	_observers: observers
}
type _sig_l = SignalLink & {
	_f: func,
	_t: keyof<observers>,
}

export type HookParams = parent.HookParams
export type Hook = parent.Hook


export type SignalLink = typeof(obj.New({} :: public_link, private.SignalLinkClassName))
export type SignalProtected = parent.HookParams & public_protect & Signal
export type Signal = typeof(obj.New({} :: public, private.SignalClassName))

type public_protect = typeof(public_protect)
export type protected = self & typeof(protected)
export type ancestors = root & parent.ancestors
export type public_link = typeof(public_link)
export type public = typeof(public)
export type root = typeof(root)
export type self = typeof(class)

-- Используется для подключения подсистем хуков также, как это делает RBXScriptSignal.
--function root.GetClass () return class end
function root.GetProtected () return protected end
oop.Expanding(root,ancestors)
return root
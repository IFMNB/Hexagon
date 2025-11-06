--!strict

-- 

local parent = require('./')
local ancestors = parent :: parent.ancestors

local provider = ancestors.GetPluginProvider()
local oop = provider.GetOOP()
local mt = provider.GetMeta()
local tbl = provider.GetTable()
local obj = ancestors.GetObject()

local private = {}
local protected_public = {}
local protected = {}
local public = {}
local class = {}
local root = {}

private.debugname = script.Name..'.'
private.hookClassName = 'Hook' :: 'Hook'
private.paramsClassName = 'HookParams' :: 'HookParams'
private.no_output = 'never' :: 'never'

private.hooks = mt.SetMode({} :: {[client]: HooksTable}, 'k')
private.params = mt.SetMode({} :: {[_HookParams]: HooksTable}, 'k')
private.object = mt.SetMode({} :: {[Hook]: {}}, 'k')

private.hookMeta = { 
	__index = function (self: Hook, i: any)
		local action : action_type = '__index'
		return private.HooksWorker(self, i, nil, action)
	end,
	__newindex = function (self: Hook, i: any, n: any)
		local action : action_type = '__newindex'
		return private.HooksWorker(self, i, n, action)
	end,
}

function private.HooksWorker  (self: Hook, i: any, n: any, action: action_type) : any|never
	debug.profilebegin(private.debugname..'global_hookIterator.'..action)
	assert(action ~= 'all', 'all input in hooks.')
	local no_output = private.no_output
	
	local client = private.GetClient(self)
	
		
	if private.checkRunState(self) and private.checkIsItMyContext(self, action) then
		local params = private.doCreateIteratorParams(self)
		local origin : _iterator_origin = {
			client = client,
			index = i,
			new = action == '__newindex' and n or no_output,
			old = action == '__newindex' and client[i] or no_output
		}

		local result = private.doIterate(params, origin)
		if result ~= no_output and private.checkShouldOverrideValue(self, result) then
			if action == '__newindex' then
				client[i]=result
			end
			debug.profileend()
			return result
		else
			if action == '__newindex' then
				client[i]=n
				debug.profileend()
				return
			end
		end
	end
	
	
	debug.profileend()
	return client[i]
end

function private.doCreateIteratorParams (self: Hook)
	local params = private.GetHookParams(self)
	local value = private.doGetIteratorValue(params)
	local hook = private.GetObject(self)
	local output : _iterator_params = {
		params = params,
		value = value,
		hook = hook :: Hook
	}
	return output
end

function private.checkRunState (self: Hook)
	local self = private.GetHookParams(self)
	return self._state == 'running'
end

function private.checkIsItMyContext (self: Hook, action: action_type)
	local self = private.GetHookParams(self)
	return self._actionType == action
end

function private.checkShouldOverrideValue (self: Hook, value: any)
	local self = private.GetHookParams(self)
	return self._override_in == 'all' or self._override_in == typeof(value)
end













function private.GetHookParams (self: Hook) : _HookParams
	local Object = private.GetObject(self)
	local Params = tbl.getParentOfKey(private.params, Object) :: _HookParams?
	assert(Params, 'Params is not exists')
	return Params
end

function private.GetHook (self: Hook)
	return private.hooks[self]
end

function private.GetObject (self: Hook)
	return private.object[self]
end

-- Любые ошибки появляются из-за того, что _GC собирает клиента хука, а сам хук еще остается жив из-за хранения в сильном месте. Я не собираюсь это исправлять, потому что хуки должны цепляться за клиент.
function private.GetClient (self: Hook) : client
	local Object = private.GetObject(self)
	local Client = tbl.getParentOfKey(private.hooks, Object)
	assert(Client, 'Received hook-request after cliemt._GC event.') 
	return Client
end


function private.DoHook () : Hook
	local Hook = {} :: Hook
	local Object = obj.New(Hook, private.hookClassName)
	
	private.object[Hook]=Object
	setmetatable(Hook, private.hookMeta)
	
	return Object
end

function private.DoInsertHookInParms (self: Hook, Params: _HookParams)
	local field = private.GetParamsField(Params)
	table.insert(field, self)
	return self
end

function private.DoInsertHookInClient (self: Hook, client: client)
	local HooksClient = private.hooks[client]
	table.insert(HooksClient, self)
	return self
end








function private.DoCreateHook <client_type> (self: client, HookParams: _HookParams)
	debug.profilebegin(private.debugname..'DoCreateHook')
	assert(type(self)=='table' or typeof(self) == 'Instance' or typeof(self) == 'userdata', string.format('Received non-table value %q', typeof(self)))
	
	local Hook = private.DoHook()
	private.DoInsertHookInParms(Hook, HookParams)
	private.DoInsertHookInClient(Hook, self)
	
	debug.profileend()
	return Hook
end















function private.GetParamsField (self: _HookParams)
	return private.params[self]
end

function private.DoParams ()
	local Params = {} :: _HookParams

	Params._actionType = 'all'
	Params._state = 'paused'
	Params._override_in = 'never'

	oop.Expanding(Params, public)
	
	local ObjectParams = obj.New(Params, private.paramsClassName)

	return ObjectParams
end

function private.DoParamsField (self: HookParams)
	private.params[self]=mt.SetMode({} :: HooksTable, 'v')
	return self
end







function private.DoCreateParams ()
	debug.profilebegin(private.debugname..'DoCreateParams')
	
	local Params = private.DoParamsField(private.DoParams())
	
	debug.profileend()
	return Params
end
















function private.setPause (self: _HookParams)
	self._state = 'paused'
	return self
end

function private.setResume (self: _HookParams)
	private.assertMainIteration(self)
	
	self._state = 'running'
	return self
end

function private.setActivatorTypeTo (self: _HookParams, actionType: action_type)
	self._actionType = actionType
	return self
end

function private.setHookOverrideToResultType (self: _HookParams, at: override_in)
	self._override_in = at
	return self
end

function private.setIterator (self: _HookParams, iter: _iterator_function)
	self._do = iter
	return self
end

function private.setIteratorValue (self: _HookParams, get: _value_for_iterator)
	self._get = get	
	return self
end

function private.doIterate (fabric: _iterator_params,origin: _iterator_origin) : no_output|any?
	return fabric.params._do(fabric, origin)
end

function private.doGetIteratorValue (self: _HookParams) : any?
	local value_caller = private.getValueForIterator(self)
	if value_caller then
		return value_caller(self)
	else
		return nil
	end
end

function private.getIterator (self: _HookParams)
	return self._do
end
function private.getValueForIterator (self: _HookParams)
	return self._get
end
-- Нельзя контроллировать управление хуком без его логики
function private.assertMainIteration (self: _HookParams)
	assert(private.getIterator(self), 'HookParamsIterator is not exist')
end


function private.CreateNewClientTable (self: client)
	private.hooks[self]={}
	return self
end

function private.GetClientTable (self: client)
	return private.hooks[self]
end
-- Все хуки привязаны к параметрам и семейству хуков клиента.
function private.DoCheckShouldCreateClient (self: client, Params: _HookParams)
	if not private.GetClientTable(self) then
		private.CreateNewClientTable(self)
	end

	return private.DoCreateHook(self, Params)
end





-- Хук будет срабатывать только в указанном контексте действий.
function public.BindTo (self: HookParams, action: action_type)
	return private.setActivatorTypeTo(self :: _HookParams, action) :: HookParams
end
-- Заморозит действие всех хуков с этими настройками для последующих событий.
function public.Pause (self: HookParams)
	return private.setPause(self :: _HookParams) :: HookParams
end
-- Продолжит выполнение всех хуков с этими настройками для последующих событий. Вернет ошибку, если отсутствует функция итератора.
function public.Resume (self: HookParams)
	return private.setResume(self :: _HookParams) :: HookParams
end
-- Определяет, будет ли хук подменять результат работы функции собственными значениями.
function public.DoOverride (self: HookParams, at: override_in)
	return private.setHookOverrideToResultType(self :: _HookParams, at) :: HookParams
end
-- Функция итератора самостоятельно определяет каким образом ей обрабатывать все полученные данные внутри и возвращает результат своих операций.
function public.SetIterator (self: HookParams, iter: _iterator_function)
	return private.setIterator(self :: _HookParams, iter) :: HookParams
end
-- Необязательная функция-компонент к итератору, которая собирает данные для итератора.
function public.SetIteratorValue (self: HookParams, get: _value_for_iterator)
	return private.setIteratorValue(self :: _HookParams, get) :: HookParams
end

-- Создает хук, привязанный к определенному клиенту. По умолчанию на паузе.
function class.New <table> (self: table | client, HookParams: HookParams)
	return private.DoCheckShouldCreateClient(self, HookParams :: _HookParams) :: Hooked<table>
end
-- Набор настроек для хука при его создании определяет его поведение в будущем. Как, например, метатаблицы переопределяют функционал таблиц, - так и настройки хуков определяют их реагирование.
function class.NewParams () 
	return private.DoCreateParams() :: HookParams
end


type client = {}|{[any]:any}
export type action_type = '__index'|'__newindex' | 'all'
type override_in = 'nil'|'string'|'boolean'|'number'|'table' | 'all' | 'never'
type no_output = typeof(private.no_output)
type if_output = any|no_output
type iterator_value = any

type HooksTable = typeof(mt.SetMode({} :: {Hook}, 'v'))

type _iterator_params = {
	params: _HookParams,
	value: iterator_value?,
	hook: Hook
}
type _iterator_origin = {
	client: client|{[any]:any},
	index: any,
	new: if_output,
	old: if_output
}
type _iterator_function = typeof(private.doIterate)
type _value_for_iterator = (self: {}) -> iterator_value

type _HookParams = {
	_actionType: action_type,
	_state: 'paused'|'running',
	_do: _iterator_function,
	_get: _value_for_iterator,
	_override_in: override_in
} & HookParams

export type Hook = typeof(obj.New({}, private.hookClassName))
export type HookParams = typeof(obj.New({} :: public, private.paramsClassName))

export type HookProtected = HookParams & protected_public
type Hooked <hooked> = hooked & Hook

type protected_public = typeof(protected_public)
export type public = typeof(public)
export type ancestors = root & parent.ancestors
export type root = typeof(root)
export type protected = self & typeof(protected)
export type self = typeof(class)

-- Библиотека хуков используется для react-программирования.
function root.GetHooks () return class end
oop.Expanding(root, parent)
oop.Expanding(public, protected_public)
oop.Expanding(class, protected)
return root 
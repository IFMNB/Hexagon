--!strict

local private = {}
local public = {}

private.name = 'HexagonEnum' :: 'HexagonEnum'
private.reversGen = {} :: {HexagonEnum<string,string>}
private.nameGr = {} :: {[string]: {[string]: HexagonEnum<string,string>}}
--private.mt = { __index = public_enum, __newindex = function () error(string.format('attempt to change %s table', private.name)) end, __metatable = private.name, __tostring = function (self: HexagonEnum<string,string>) return self.Name end }
private.GenerationSettings = {}
private.GenerationSettings.StarterGeneration = 0
private.GenerationSettings.Generated = private.GenerationSettings.StarterGeneration

function private.__tostring (self)
	return self.Name
end
-- Returns HexagonEnum current parameters.
function private:GetParams ()
	return private.GenerationSettings
end

function private.DoCreateEnum <name, type> (name: name, parent: type)
	local e = {}
	e.Name = name
	e.EnumType = parent
	e.Value = -1
	
	local proxy = newproxy(true)
	local mt = getmetatable(proxy)
	mt.__index = e
	mt.__newindex = e
	mt.__tostring = private.__tostring
	mt.__metatable = private.name
		
	--setmetatable(e, private.mt)
	
	return proxy :: setmetatable<{}, {
		__index: typeof(e),
		__newindex: typeof(e),
		__tostring: typeof(private.__tostring),
		__metatable: typeof(private.name)
	}>
end

function private.DoInsertNewEnumValue <t1,t2> (enum: HexagonEnum<t1,t2>)
	private.reversGen[enum.Value]=enum
	return enum
end
function private.InsertEnumG <t0,t1> (n: t0, g: t1)
	private.nameGr[g]=private.nameGr[g] or {}
end
function private.InsertEnumNG <t00, t0,t1> (self: t00, n: t0, g: t1)
	private.nameGr[g][n]=self
end

function private.DoAddGeneration <t1,t2> (enum: HexagonEnum<t1,t2>)
	enum.Value = private.GenerationSettings.Generated
	private.GenerationSettings.Generated += 1
	return enum
end

-- Returns HexagonEnum, related to the specified value.
function private:DoGetEnumByValue (value: number)
	return private.reversGen[value]
end
-- Returns HexagonEnum, related to this name and group.
function private:GetEnumByNames <t0,t1> (n: t0, g: t1)
	return assert(private.nameGr[g][n], tostring(public.Error.Unknown))
end
-- Returns true if the specified data is a HexagonEnum.
function private:CheckHexEnum <t0> (data: HexagonEnum<string,string>&t0) : boolean
	return not not public:GetValue(data.Value)
end
-- Creates a new HexagonEnum.
function private:New <t1,t2> (name: t1, group: t2)
	local enum = private.DoCreateEnum(name,group)
	
	private.DoAddGeneration(enum)
	private.DoInsertNewEnumValue(enum)
	private.InsertEnumG(name,group)
	private.InsertEnumNG(enum, name, group)
	
	return enum
end

-- Returns true if the specified data is a HexagonEnum and her group is the same as the specified group.
function private:ReturnCheckedGroupSimilar (evalue: number, group: string) : boolean
	local enum = public:GetValue(evalue)
	return not not enum and enum.EnumType == group
end

type HexagonEnum <t0,t1> = typeof(private.DoCreateEnum(''::t0,''::t1))

public.Groups = table.freeze({
	RC = 'Roblox' :: 'Roblox',-- Related to work with roblox objects
	NW = 'Network' :: 'Network',-- Related to work with network
	ER = 'Error' :: 'Error',-- Related to work with errors
	ST = 'State' :: 'State',-- Related to work with State machines
	MD = 'MetaMethode' :: 'MetaMethode',-- Related to work with MetaMethodes
	SG = 'Signal' :: 'Signal',-- Related to work with EntitySignals (aka ChangedSignal) ((this is private field, but you can use it for your own))
	LU = 'Lua' :: 'Lua',-- References to predefined Luau global functions
	AP = 'App' :: 'App',-- References to Hexagon applications, thats already included in hexagon
	NWM = 'NetworkMessage' :: 'NetworkMessage'-- Referenced to Network communication messages. This is exatly not a NetworkGroup only because we use this to define network communications.
})

public.Roblox = table.freeze({
	Camera = table.freeze({
		SmoothMovement = private:New('SmoothMovement' :: 'SmoothMovement', public.Groups.RC), -- Camera moves is smoothly
		SmoothFollow = private:New('SmoothFollow' :: 'SmoothFollow', public.Groups.RC), -- Smoothly follow target
		SmoothRotate = private:New('SmoothRotate' :: 'SmoothRotate', public.Groups.RC), -- Smoothly rotate camera to target position by their CFRAME
		SmoothWatchCamera = private:New('SmoothWatchCamera' :: 'SmoothWatchCamera', public.Groups.RC), -- Smoothly rotate camera to target position by their CFRAME while watching target
		SmoothCameraLookAt = private:New('SmoothCameraLookAt' :: 'SmoothCameraLookAt', public.Groups.RC), -- Smoothly rotate camera to target position by their CFRAME
		SmoothCameraPosition = private:New('SmoothCameraPosition' :: 'SmoothCameraPosition', public.Groups.RC) -- Smoothly move camera to target position by their CFRAME
	})
})

public.State = table.freeze({
	Live = private:New('Live' :: 'Live', public.Groups.ST),-- Status of this object is not changed, he is ready to work
	Run = private:New('Run' :: 'Run', public.Groups.ST),-- Status of this object is runned and work
	Pause = private:New('Pause' :: 'Pause', public.Groups.ST),-- Status of this object is paused.
	Dead = private:New('Dead' :: 'Dead', public.Groups.ST),-- We cannot use this object, because he fully dead and not work
	Idle = private:New('Idle' :: 'Idle', public.Groups.ST),-- This operation is idle due to some reason
	Action = private:New('Action' :: 'Action', public.Groups.ST),-- This operation do some actions
	Wait = private:New('Wait' :: 'Wait', public.Groups.ST),-- This operation waited for something else
	Finished = private:New('Finished' :: 'Finished', public.Groups.ST),-- This operation finised right now
	Start = private:New('Start' :: 'Start', public.Groups.ST),-- This operation started right now
	Stop = private:New('Stop' :: 'Stop', public.Groups.ST),-- This operation fully stopped.
	Cancel = private:New('Cancel' :: 'Cancel', public.Groups.ST)-- This operation canceled
})

public.Error = table.freeze({
	Forbidden = private:New('Forbidden' :: 'Forbidden', public.Groups.ER), -- Operation cannot be performed because of missing permissions OR something goes wrong.
	Unknown = private:New('Unknown' :: 'Unknown', public.Groups.ER), -- Unknown data, error, or something else, that cannot be handled.
	Unstable = private:New('Unstable' :: 'Unstable', public.Groups.ER), -- Something goes wrong and operation cannot be performed due to unstable state.
	Reset = private:New('Reset' :: 'Reset', public.Groups.ER), -- Operation forcily stopped by some reason.
	Never = private:New('Never' :: 'Never', public.Groups.ER), -- Operation cannot be perfomed because this parameter is not exist in this time or never exist.
	GarbageCollected = private:New('GarbageCollected' :: 'GarbageCollected', public.Groups.ER), -- _GC already collected awaited data, so operation cannot be performed.
	Mismatch = private:New('Mismatch' :: 'Mismatch', public.Groups.ER), -- Parameter might be wrong.
	NotExist = private:New('NotExist' :: 'NotExist', public.Groups.ER), -- Awaited parameter is not exists at this time.
	NotLoaded = private:New('NotLoaded' :: 'NotLoaded', public.Groups.ER), -- Awaited parameter is not loaded at this time.
	NotAvailable = private:New('NotAvailable' :: 'NotAvailable', public.Groups.ER), -- We know this parameter exists and accessible, but we cannot use it now due some reason
	WrongParams = private:New('WrongParams' :: 'WrongParams', public.Groups.ER), -- Expected this params, but we got another. 
	KernelPanic = private:New('KernelPanic' :: 'KernelPanic', public.Groups.ER), -- Critical system failure. Code is not able to handle this error.
	Exploit = private:New('Exploit' :: 'Exploit', public.Groups.ER) -- Received argument looks like exploit.
})

public.Network = table.freeze({
	Side = table.freeze({
		Client = private:New('Client' :: 'Client', public.Groups.NW), -- Defines client side
		Server = private:New('Server' :: 'Server', public.Groups.NW), -- Defines server side
		Undefined = private:New('Undefined' :: 'Undefined', public.Groups.NW) -- Defines undefined side
	}),
	Messages = table.freeze({
		Okay = private:New('Okay' :: 'Okay', public.Groups.NWM),-- Request is processed successfully
		Fail = private:New('Fail' :: 'Fail', public.Groups.NWM),-- Request is not processed successfully due some reason on another side
		BadRequest = private:New('BadRequest' :: 'BadRequest', public.Groups.NWM),-- Request is not processed successfully due wrong parameters for this request
		Request = private:New('Request' :: 'Request', public.Groups.NWM),-- Defined a global request message
		Replicate = private:New('Replicate' :: 'Replicate', public.Groups.NWM),-- Request to replicate data to another side
		Update = private:New('Update' :: 'Update', public.Groups.NWM),-- Request to update data to another side or from another side
		Reset = private:New('Reset' :: 'Reset', public.Groups.NWM),-- Request to reset data
		Destroy = private:New('Destroy' :: 'Destroy', public.Groups.NWM),-- Request to destroy data
		Create = private:New('Create' :: 'Create', public.Groups.NWM),-- Request to create data
		Call = private:New('Call' :: 'Call', public.Groups.NWM),-- Request to call function on another side
		Signal = private:New('Signal' :: 'Signal', public.Groups.NWM),-- Defines signal action that can be used in some 'Promise' like actions.
		Get = private:New('Get' :: 'Get', public.Groups.NWM),-- Request to get data from another side
		Set = private:New('Set' :: 'Set', public.Groups.NWM),-- Request to set data on another side
		GetList = private:New('GetList' :: 'GetList', public.Groups.NWM),-- Request to get list of data from another side
		Yield = private:New('Yield' :: 'Yield', public.Groups.NWM)-- Local machine waiting for another side
	})
})

public.Metamethode = table.freeze({
	Index = private:New('Index' :: 'Index', public.Groups.MD),-- Metamethode for __index
	NewIndex = private:New('NewIndex' :: 'NewIndex', public.Groups.MD),-- Metamethode for __newindex
	Call = private:New('Call' :: 'Call', public.Groups.MD),-- Metamethode for __call
	Tostring = private:New('Tostring' :: 'Tostring', public.Groups.MD),-- Metamethode for __tostring
	Length = private:New('Length' :: 'Length', public.Groups.MD),-- Metamethode for __len
	Equal = private:New('Equal' :: 'Equal', public.Groups.MD),-- Metamethode for __eq
	Every = private:New('Every' :: 'Every', public.Groups.MD)-- Metamethode for __iter
})


public.Signal = table.freeze({
	Once = private:New('Once' :: 'Once', public.Groups.SG),-- Defines Once signal type, that reacts only once on event
	Conn = private:New('Connected' :: 'Connected', public.Groups.SG),-- Defines Connected signal type, that reacts every time on event
	For = private:New('For' :: 'For', public.Groups.SG),-- Defines For signal type, that reacts every time on event only for specific key
	At = private:New('At' :: 'At', public.Groups.SG),-- Defines At signal type, that reacts every time on event at specific key only once
	Wait = private:New('Wait' :: 'Wait', public.Groups.SG),-- Defines Wait signal type, that waits for event. Yields until event happens
	Follow = private:New('Follow' :: 'Follow', public.Groups.SG)-- Defines Follow signal type, that follows event for specific key. Yields until event happens
})


public.Lua = table.freeze({
	Format = table.freeze({
		['i+'] = private:New('i+' :: 'i+', public.Groups.LU),-- Format for positive numbers
		['i-'] = private:New('i-' :: 'i-', public.Groups.LU)-- Format for negative numbers
	}),
	Iterator = table.freeze({
		Enter = table.freeze({
			Before = private:New('Before' :: 'Before', public.Groups.LU),-- Iterator for before enter to specified key. Used in recursive iteration.
			After = private:New('After' :: 'After', public.Groups.LU)-- Iterator for after enter to specified key. Used in recursive iteration.
		}),
		Ipairs = private:New('Ipairs' :: 'Ipairs', public.Groups.LU), -- Iterator for ipairs
		Pairs = private:New('Pairs' :: 'Pairs', public.Groups.LU), -- Iterator for pairs
		Rpairs = private:New('Rpairs' :: 'Rpairs', public.Groups.LU) -- Iterator for reversed ipairs.
	}),
	['Pseudo-C'] = table.freeze({
		
	})
})

public.App = table.freeze({
	PlayerCharacterNetworkSide = private:New('PlayerCharacterNetworkSide' :: 'PlayerCharacterNetworkSide', public.Groups.AP), -- This application defines special system-replication type for player characters. It is used for replication of player characters on server side. Maybe you can ask is it not a ServerAuthority from roblox, but no. This thing completely used only for anti-exploit security and character replication. Application includes input lag on tagged players.
	FramePerSecondCounter = private:New('FramePerSecondCounter' :: 'FramePerSecondCounter', public.Groups.AP) -- This application is used for FPS counter. Counts some things for FPS.
})


public.GetValue = private.DoGetEnumByValue
public.GetNamed = private.GetEnumByNames
public.Create = private.New
public.IsHexagonEnum = private.CheckHexEnum
public.IsGroup = private.ReturnCheckedGroupSimilar
public.GetParams = private.GetParams
table.freeze(public)
table.freeze(private)

type inject = {
	_Typecheck: {
		GetDefaultEnum: <t0,t1> (t0:t0,t1:t1) -> HexagonEnum<t0,t1>,
	}
}

return public :: typeof(public)&inject
--!strict

local constructor = require('./')
local pack = {}

pack.Groups = table.freeze({
	NW = 'NetworkCommunication' :: 'NetworkCommunication',-- Related to work with network
	ST = 'StateMachine' :: 'StateMachine',-- Related to work with State machines
})

pack.State = table.freeze({
	Live = constructor.Create('Live' :: 'Live', pack.Groups.ST),-- Status of this object is not changed, he is ready to work
	Run = constructor.Create('Run' :: 'Run', pack.Groups.ST),-- Status of this object is runned and work
	Pause = constructor.Create('Pause' :: 'Pause', pack.Groups.ST),-- Status of this object is paused.
	Dead = constructor.Create('Dead' :: 'Dead', pack.Groups.ST),-- We cannot use this object, because he fully dead and not work
	Idle = constructor.Create('Idle' :: 'Idle', pack.Groups.ST),-- This operation is idle due to some reason
	Action = constructor.Create('Action' :: 'Action', pack.Groups.ST),-- This operation do some actions
	Wait = constructor.Create('Wait' :: 'Wait', pack.Groups.ST),-- This operation waited for something else
	Finished = constructor.Create('Finished' :: 'Finished', pack.Groups.ST),-- This operation finised right now
	Start = constructor.Create('Start' :: 'Start', pack.Groups.ST),-- This operation started right now
	Stop = constructor.Create('Stop' :: 'Stop', pack.Groups.ST),-- This operation fully stopped.
	Cancel = constructor.Create('Cancel' :: 'Cancel', pack.Groups.ST)-- This operation canceled
})

pack.Network = table.freeze({
	Side = table.freeze({
		Client = constructor.Create('Client' :: 'Client', pack.Groups.NW), -- Defines client side
		Server = constructor.Create('Server' :: 'Server', pack.Groups.NW), -- Defines server side
		Undefined = constructor.Create('Undefined' :: 'Undefined', pack.Groups.NW) -- Defines undefined side
	}),
	Messages = table.freeze({
		Okay = constructor.Create('Okay' :: 'Okay', pack.Groups.NW),-- Request is processed successfully
		Fail = constructor.Create('Fail' :: 'Fail', pack.Groups.NW),-- Request is not processed successfully due some reason on another side
		BadRequest = constructor.Create('BadRequest' :: 'BadRequest', pack.Groups.NW),-- Request is not processed successfully due wrong parameters for this request
		Request = constructor.Create('Request' :: 'Request', pack.Groups.NW),-- Defined a global request message
		Replicate = constructor.Create('Replicate' :: 'Replicate', pack.Groups.NW),-- Request to replicate data to another side
		Update = constructor.Create('Update' :: 'Update', pack.Groups.NW),-- Request to update data to another side or from another side
		Reset = constructor.Create('Reset' :: 'Reset', pack.Groups.NW),-- Request to reset data
		Destroy = constructor.Create('Destroy' :: 'Destroy', pack.Groups.NW),-- Request to destroy data
		Create = constructor.Create('Create' :: 'Create', pack.Groups.NW),-- Request to create data
		Call = constructor.Create('Call' :: 'Call', pack.Groups.NW),-- Request to call function on another side
		Signal = constructor.Create('Signal' :: 'Signal', pack.Groups.NW),-- Defines signal action that can be used in some 'Promise' like actions.
		Get = constructor.Create('Get' :: 'Get', pack.Groups.NW),-- Request to get data from another side
		Set = constructor.Create('Set' :: 'Set', pack.Groups.NW),-- Request to set data on another side
		GetList = constructor.Create('GetList' :: 'GetList', pack.Groups.NW),-- Request to get list of data from another side
		Yield = constructor.Create('Yield' :: 'Yield', pack.Groups.NW)-- Local machine waiting for another side
	})
})

table.freeze(pack)

return pack
--!strict

local parent = require('../')
local ancestors = parent :: parent.ancestors

local plugin = ancestors.GetPluginProvider()

local obj = parent.GetObject()
local oop = plugin.GetOOP()
local rbxl = plugin.GetLinker()

local private = {}
local public = {}
local class = {}
local root = {}

private.MusicClassName = 'Music' :: 'Music' 
private.themes = {}
private.created = {}

















function public.Play ()
	
end

function public.Pause ()
	
end

function public.Reset ()
	
end

function public.IsPlaying ()
	
end





function class.New (theme: Themes)
	
end



type _themes = typeof(private.themes)
type Themes = keyof<_themes>

type _mus = Music & {
	_instance: Sound,
	_theme: Themes
}
export type Music = typeof(obj.New({} :: public, private.MusicClassName))

export type public = typeof(public)
export type ancestors = root & parent.ancestors
export type root = typeof(root)
export type self = typeof(class)

-- Используется для игрового OST.
function root.GetClass () return class end
oop.Expanding(root, ancestors)
return root
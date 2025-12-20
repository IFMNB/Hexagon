# Hexagon
An open-source simple library that provides some ways to create and emulate java-like objects or roblox instances.

## This library has classes:
- Object
> Default class that used to incapsulate all data.
- Instance
> Specified class that have signals and some other properties
- Hook
> Specified class that can create interlayers to any data by his instances 'HookParams'
- PropertyModifiedLogger
> Class-interlayer that logs any changes in data after him.
- SecurityLocker
> Class-interlayer that locks any changes in data after him.

## Also, library provides access to simple plugins:
- Linker
> Special plugin to protect data from _GC. Links this data to some other link-like data. You can use it to link table to other table in lazyTables structures.
- Shadow
> Special plugin to create simple private data-field, linked to target and can be accessed by himself.
- Metatable
> Special plugin to simplify some things with metatables and proxyes.
- Reference
> Special plugin to links table lifecycle to real roblox instance.

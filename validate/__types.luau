
-- Should used as a debug tool
export type function INSPECT_TYPE (TypeInspect:type)
	local types = types

	local inspect_table
	local inspect_unisect
	local well_well_well
	local uwah

	function uwah (a0: type)
		if a0:is('singleton') then
			print('Singleton-value is ', a0:value())
		else
			print('Value is ', a0.tag)
		end
	end

	function well_well_well (i: type, v: type)
		if i:is('intersection') or i:is('union') then
			inspect_unisect(v)
		elseif i:is('table') then
			inspect_table(i)
			local meta = i:metatable()
			if meta then
				print('----------- [ INSPECT METATABLE ] -----------')
				well_well_well(meta,meta)
				print('----------- [ ENDOF METATABLE ] -----------')
			end
		end
	end

	function inspect_table (t0: type)
		print('Inpecting type table')
		print('----------- [ INSPECT TABLE ] -----------')
		local null

		for i,v in t0:properties() do
			
			uwah(i)
			well_well_well(i,i)

			if v.read then
				print('That property have read-value ')
				uwah(v.read)
				well_well_well(v.read,v.read)
			end
			if v.write then
				print('That property have write-value')
				uwah(v.write)
				well_well_well(v.write,v.write)
			end

			null = true
			print('----------- [NEXT VAR] -----------')
		end

		local ri = t0:readindexer()
		local rw = t0:writeindexer()

		if ri then
			print('[read-indexer for this table]')
			uwah(ri.index)
			well_well_well(ri.index,ri.index)
			uwah(ri.result)
			well_well_well(ri.result,ri.result)
		end

		if rw then
			print('[write-indexer for this table]')
			uwah(rw.index)
			well_well_well(rw.index,rw.index)
			uwah(rw.result)
			well_well_well(rw.result,rw.result)
		end

		if not null then
			print('Empty table')
		end
	end

	function inspect_unisect (t0: type)
		print('Inspecting type uni/inter')
		print('----------- [ INSPECT UNI/INTER ] -----------')
		local c = t0:components()
		for i,v in c do
			uwah(v)
			well_well_well(v,v)
			print(string.format('----------- [ end of index %s ] -----------', tostring(i)))
		end
	end

	assert(TypeInspect:is('union')
		or TypeInspect:is('intersection')
		or TypeInspect:is('table'),
		'Unsupported type, expected union, table, or intersection')

	print('Okay, we got a type ', TypeInspect.tag)

	well_well_well(TypeInspect,TypeInspect)

	print('Thats all.')

	return types.singleton('*INSPECTED*')
end

-- Workaround for https://github.com/luau-lang/luau/issues/2171#event-21911091909 , should be deleted after bugfix.
export type function unpack_intersect (tar: type)
	local types = types

	local r0 : type
	if tar:is('intersection') then
		r0 = types.newtable()

		local dotable
		local doidk

		function dotable (this: type)
			for i,v in this:properties() do
				r0:setreadproperty(i,v.read)
				r0:setwriteproperty(i,v.write)
				local ri = this:readindexer()
				local rw = this:writeindexer()
				if ri then
					r0:setreadindexer(ri.index,ri.result)
				end
				if rw then
					r0:setwriteindexer(rw.index,rw.result)
				end
			end
		end

		for i,v in tar:components() do
			if v:is('table') then
				dotable(v)
			end
		end
	else
		r0 = tar
	end

	return r0
end

export type function write_metatable__index_correct (data: type)
	local types = types

	local r0 = types.newtable()

	if data:is('table') then
		local meta = data:metatable()
		if meta then
			local __i = types.singleton('__index')
			meta:setproperty(__i, unpack_intersect(metatable__index(data)))
			r0 = meta
		end
	end

	return r0
end

export type function metatable__index (data: type)
	local types = types

	if data:is('table') then
		local meta = data:metatable()
		if meta then
			local __i = types.singleton('__index')
			return meta:readproperty(__i) or types.newtable()
		end
	end

	return types.newtable()
end

-- It goes through the entire type recursively and builds the type manually, completely destroying its inheritance and building a new type. This thing destroys every function-type information, such as a commentary and parameters.
export type function all_flatten (data: type)
	local types = types
	local writepack = types.newtable() -- raw-basement. Expected to look as a {[singleton]: any-value}

	local function flat_table (data: type)
		assert(data:is('table'), 'Unsupported type, expected table to flattering')

		local function recursive (data: type)
			for i,v in data:properties() do
				local t = v.read or v.write
				if t and t:is('table') then
					local meta = t:metatable()
					if meta then
						local __i = types.singleton('__index')
						local meta__i = meta:readproperty(__i)
						if meta__i then
							recursive(meta__i)
						end
						writepack:setmetatable(
							types.newtable(
								{__metatable = meta:readproperty(types.singleton('__metatable'))},
								{index = types.string, readresult = types.any, writeresult = types.any}
							)
						)
					end
					recursive(t)
				end

				if v.read then writepack:setreadproperty(i, v.read) end
				if v.write then writepack:setwriteproperty(i, v.write) end
			end
		end

		recursive(data)
	end


	if data:is('table') then
		flat_table(data)
	end

	if data:is('intersection') then
		for i,v in data:components() do
			if v:is('table') then
				flat_table(v)
			end
		end
	end

	return writepack
end

export type function flat (data: type)
	local types = types
	local r0 = types.newtable()

	if data:is('intersection') then
		for i,v in data:components() do
			if v:is('table') then
				for i,v in v:properties() do
					r0:setwriteproperty(i, v.write)
					r0:setreadproperty(i, v.read)
				end
			end
		end
	end

	return r0
end


export type userdata = setmetatable<userdata_default,{[string]:any}>
export type userdata_default = {[never]:never}
export type udata = {[unknown]: unknown}
export type adata = {[any]: any}

return nil
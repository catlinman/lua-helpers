
local gamedata = {} -- Gamedata library object.

local db = {} -- Database storing all created data.
local gdb = {} -- Grouped databases are entered into this table.

-- Add a new gamedata entry with a new and an optional group.
function gamedata.insert(name, data, group)
	if not db[name] then
		db[name] = data

		if group then
			if gdb[group] then
				if not gdb[group][name] then
					gdb[group][name] = db[name]
				end
			else
				gdb[group] = {}
				gdb[group][name] = db[name]
			end
		end
	else
		print("Gamedata: The gamedata entry with the name of '" ..name .."' already exists.")
	end
end

-- Clear a gamedata entry by it's name.
function gamedata.clear(name)
	if db[name] then
		db[name] = nil
	else
		print("Gamedata: The gamedata entry with the name of '" ..name .."' was not found or might already be unloaded.")
	end

	collectgarbage()
end

-- Remove an entire gamedata group.
function gamedata.clearGroup(gname)
	if gdb[gname] then
		for k, v in pairs(gdb[gname]) do
			db[k] = nil
			gdb[gname][k] = nil
		end

		gdb[gname] = nil
	else
		print("Gamedata: The gamedata group entry with the name of '" ..gname .."' was not found or might already be unloaded.")
	end

	collectgarbage()
end

-- Wipe the entire database.
function gamedata.wipe()
	for i, v in pairs(gdb) do
		gdb[i] = nil
	end

	for i, v in pairs(db) do
		db[i] = nil
	end

	collectgarbage()
end

-- Get the data from an entry name within the database.
function gamedata.get(name)
	if(db[name] ~= nil) then
		return db[name]
	else
		print("Gamedata: The gamedata entry with the name of '" ..name .."' was not found. Make sure it has been loaded before accessing it.")
	end
end

return gamedata
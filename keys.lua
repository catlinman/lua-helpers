
keys = {}

local lastKeycode = 0
local keygroup = {}

-- We can use this function to add keys to the table of keys.
function keys.add(name, keycode)
	if not keygroup[name] then
		key = {}

		key.name = name
		key.keycode = {}
		key.keycode[1] = keycode

		key.pressed = false
		key.callbacks = {}

		keygroup[key.name] = key
	else
		keygroup[name].keycode[table.length(keygroup[name].keycode) + 1] = keycode
	end
end

-- Does the same as the function above but instead removes keys from the keys table.
function keys.pop(name)
	if keygroup[name] then
		keygroup[name] = nil
	end
end

-- Returns a key by it's name in the key database.
function keys.get(name)
	if keygroup[name] then
		return keygroup[name]
	end
end

-- Add the callbacks to be executed when a key is pressed
function keys.addCallback(name, callbackname, callback)
	if keygroup[name] then
		keygroup[name].callbacks[callbackname] = callback
	end
end

function keys.popCallback(name, callbackname)
	if keygroup[name] then
		if keygroup[name].callbacks[callbackname] then
			keygroup[name].callbacks[callbackname] = nil
		end
	end
end

--[[
	This function should be called from the main.lua/keyPressed hook function.
	Main use is to check for any keys registered to the given keycode and to then execute their callbacks.
--]]

function keys.press(keycode)
	lastKeycode = keycode

	for i, key in pairs(keygroup) do
		for k, code in pairs(key.keycode) do
			if(code == keycode) then
				key.pressed = true

				for l, func in pairs(key.callbacks) do
					func()
				end

				return
			end
		end
	end
end

--[[ 	
	The most important function. When it is called it checks if any of the keys in the table of registered keys is being pressed.
	If they are not being pressed any longer it will change their pressed state to false.
--]] 

function keys.release()
	for i, key in pairs(keygroup) do
		stillpressed = false

		for k, code in pairs(key.keycode) do
			if daisy.isKeyPressed(code) then
				stillpressed = true
				break
			end
		end

		if stillpressed then
			key.pressed = true 
		else
			key.pressed = false
		end
	end

	if lastKeycode then
		if not daisy.isKeyPressed(lastKeycode) then
			lastKeycode = 0
		end
	end
end

-- Calling this function returns a boolean value of true if the key with the specified name is pressed.
function keys.check(name)
	if keygroup[name] then
		return keygroup[name].pressed
	end
end

-- This function checks if there is any key being pressed at the moment.
function keys.checkAny()
	for i, key in pairs(keygroup) do
		if key.pressed then
			return true
		end
	end

	return false
end

-- Use this function to check if a key was pressed even if it is not in the table of registered keys.
function keys.checkKeycode()
	return lastKeycode
end

-- This function checks the amount of keys pressed.
function keys.getPressedNum()
	count = 0
	for i, key in pairs(keygroup) do
		if key.pressed == true then count = count + 1 end
	end

	return count
end	

-- We can use this function to check if there is a key with registered under a certain name. Returns true if the key exists.
function keys.scope(name)
	if keygroup[name] then
		return true
	else
		return false
	end
end

mouse = {} -- Mouse library entry point.

local pressedx, pressedy = 0, 0 -- Last pressed positions.

local lastKeycode = -1 -- The last pressed keycode. Set to -1 since 0 is the first default mouse button.
local mouseKeyGroup = {} -- Stores all added entries to the mouse input database.

-- Define a set of functions used by different engines to avoid the need of heavy code modification when using another framework.
local sizefunc = love.graphics.getDimensions() or video.getScreenSize()
local keycodefunc = love.mouse.isDown or daisy.isMouseButtonPressed
local positionfunc = love.mouse.getPosition() or daisy.getMousePosition()

-- We can use this function to add keys to the table of mousekeys.
function mouse.add(name, keycode)
	if(not mouseKeyGroup[name]) then
		local mouseKey = {}

		mouseKey.name = name
		mouseKey.keycode = keycode

		mouseKey.pressed = false
		mouseKey.callbacks = {}

		mouseKeyGroup[mouseKey.name] = mouseKey
	else
		mouseKeyGroup[name].keycode[table.getn(mouseKeyGroup[name].keycode) + 1] = keycode
	end
end

-- Same goes for this function with the difference that it removes keys from the mousekey table.
function mouse.pop(name)
	if mouseKeyGroup[name] then
		mouseKeyGroup[name] = nil
	end
end

-- Add the callbacks to be executed when a mouse key is pressed
function mouse.addCallback(name, callbackname, callback)
	if mouseKeyGroup[name] then
		mouseKeyGroup[name].callbacks[callbackname] = callback
	end
end

function mouse.popCallback(name, callbackname)
	if mouseKeyGroup[name] then
		if mouseKeyGroup[name].callbacks[callbackname] then
			mouseKeyGroup[name].callbacks[callbackname] = nil
		end
	end
end

-- Mouse.press is used to register mouse presses. It should be called in the games main.lua/mousePress function.
function mouse.press(x, y, keycode)
	pressedx = x
	pressedy = y
	lastKeycode = keycode

	for i, mouseKey in pairs(mouseKeyGroup) do
		if(keycode == mouseKey.keycode) then
			mouseKey.pressed = true

			for l, func in pairs(mouseKey.callbacks) do
				func()
			end

			return
		end
	end
end

function mouse.release(x, y, keycode)
	pressedx = x
	pressedy = y
	lastKeycode = keycode

	for i, mouseKey in pairs(mouseKeyGroup) do
		if(keycode == mouseKey.keycode) then
			mouseKey.pressed = false
			
			return
		end
	end
end

-- Mouse.releaseAll releases all keys in the mouseKeys table if they aren't pressed any longer.
function mouse.releaseAll()
	for i, mouseKey in pairs(mouseKeyGroup) do
		if not keycodefunc(mouseKey.keycode) then
			mouseKey.pressed = false
		end
	end

	if not keycodefunc(lastKeycode) then
		lastKeycode = -1
	end
end

-- The core of the whole system. Calling this function returns a boolean value of true if the mousekey with the specified name is pressed.
function mouse.check(name)
	if mouseKeyGroup[name] then
		return mouseKeyGroup[name].pressed
	end
end

-- This function checks if any of the registered keys are being pressed at the moment.
function mouse.checkAny()
	for i, mouseKey in pairs(mouseKeyGroup) do
		if mouseKey.pressed then
			return mouseKey.keycode
		end
	end

	return -1
end

-- Use this function to check if a key was pressed even if it is not in the table of registered keys.
function mouse.checkKeycode()
	return lastKeycode
end

function mouse.getClickedPosition()
	return pressedx, pressedy
end

function mouse.getPosition()
	return positionfunc()
end

function mouse.getRelativePosition()
	local width, height = sizefunc()
	local cx, cy = camera.getPosition()
	local x, y = positionfunc()
	return x + cx - width / 2, y + cy - height / 2
end

function mouse.getRelativeClickedPosition()
	local width, height = sizefunc()
	local cx, cy = camera.getPosition()
	return mouse.x + cx - width / 2, mouse.y + cy - height / 2
end
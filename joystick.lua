
joystick = {}

local lastButton = 0
local controllerGroup = {}

function joystick.addController(controller)
	if not controllerGroup[controller] then
		controllerGroup[controller] = {}
		controllerGroup[controller].buttonGroup = {}
	end
end

function joystick.removeController(controller)
	if not controllerGroup[controller] then
		controllerGroup[controller] = nil
	end
end

function joystick.controllerExists(controller)
	if controllerGroup[controller] then
		return true
	end
end

--We can use this function to add buttons to the table of buttons.
function joystick.addButton(name, controller, key)
	if controllerGroup[controller] ~= nil then
		if not controllerGroup[controller].buttonGroup[name] then
			local button = {}

			button.name = name
			button.keys = {}
			button.keys[1] = key

			button.pressed = false

			controllerGroup[controller].buttonGroup[button.name] = button
		else
			controllerGroup[controller].buttonGroup[name].keys[table.length(controllerGroup[controller].buttonGroup[name].keys) + 1] = key
		end
	else
		if settings.debug == true then
			print("Joystick: The controller with the id of '" ..controller .."' was not found in the controllerGroup!")
		end
	end
end

--Does the same as the function above but instead removes buttons from the buttons table.
function joystick.popButton(name, controller, btn)
	if controllerGroup[controller] then
		for i, button in pairs(controller.buttonGroup) do
			for j, key in pairs(button.keys) do
				if key == btn then
					key = nil

					return
				end
			end
		end
	end
end

--This function should be called from the main.lua/keyPressed hook function.
function joystick.press(controller, btn)
	if controllerGroup[controller] then
		for i, button in pairs(controllerGroup[controller].buttonGroup) do
			for j, key in pairs(button.keys) do
				if key == btn then
					button.pressed = true

					return
				end
			end
		end

		controllerGroup[controller].lastButton = btn
	end

	--print("You pressed " ..btn .." on controller " ..controller .."!")
end

--The most important function. When it is called it checks if any of the buttons in the table of registered buttons is being pressed.
--If they are not being pressed any longer it will change their pressed state to false.
--This function should be called done every update.
function joystick.release(controller, btn)
	if controllerGroup[controller] then
		for i, button in pairs(controllerGroup[controller].buttonGroup) do
			for j, key in pairs(button.keys) do
				if key == btn then
					button.pressed = false

					return
				end
			end
		end
	end
end

--Calling this function returns a boolean value of true if the button with the specified name is pressed.
function joystick.check(name, controller)
	if controller then
		if controllerGroup[controller] then
			if(controllerGroup[controller].buttonGroup[name]) then
				return controllerGroup[controller].buttonGroup[name].pressed
			end
		end
	else
		for i, controller in pairs(controllerGroup) do
			if controller.buttonGroup[name] then
				return controller.buttonGroup[name].pressed
			end
		end
	end
end

--Use this function to check if a button was pressed even if it is not in the table of registered buttons.
function joystick.checkKeycode(controller)
	if controllerGroup[controller] then
		return controllerGroup[controller].lastButton
	end
end

--This function checks the amount of buttons pressed.
function joystick.getPressedNum(controller)
	if controllerGroup[controller] then
		count = 0

		for i, button in pairs(controllerGroup[controller].buttonGroup) do
			if button.pressed == true then count = count + 1 end
		end

		return count
	end
end	
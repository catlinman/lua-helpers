
local gamestate = {} -- Gamestate library object.

local currentState = "" -- Stores the name of the current gamestate.
local stateStack 	= {} -- Contains all added default gamestates.
local updateStack 	= {} -- Stores special update gamestates.
local fixedUpdateStack = {} -- Stores special fixed update gamestates.
local drawStack	= {} -- Stores special draw gamesates.

--[[
	                                                                                                               
	  ,ad8888ba,                                                                                                   
	 d8"'    `"8b                                                           ,d                   ,d                
	d8'                                                                     88                   88                
	88             ,adPPYYba,  88,dPYba,,adPYba,    ,adPPYba,  ,adPPYba,  MM88MMM  ,adPPYYba,  MM88MMM  ,adPPYba,  
	88      88888  ""     `Y8  88P'   "88"    "8a  a8P_____88  I8[    ""    88     ""     `Y8    88    a8P_____88  
	Y8,        88  ,adPPPPP88  88      88      88  8PP"""""""   `"Y8ba,     88     ,adPPPPP88    88    8PP"""""""  
	 Y8a.    .a88  88,    ,88  88      88      88  "8b,   ,aa  aa    ]8I    88,    88,    ,88    88,   "8b,   ,aa  
	  `"Y88888P"   `"8bbdP"Y8  88      88      88   `"Ybbd8"'  `"YbbdP"'    "Y888  `"8bbdP"Y8    "Y888  `"Ybbd8"'  
	                                                                                                                                                                                                                              
	A state represents a saved moment in the game and allows callbacks to external functions if a certain state is changed.
	If for example a state with the name of start is declared and its callback is set to the function of 'load' in say
	the file foo.lua then once the gamestate is changed to the state of start it is going to call foo.load()
	There is also a possibility for an end callback which is called when the state was active but has been changed to another.

	While creating a default state you will have to pass a table of parameters.
	Note: It is note suggested to use functions which require multiple parameters as only one single parameter or table can be passed.
	
	Parameters which can be included in the table passed in 'params':

	-------------------------------------------------------------------------------

	Name:			func // startFunc // startFunction
	Description:	A reference to the function which should be called when the state is activated.

	-------------------------------------------------------------------------------

	Name:			endFunction // endFunc
	Description:	A reference to the function which should be called when the state is closed.

	-------------------------------------------------------------------------------

	Name:			param // parameter // startParam // startParameter
	Description:	Start parameters should be passed here. These parameters will be passed when the startFunction is called.

	-------------------------------------------------------------------------------

	Name:			endParam // endParameter
	Description:	End parameters should be passed here. These parameters will be passed when the endFunction is called.

	-------------------------------------------------------------------------------
	
	Example: gamestate.addState("pause", {startFunction = game.pause, endFunction = game.resume, startParam = 5})

--]]

function gamestate.addState(name, params)
	if not stateStack[name] then
		local state = {}

		state.name = name
		state.startHooks = {}
		state.endHooks = {}

		function state:addStartHook(f, p)
			if not self.startHooks[f] then
				self.startHooks[f] = {func = f, param = p}
			end
		end

		function state:popStartHook(f)
			if self.startHooks[f] then
				self.startHooks[f] = nil
			end
		end

		function state:addEndHook(f, p)
			if not self.endHooks[f] then
				self.endHooks[f] = {func = f, param = p}
			end
		end

		function state:popEndHook(f)
			if self.endHooks[f] then
				self.endHooks[f] = nil
			end
		end

		if params then
			local startFunction = params.func or params.startFunc or params.startFunction
			local startParameter = params.param or params.parameter or params.startParam or params.startParameter

			if startFunction then
				state:addStartHook(startFunction, startParameter)
			end

			local endFunction = params.endFunc or params.endFunction
			local endParameter = params.endParam or params.endParameter

			if endFunction then
				state:addEndHook(endFunction, endParameter)
			end
		end

		stateStack[name] = state
	else
		print("Gamestate: The state with the name of '" ..name .."' is already in the state stack.")
	end
end

function gamestate.popState(name)
	stateStack[name] = nil
end

function gamestate.popAllStates()
	for i, state in pairs(stateStack) do
		state = nil
	end
end

function gamestate.setState(name)
	if stateStack[name] then
		local state = stateStack[name] 
		
		-- Call every function inside the last states endHooks table
		for i, callback in pairs(state.endHooks) do
			callback.func(callback.param)
		end

		-- Assign the given state to the new current state.
		currentState = name

		-- Call every function inside the new states startHooks table
		for i, callback in pairs(state.startHooks) do
			callback.func(callback.param)
		end
	end
end

-- By using the getState function we can access a certain state and add or remove callbacks.
function gamestate.getState()
	return currentState
end

function gamestate.getReference(name)
	if stateStack[name] then
		return stateStack[name]
	else
		print("Gamestate: The state with the name of '" ..name .."' was not found in the state stack.")
	end
end

-- These functions can be used to add function hooks to states
function gamestate.addHook(name, func, param, bool)
	if stateStack[name] then
		if bool == true then
			stateStack[name]:addStartHook(func, param)
		elseif bool == false then
			stateStack[name]:addEndHook(func, param)
		end
	else
		print("Gamestate: Unable to add a hook to the state with the name of '" ..name .."' as the specified state was not found in the stateStack.")
	end
end

function gamestate.addStartHook(name, func, param)
	if stateStack[name] then
		stateStack[name]:addStartHook(func, param)
	else
		print("Gamestate: Unable to add a hook to the state with the name of '" ..name .."' as the specified state was not found in the stateStack.")
	end
end

function gamestate.addEndHook(name, func, param)
	if stateStack[name] then
		stateStack[name]:addEndHook(func, param)
	else
		print("Gamestate: Unable to add a hook to the state with the name of '" ..name .."' as the specified state was not found in the stateStack.")
	end
end

-- Update states are called each frame and can not be interchange like a normal state.
function gamestate.addUpdateState(name, func)
	if not updateStack[name] then
		if func then
			updateStack[name] = func
		else
			print("Gamestate: The update state with the name of '" ..name .."' does not include a function in the parameters and will so be ignored.")
		end
	else
		print("Gamestate: The update state with the name of '" ..name .."' is already in the update stack.")
	end
end

function gamestate.popUpdateState(name)
	updateStack[name] = nil
end

function gamestate.addFixedUpdateState(name, func)
	if not fixedUpdateStack[name] then
		if func then
			fixedUpdateStack[name] = func
		else
			print("Gamestate: The fixed update state with the name of '" ..name .."' does not include a function in the parameters and will so be ignored.")
		end
	else
		print("Gamestate: The fixed update state with the name of '" ..name .."' is already in the fixed update stack.")
	end
end

function gamestate.popFixedUpdateState(name)
	fixedUpdateStack[name] = nil
end

-- Draw states are called each draw and can not be interchange like a normal state.
function gamestate.addDrawState(index, id, name, func)
	if not drawStack[index] then
		if func then
			drawStack[index] = {id = id, name = name, func = func}
		else
			print("Gamestate: The draw state with the index of '" ..index .."' does not include a function in the parameters and will so be ignored")
		end
	else
		print("Gamestate: The draw state with the index of '" ..index .."' is already in the draw stack.")
	end
end

function gamestate.popDrawState(name)
	updateStack[name] = nil
end

-- Returns the names of all the states inside the draw stack.
function gamestate.getDrawStack()
	local nameTable = {}

	for i, layer in pairs(drawStack) do
		nameTable[layer.id] = layer.name
	end

	return nameTable
end

-- Handling of gamestates inside the update calls as well as the main draw call.
function gamestate.update(dt)
	for i, state in pairs(updateStack) do
		state(dt)
	end
end

function gamestate.fixedUpdate(timestep)
	for i, state in pairs(fixedUpdateStack) do
		state(timestep)
	end
end

function gamestate.draw()
	for i, state in pairs(drawStack) do
		state.func(state.id, state.name)
	end
end

return gamestate
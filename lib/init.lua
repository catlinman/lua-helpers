
local lib = {}

-- Returns the current lua local path to this script.
local function scriptPath()
   local str = debug.getinfo(2, "S").source:sub(2)
   return str:match("(.*/)") or ""
end

local libpath = scriptPath()

-- These two libraries hook directly into native lua functions.
require(libpath .. "/math")
require(libpath .. "/utility")

-- Default libraries.
lib.color 		= require(libpath .. "/color")
lib.collision 	= require(libpath .. "/collision")
lib.vector 		= require(libpath .. "/vector")
lib.gamedata 	= require(libpath .. "/gamedata")
lib.gamestate 	= require(libpath .. "/gamestate")
lib.camera 		= require(libpath .. "/camera")

-- Input libraries.
lib.keys 		= require(libpath .. "/keys")
lib.mouse 		= require(libpath .. "/mouse")
lib.joystick 	= require(libpath .. "/joystick")

-- Uncomment the following line to make the library objects global without using the library object reference.
-- color, collision, vector, gamedata,´gamestate, camera, keys, mouse, joystick = lib.color, lib.collision, lib.vector, lib.gamedata, lib.gamestate, lib.camera, lib.keys, lib.mouse, lib.joystick

return lib -- Return the library reference to the user.

local lib = {}

-- These two libraries hook directly into native lua functions.
require("math")
require("utility")

-- Default libraries.
lib.color 		= require("color")
lib.collision 	= require("collision")
lib.vector 		= require("vector")
lib.gamedata 	= require("gamedata")
lib.gamestate 	= require("gamestate")
lib.camera 		= require("camera")

-- Input libraries.
lib.keys 		= require("keys")
lib.mouse 		= require("mouse")
lib.joystick 	= require("joystick")

-- Uncomment the following line to make the library objects global without using the library object reference.
-- color, collision, vector, gamedata,´gamestate, camera, keys, mouse, joystick = lib.color, lib.collision, lib.vector, lib.gamedata, lib.gamestate, lib.camera, lib.keys, lib.mouse, lib.joystick

return lib -- Return the library reference to the user.
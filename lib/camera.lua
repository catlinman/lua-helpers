
local camera = {} -- Camera module object.

local current = {} -- Stores the current default camera.

-- Screen size function is defined here. This allows the library to work with multiple engines without a lot of modifications.
local sizefunc = love.graphics.getDimensions() or video.getScreenSize()

-- Returns a new camera object.
function camera.create()
	c = {}

	c.x = 0
	c.y = 0
	c.sx = 1
	c.sy = 1
	c.rot = 0

	function c:setPosition(x, y)
		self.x = x
		self.y = y
	end

	function c:setScale(sx, sy)
		self.sx = sx
		self.sy = sy
	end

	function c:setRotation(r)
		self.rot = r
	end

	function c:getPositon()
		return self.x, self.y
	end

	function c:getScale()
		return self.sx, self.sy
	end

	function c:getRotation()
		return self.r
	end

	return c
end

-- Pushes a new camera to the current default camera
function camera.push(c)
	if c.x and c.y and c.sx and c.sy and c.rot then -- Validate the camera object.
		current = c
	end
end

-- Set the position of the current camera.
function camera.pushPosition(x, y)
	current.x, current.y =  x, y
end

-- Set the scale of the current camera.
function camera.pushScale(sx, sy)
	current.sx, current.sy = 1 / sx, 1 / sy
end

-- Set the rotation of the current camera.
function camera.pushRotation(r)
	current.rot = r
end

-- Return a reference to the current camera.
function camera.get()
	return current
end

-- Return the x and y position value of the current camera.
function camera.getPosition()
	return current.x, current.y
end

-- Return the x and y scaling value of the current camera.
function camera.getScale()
	return current.sx, current.sy
end

-- Return the current rotation of the camera in radians.
function camera.getRotation()
	return current.rot
end

-- Return translated positional values in relation to the camera.
function camera.translate(x1, y1)
	local width, height = sizefunc()
	local x2, y2 = x1 - current.x + width / 2, y1 - current.y + height / 2
	return x2, y2
end

-- Return translated positional values in relation to the camera without taking the actual screen properties into respect.
function camera.translateScreen(x1, y1)
	local x2, y2 = x1 + (current.x - x1), y1 + (current.y - y1)
	return x2, y2
end

-- Return translated positional values in relation to the camera with an added parallax effect.
function camera.translateParallax(x1, y1, speed)
	local width, height = sizefunc()
	local x2, y2 = x1 - current.x * speed + width / 2, y1 - current.y * speed  + height / 2
	return x2, y2
end

current = camera.create()

return camera
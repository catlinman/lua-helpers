
camera = {}

local current = {}

function camera.create()
	cam = {}

	cam.x = 0
	cam.y = 0
	cam.sx = 1
	cam.sy = 1
	cam.rot = 0

	function cam:setPosition(x, y)
		self.x = x
		self.y = y
	end

	function cam:setScale(sx, sy)
		self.sx = sx
		self.sy = sy
	end

	function cam:setRotation(r)
		self.rot = r
	end

	function cam:getPositon()
		return self.x, self.y
	end

	function cam:getScale()
		return self.sx, self.sy
	end

	function cam:getRotation()
		return self.r
	end

	return cam
end


function camera.push(cam)
	if cam.x and cam.y and cam.sx and cam.sy and cam.rot then
		current = cam
	end
end

function camera.pushPosition(x, y)
	current.x, current.y =  x, y
end

function camera.pushScale(sx, sy)
	current.sx, current.sy = 1 / sx, 1 / sy
end

function camera.pushRotation(r)
	current.rot = r
end


function camera.get()
	return current
end

function camera.getPosition()
	return current.x, current.y
end

function camera.getScale()
	return current.sx, current.sy
end

function camera.getRotation()
	return current.rot
end


function camera.translate(x1, y1)
	local width, height = video.getScreenSize()
	local x2, y2 = x1 - current.x + width / 2, y1 - current.y + height / 2
	return x2, y2
end

function camera.translateScreen(x1, y1)
	local x2, y2 = x1 + (current.x - x1), y1 + (current.y - y1)
	return x2, y2
end

function camera.translateParralax(x1, y1, speed)
	local width, height = video.getScreenSize()
	local x2, y2 = x1 - current.x * speed + width / 2, y1 - current.y * speed  + height / 2
	return x2, y2
end

current = camera.create()
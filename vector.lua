
vector = {} -- Vector library entry point.

-- Calculates the distance between two points.
function vector.distance(x1, y1, x2, y2)
	return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

-- Faster version of the distance calculation. Returns a squared value of the distance.
function vector.squaredDistance(x1, y1, x2, y2)
	return (x2 - x1)^2 + (y2 - y1)^2
end

-- Returns the length of a vector.
function vector.lenght(x, y)
	return math.sqrt((x * x) + (y * y)) 
end

-- Normalizes a vector.
function vector.normalize(x, y)
	local lenght = math.sqrt((x * x) + (y * y)) 
	return x / lenght, y / lenght
end
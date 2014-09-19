
vector = {}

function vector.distance(x1, y1, x2, y2)
	return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function vector.squaredDistance(x1, y1, x2, y2)
	return (x2 - x1)^2 + (y2 - y1)^2
end

function vector.lenght(x, y)
	return math.sqrt((x * x) + (y * y)) 
end

function vector.normalize(x, y)
	local lenght = math.sqrt((x * x) + (y * y)) 
	return x / lenght, y / lenght
end
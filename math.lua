local numTable = {-1, 1}

function math.round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function math.randNonNull()
	return numTable[math.random(1,2)]
end

function math.clamp(num, min, max)
	if num < min and min < max then num = min end
	if num > max and max > min then num = max end
	return num
end

function math.cycle(num, min, max)
	local tick = 0

	while num < min or num > max and tick < 10 do
		tick = tick + 1

		if num < min and min < max then
			local dist = min - num

			num = max - dist

		elseif num > max and max > min then
			local dist = max - num

			num = min + dist
		end

		if tick == 10 then
			return clamp(num, min, max)
		end
	end

	return num
end

function math.lerp(num, endNum, t)
	return num + (endNum - num) * t
end

function math.step(num, endNum, s)
	if endNum < num then
		num = math.max(num - s, endNum)
	else
		num = math.min(num + s, endNum)
	end

	return num
end

function math.percent(startNum, endNum, percent)
	if percent > 100 or percent < 0 then
		percent = math.clamp(percent, 0, 100)
	end

	num = (startNum * (percent)) + (endNum - endNum * (percent))

	return num
end

function math.randomFloat(a, b, decimal)
	local value_a = 1
	local value_b = 1

	if a ~= 0 then
		value_a = a / a
	else
		value_a = 1
	end

	if b ~= 0 then
		value_b = b / b
	else
		value_b = 1
	end

	if decimal then
		return math.random(a * (10 ^ decimal) * value_a, b * (10 * decimal) * value_b) / (10 ^ decimal)
	else
		return math.random(a * (10 ^ 5) * value_a, b * (10 ^ 5) * value_b) / (10 ^ 5)
	end
end

function math.lerpDeg(angle, endAngle, dt)
	local difference = math.abs(endAngle - angle)

    if difference > 180 then
        if endAngle > angle then
            angle = angle + 360
        else
        	endAngle = endAngle + 360
        end
    end

	local value = angle + (endAngle - angle) * dt

	local rangeZero = 360

	if(value >= 0 and value <= 360) then
		return value
	else
		return value % rangeZero
	end
end

function math.lerpRad(angle, endAngle, dt)
	local difference = math.abs(endAngle - angle)

    if difference > math.pi then
        if endAngle > angle then
            angle = angle + (math.pi * 2)
        else
        	endAngle = endAngle + (math.pi * 2)
        end
    end

	local value = angle + (endAngle - angle) * dt

	local rangeZero = (math.pi * 2)

	if(value >= 0 and value <= (math.pi * 2)) then
		return value
	else
		return value % rangeZero
	end
end
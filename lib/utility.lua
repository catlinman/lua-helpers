
-- These functions hook directly into the native lua table and string objects.
-- Return the length of a table.
function table.length(t)
	return #t
end

-- Add an entry to the end of a table.
function table.add(t, e)
	t[table.length(t) + 1] = e
end

-- Merge two tables.
function table.merge(t1, t2)
	local length = table.length(t2)

	for i, item in pairs(t1) do
		t2[length + i] = item
	end

	return t2
end

-- String splitting function.
function string.split(str, delim)
	if string.find(str, delim) == nil then
		return { str }
	end

	local result = {}
	local pat = "(.-)" .. delim .. "()"
	local nb = 0
	local lastPos

	for part, pos in string.gfind(str, pat) do
		nb = nb + 1
		result[nb] = part
		lastPos = pos
	end

	result[nb + 1] = string.sub(str, lastPos)

	return result
end

-- Insert a string into another string.
function string.insert(s1, s2, pos)
	return string.sub(s1, 1, pos) ..s2 ..string.sub(s1, pos + 1, #s1)
end

-- Drop a character a certain position.
function string.pop(str, pos)
	return string.sub(str, 1, pos) ..string.sub(str, pos + 2, #str)
end

-- Remove all UTF8 characters from a string.
function string.stripUTF8(str)
	return str:gsub('[%z\1-\127\194-\244][\128-\191]*', function(c) return #c > 1 and "" end)
end
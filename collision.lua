
collision = {} -- Global collision library entry point.

-- Returns true if two boxes intersect.
function collision.box(ax1, ay1, aw, ah, bx1, by1, bw, bh)
	local ax2, ay2, bx2, by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
	return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end

-- Returns true of a given box contains a certain point.
function collision.boxContains(ax, ay, bx, by, bw, bh)
	return ax < bx + bw and ax > bx and ay > by and ay < by + bh
end

-- Returns true if two three-dimensional boxes intersect.
function collision.box3d(ax1, ay1, az1, aw, ah, ad, bx1, by1, bz1, bw, bh, bd)
	local ax2, ay2, az2, bx2, by2, bz2 = ax1 + aw, ay1 + ah, az1 + ad, bx1 + bw, by1 + bh, bz1 + bd
	return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1 and az1 < bz2 and az2 > bz1
end
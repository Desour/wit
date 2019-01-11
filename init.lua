local camera
--~ minetest.register_on_connect(function()
	--~ minetest.after(0, function()
		--~ camera = minetest.camera
	--~ end)
--~ end)
minetest.register_on_mods_loaded(function()
	minetest.after(0, function()
		camera = minetest.camera
	end)
end)


local points = {}

local function vector_dot(a, b)
	return a.x * b.x + a.y * b.y + a.z * b.z
end

local function vector_cross(a, b)
	return {
		x = a.y * b.z - a.z * b.y,
		y = a.z * b.x - a.x * b.z,
		z = a.x * b.y - a.y * b.x
	}
end

local function wit(pa, pb, da, db)
	local dl = vector_cross(da, db)
	local n = vector_cross(da, dl)
	local b = (vector_dot(n, pa) - vector_dot(n, pb)) / vector_dot(n, db)
	local pl = vector.add(pb, vector.multiply(db, b))
	local g = (da.x*(pa.y-pl.y)+da.y*(pl.x-pa.x)) / (dl.y * da.x - dl.x * da.y)
	g = g / 2
	return vector.add(pl, vector.multiply(dl, g))
end

minetest.register_chatcommand("wit", {
    params = "A/B/S",
    description = "Says where both looks cross.",
    func = function(param)
		param = param:lower()
		if param == "s" then
			if not points.a or not points.b then
				return false, "Not both points are marked yet."
			end
			local pos = wit(points.a.pos, points.b.pos, points.a.dir, points.b.dir)
			return true, minetest.pos_to_string(vector.round(pos))
		elseif param ~= "a" and param ~= "b" then
			return false, "invalid param: "..param
		end
		points[param] = {
			pos = vector.divide(camera:get_pos(), 10),
			dir = camera:get_look_dir(),
		}
		return true, "Got point "..param:upper().."."
    end,
})

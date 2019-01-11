local camera
minetest.register_on_connect(function()
	minetest.after(0, function()
		camera = minetest.camera
	end)
end)

local points = {}

minetest.register_chatcommand("wit", {
    params = "A/B/S",
    description = "Says where both looks cross.",
    func = function(param)
		param = param:lower()
		if param == "s" then
			if not points.a or not points.b then
				return false, "Not both points are marked yet."
			end
			local m_a = points.a.dir.y / points.a.dir.x
			local m_b = points.b.dir.y / points.b.dir.x
			local x = (m_a*points.a.pos.x - points.a.pos.y - m_b*points.b.pos.x + points.b.pos.y) / (m_a - m_b)
			local l_a = (x - points.a.pos.x) / points.a.dir.x
			local endpos = vector.add(points.a.pos, vector.multiply(points.a.dir, l_a))
			return true, minetest.pos_to_string(vector.round(endpos))
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


local antigravities = {}

local same_pos = function(p1,p2)
	return p1.x == p2.x and p1.y == p2.y and p1.z == p2.z
end

local is_antigravity = function(pos)
	for _, i in ipairs(antigravities) do
		if  i.x == pos.x
		and i.y < pos.y
		and i.z == pos.z then
			return true
		end
	end
	return false
end

minetest.register_node("ruby:antigravity",{
	description = "Antigravity",
	tiles = {"ruby_antigravity.png"},
	is_ground_content = true,
	groups = {anti=1,level=2},
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
	end,
})

minetest.register_globalstep(function(dtime)
	for _, p in ipairs(minetest.get_connected_players()) do
		local pos = p:getpos()
		local rpos = {
			x = math.floor(pos.x+.5),
			y = math.floor(pos.y+.5),
			z = math.floor(pos.z+.5)
		}
		if is_antigravity(rpos) then
			p:set_physics_override(nil,nil,-1)
		else
			p:set_physics_override(nil,nil,1)
		end
	end
end)

minetest.register_abm({
	nodenames={"ruby:antigravity"},
	interval = 5,
	chance = 1,
	action = function(pos, node)
		minpos = {}
		minpos.x = pos.x - .5
		minpos.y = pos.y
		minpos.z = pos.z - .5
		maxpos = {}
		maxpos.x = pos.x + .5
		maxpos.y = pos.y
		maxpos.z = pos.z + .5
		minetest.add_particlespawner(100,5,
			minpos, maxpos,
			{x=0,y=20,z=0}, {x=0,y=20,z=0},
			{x=0,y=0,z=0}, {x=0,y=0,z=0},
			1, 1,
			.1, 1,
			false, "ruby_particle_mese.png")
			
		if not is_antigravity(pos) then
			table.insert(antigravities,pos)
		end
	end,
})

minetest.register_craft({
	output = 'ruby:antigravity',
	recipe = {
		{'default:mese_crystal','default:mese_crystal','default:mese_crystal'},
		{'default:mese_crystal','ruby:anticrystalblock','default:mese_crystal'},
		{'default:mese_crystal','default:mese_crystal','default:mese_crystal'},
	}
})


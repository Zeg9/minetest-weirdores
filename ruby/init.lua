minetest.register_craftitem("ruby:ruby", {
	description = "Ruby",
	inventory_image = "ruby_ruby.png",
})

minetest.register_craftitem("ruby:anticrystal", {
	description = "Anticrystal",
	inventory_image = "ruby_anticrystal.png",
})

minetest.register_node("ruby:stone_with_ruby", {
	description = "Rubies in Stone",
	tiles = {"default_stone.png^ruby_mineral_ruby.png"},
	is_ground_content = true,
	groups = {cracky=1},
	drop = "ruby:ruby",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("ruby:rubyblock", {
	description = "Ruby Block",
	tiles = {"ruby_ruby_block.png"},
	-- light_source = LIGHT_MAX, --TODO make Ruby lamp
	is_ground_content = true,
	groups = {cracky=1,level=2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("ruby:anticrystalblock", {
	description = "Anticrystal Block",
	tiles = {"ruby_anticrystal_block.png"},
	is_ground_content = true,
	groups = {anti=1,level=2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("ruby:antigravity",{
	description = "Antigravity",
	tiles = {"ruby_antigravity.png"},
	is_ground_content = true,
	groups = {anti=1,level=2},
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
	end,
})

minetest.register_abm({
	nodenames={"ruby:antigravity"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		pos.y = pos.y+.5
		local objs = minetest.env:get_objects_inside_radius(pos, .5)
		pos.y = pos.y -.5
		for _, obj in pairs(objs) do
			if obj:is_player() then
				obj:set_physics_override(nil,nil,-1)
				minetest.after(5.0,function()
					obj:set_physics_override(nil,nil,1)
				end)
			end
		end
	end,
})
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
	end,
})

minetest.register_abm({
	nodenames={"default:mese"},
	neighbors={"ruby:rubyblock"},
	interval = 5.0,
	chance = 5,
	action = function(pos,node,active_object_count,active_object_count_wider)
		minetest.add_particlespawner(10, 1,
			pos, pos,
			{x=-10,y=-10,z=-10}, {x=10,y=10,z=10},
			{x=-100,y=-100,z=-100}, {x=100,y=100,z=10},
			1, 1,
			.1,10,
			false, "ruby_particle_ruby.png")
		minetest.add_particlespawner(100, 1,
			pos, pos,
			{x=-10,y=-10,z=-10}, {x=10,y=10,z=10},
			{x=-100,y=-100,z=-100}, {x=100,y=100,z=100},
			1, 1,
			.1,10,
			false, "ruby_particle_mese.png")
		local r = 2 -- Radius for destroying
		for x = pos.x-r, pos.x+r, 1 do
			for y = pos.y-r, pos.y+r, 1 do
				for z = pos.z-r, pos.z+r, 1 do
					local cpos = {x=x,y=y,z=z}
					if minetest.env:get_node(cpos).name == "ruby:rubyblock" then
						local e = minetest.env:add_item(cpos,{name="ruby:anticrystal"})
						e:setvelocity({x=0,y=10,z=0})
					end
					-- The commented part allows to randomly destroy nodes around
					if --[[math.random(0,1) == 1
					or]] minetest.env:get_node(cpos).name == "ruby:rubyblock"
					or minetest.env:get_node(cpos).name == "default:mese" then
						minetest.env:remove_node(cpos)
					end
				end
			end
		end
	end,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "ruby:stone_with_ruby",
	wherein        = "default:stone",
	clust_scarcity = 18*18*18,
	clust_num_ores = 4,
	clust_size     = 3,
	height_min     = -5119,
	height_max     = -1024,
})


minetest.register_ore({
	ore_type       = "scatter",
	ore            = "ruby:stone_with_ruby",
	wherein        = "default:stone",
	clust_scarcity = 12*12*12,
	clust_num_ores = 4,
	clust_size     = 3,
	height_min     = -31000,
	height_max     = -5120,
})

minetest.register_craft({
	output = 'ruby:rubyblock',
	recipe = {
		{'ruby:ruby', 'ruby:ruby', 'ruby:ruby'},
		{'ruby:ruby', 'ruby:ruby', 'ruby:ruby'},
		{'ruby:ruby', 'ruby:ruby', 'ruby:ruby'},
	}
})
minetest.register_craft({
	output = 'ruby:anticrystalblock',
	recipe = {
		{'ruby:anticrystal', 'ruby:anticrystal', 'ruby:anticrystal'},
		{'ruby:anticrystal', 'ruby:anticrystal', 'ruby:anticrystal'},
		{'ruby:anticrystal', 'ruby:anticrystal', 'ruby:anticrystal'},
	}
})
minetest.register_craft({
	output = 'ruby:antigravity',
	recipe = {
		{'default:mese_crystal','default:mese_crystal','default:mese_crystal'},
		{'default:mese_crystal','ruby:anticrystalblock','default:mese_crystal'},
		{'default:mese_crystal','default:mese_crystal','default:mese_crystal'},
	}
})

local APS = 0.25 -- Anticrystal Pickaxe Speed
local APU = 100 -- Anticrystal Pickaxe Uses

minetest.register_tool("ruby:pick_anticrystal", {
	description = "Anticrystal Pickaxe",
	inventory_image = "ruby_tool_anticrystalpick.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=APS, [2]=APS, [3]=APS}, uses=APU, maxlevel=3},
			choppy={times={[1]=APS, [2]=APS, [3]=APS}, uses=APU, maxlevel=3},
			crumbly = {times={[1]=APS, [2]=APS, [3]=APS}, uses=APU, maxlevel=3},
			snappy={times={[1]=APS, [2]=APS, [3]=APS}, uses=APU, maxlevel=3},
			anti={times={[1]=APS*5, [2]=APS*5, [3]=APS*5}, uses=APU, maxlevel=3},
		},
		damage_groups = {fleshy=7},
	},
})

minetest.register_craft({
	output = 'ruby:pick_anticrystal',
	recipe = {
		{'ruby:anticrystal', 'ruby:anticrystal', 'ruby:anticrystal'},
		{'', 'default:stick', ''},
		{'', 'default:stick', ''},
	}
})

minetest.register_alias("default:stone_with_ruby","ruby:stone_with_ruby")
minetest.register_alias("default:ruby","ruby:ruby")

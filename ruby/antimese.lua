
-- ITEMS --

minetest.register_craftitem("ruby:antimese", {
	description = "Antimese Crystal",
	inventory_image = "ruby_antimese.png",
})

minetest.register_node("ruby:antimeseblock", {
	description = "Antimese Block",
	tiles = {"ruby_antimese_block.png"},
	is_ground_content = true,
	groups = {anti=1,level=2},
	sounds = default.node_sound_stone_defaults(),
})


local APS = 0.25 -- Antimese Pickaxe Speed
local APU = 100 -- Antimese Pickaxe Uses

minetest.register_tool("ruby:pick_antimese", {
	description = "Antimese Pickaxe",
	inventory_image = "ruby_tool_antimesepick.png",
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

-- CRAFTING --

minetest.register_craft({
	output = 'ruby:pick_antimese',
	recipe = {
		{'ruby:antimese', 'ruby:antimese', 'ruby:antimese'},
		{'', 'default:stick', ''},
		{'', 'default:stick', ''},
	}
})

minetest.register_craft({
	output = 'ruby:antimeseblock',
	recipe = {
		{'ruby:antimese', 'ruby:antimese', 'ruby:antimese'},
		{'ruby:antimese', 'ruby:antimese', 'ruby:antimese'},
		{'ruby:antimese', 'ruby:antimese', 'ruby:antimese'},
	}
})

-- ABM --

-- Ruby block + Mese block --> Antimese
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
						local e = minetest.env:add_item(cpos,{name="ruby:antimese"})
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

-- ALIASES --
-- This is for compatibility with older versions of the mod, where antimese was anticrystal
minetest.register_alias("ruby:anticrystal","ruby:antimese")
minetest.register_alias("ruby:anticrystalblock","ruby:antimeseblock")
minetest.register_alias("ruby:pick_anticrystal", "ruby:pick_antimese")


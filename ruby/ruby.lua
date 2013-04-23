minetest.register_craftitem("ruby:ruby", {
	description = "Ruby",
	inventory_image = "ruby_ruby.png",
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


-- This is for compatibility with the original version of the mod, which was a patch to default game
minetest.register_alias("default:stone_with_ruby","ruby:stone_with_ruby")
minetest.register_alias("default:ruby","ruby:ruby")

-- mobs_dinos: four dinosaurs for Mobs Redo
--
-- Every model carries ONE continuous animation timeline (Luanti only plays
-- a single glTF animation):
--     walk : frames 0 - 1   (seconds)
--     idle : frames 2 - 5   (seconds)
-- Frames are seconds in glTF, therefore the animation speed is 1.

local S = core.get_translator and core.get_translator("mobs_dinos") or function(s) return s end

local mod_name = "mobs_dinos"

-- Shared animation timeline (see header)
local function animation(walk_speed)
	return {
		speed_normal = 1,
		speed_run = 1,
		stand_start = 2, stand_end = 5, stand_speed = 1,
		walk_start = 0, walk_end = 1, walk_speed = walk_speed or 1,
		run_start = 0, run_end = 1, run_speed = (walk_speed or 1) * 1.6,
	}
end

-- Rotation (degrees) so the model faces its walking direction.
-- Change this if a model walks sideways/backwards in your setup.
local MODEL_ROTATE = 0

local dinos = {

	-- Fast, aggressive hunter: attacks players on sight
	raptor = {
		description = S("Raptor"),
		mesh = "green_raptor.gltf",
		texture = "palette_raptor.png",
		egg_color = "#3c9c3c",
		aggressive = true,
		hp = {18, 24},
		armor = 100,
		damage = 4,
		visual_size = {x = 4, y = 4},
		collisionbox = {-0.4, 0, -0.4, 0.4, 1.1, 0.4},
		walk_velocity = 1.5,
		run_velocity = 4.2,
		jump_height = 6,
		view_range = 16,
		reach = 2,
		walk_anim_speed = 1.2,
		spawn = {nodes = {"group:soil", "group:sand"}, chance = 7000, min_light = 0, max_light = 15, min_height = 0, max_height = 200},
	},

	-- Ribbed-head dinosaur: also attacks players on sight
	ribbedhead = {
		description = S("Ribbedhead"),
		mesh = "ribbedhead_dinosaur.gltf",
		texture = "palette_ribbedhead.png",
		egg_color = "#9c6c3c",
		aggressive = true,
		hp = {22, 30},
		armor = 100,
		damage = 5,
		visual_size = {x = 3, y = 3},
		collisionbox = {-0.5, 0, -0.5, 0.5, 1.0, 0.5},
		walk_velocity = 1.2,
		run_velocity = 3.4,
		jump_height = 6,
		view_range = 14,
		reach = 2,
		walk_anim_speed = 1.0,
		spawn = {nodes = {"group:soil", "group:sand"}, chance = 8000, min_light = 0, max_light = 15, min_height = 0, max_height = 200},
	},

	-- Giant, peaceful until attacked
	bronto = {
		description = S("Bronto"),
		mesh = "bronto.gltf",
		texture = "palette_bronto.png",
		egg_color = "#6c8c9c",
		aggressive = false,
		hp = {55, 70},
		armor = 100,
		damage = 7,
		visual_size = {x = 5, y = 5},
		collisionbox = {-0.8, 0, -0.8, 0.8, 2.65, 0.8},
		walk_velocity = 0.8,
		run_velocity = 2.2,
		jump_height = 6,
		view_range = 12,
		reach = 3,
		walk_anim_speed = 0.7,
		spawn = {nodes = {"group:soil"}, chance = 12000, min_light = 8, max_light = 15, min_height = 0, max_height = 200},
	},

	-- Armoured herbivore, peaceful until attacked
	pentasaurus = {
		description = S("Pentasaurus"),
		mesh = "pentasaurus_child.gltf",
		texture = "palette_pentasaurus.png",
		egg_color = "#9c3c6c",
		aggressive = false,
		hp = {30, 40},
		armor = 80,
		damage = 5,
		visual_size = {x = 4, y = 4},
		collisionbox = {-0.7, 0, -0.7, 0.7, 1.35, 0.7},
		walk_velocity = 0.9,
		run_velocity = 2.4,
		jump_height = 6,
		view_range = 12,
		reach = 2.5,
		walk_anim_speed = 0.8,
		spawn = {nodes = {"group:soil"}, chance = 10000, min_light = 8, max_light = 15, min_height = 0, max_height = 200},
	},
}

for id, d in pairs(dinos) do
	local name = mod_name .. ":" .. id

	mobs:register_mob(name, {
		description = d.description,
		type = "monster",
		-- aggressive dinos attack players on sight; the others only when hit
		attack_players = d.aggressive,
		attack_npcs = d.aggressive,
		passive = false,
		attack_type = "dogfight",
		damage = d.damage,
		reach = d.reach,
		hp_min = d.hp[1],
		hp_max = d.hp[2],
		armor = d.armor,
		visual = "mesh",
		mesh = d.mesh,
		textures = {{d.texture}},
		visual_size = d.visual_size,
		collisionbox = d.collisionbox,
		rotate = MODEL_ROTATE,
		makes_footstep_sound = true,
		walk_velocity = d.walk_velocity,
		run_velocity = d.run_velocity,
		jump = true,
		stepheight = 1.2,
		jump_height = d.jump_height,
		view_range = d.view_range,
		fear_height = 3,
		-- cannot swim: sinks in liquids and is hurt by water and lava
		floats = 0,
		water_damage = 2,
		lava_damage = 8,
		light_damage = 0,
		fall_damage = 1,
		drops = {
			{name = "mobs:meat_raw", chance = 1, min = 1, max = 3},
			{name = "mobs:leather", chance = 2, min = 0, max = 2},
		},
		animation = animation(d.walk_anim_speed),
	})

	local s = d.spawn
	mobs:spawn({
		name = name,
		nodes = s.nodes,
		neighbors = {"air"},
		min_light = s.min_light,
		max_light = s.max_light,
		interval = 30,
		chance = s.chance,
		active_object_count = 2,
		min_height = s.min_height,
		max_height = s.max_height,
	})

	-- spawn egg (own registration: tinted Mobs Redo egg icon, no masking)
	local egg_name = name .. "_egg"
	core.register_craftitem(egg_name, {
		description = S("@1 Spawn Egg", d.description),
		inventory_image = "mobs_chicken_egg.png^[colorize:" .. d.egg_color .. ":200",
		groups = {spawn_egg = 1},
		stack_max = 99,

		on_place = function(itemstack, placer, pointed_thing)
			if not placer or pointed_thing.type ~= "node" then return end

			local under = core.get_node(pointed_thing.under)
			local udef = core.registered_nodes[under.name]
			if udef and udef.on_rightclick then
				return udef.on_rightclick(pointed_thing.under, under, placer,
						itemstack, pointed_thing)
			end

			local pos = pointed_thing.above
			local pname = placer:get_player_name()
			if core.is_protected(pos, pname) then return end

			pos.y = pos.y - d.collisionbox[2] + 0.1
			if not core.add_entity(pos, name) then return end

			if not (core.is_creative_enabled and core.is_creative_enabled(pname)) then
				itemstack:take_item()
			end
			return itemstack
		end,
	})
end

core.log("action", "[mobs_dinos] loaded: raptor, ribbedhead, bronto, pentasaurus")

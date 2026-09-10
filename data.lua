
		-- vanilla player data :
		-- inventory_size = 60,
		-- build_distance = 6,
		-- drop_item_distance = 6,
		-- reach_distance = 6,
		-- item_pickup_distance = 1,
		-- reach_resource_distance = 2.7,
		-- loot_pickup_distance = 2,
		
---------------------------------------------------------------------
local add_technos = require("techno").add_technos
local func_techno

---------------------------------------------------------------------
-- inventory

func_techno = function(n,inc)
	return {
		icon = "__BigBags__/graphics/inventory.png",
		icon_size = 128,
		effects =
		{
			{
				type = "character-inventory-slots-bonus",
				modifier = (n < 4) and 30 or 20
				-- modifier = 20
			}
		},
		unit =
		{
			count = 100+50*inc,
			ingredients = {},
			time = 20+5*inc
		},
		order = "c-k-l..n",
	}
end

add_technos("inventory-size",1,5,0,func_techno)


---------------------------------------------------------------------
-- pickstick

func_techno = function(n,inc)
	return {
		icon = "__BigBags__/graphics/pickstick.png",
		icon_size = 128,
		effects =
		{
			{
				type = "character-build-distance",
				modifier = 12*n
			},
			{
				type = "character-item-drop-distance",
				modifier = 12*n
			},
			{
				type = "character-reach-distance",
				modifier = 12*n
			},
			-- {
				-- type = "character-item-pickup-distance",
				-- modifier = 12*n
			-- },
			{
				type = "character-resource-reach-distance",
				modifier = 12*n
			},
			{
				type = "character-loot-pickup-distance",
				modifier = 0.5
			},
		},
		unit =
		{
			count = 100+50*inc,
			ingredients = {},
			time = 30 + 10*inc
		},
		order = "c-k-n"..n,
	}
end

add_technos("pickstick",1,5,0,func_techno)


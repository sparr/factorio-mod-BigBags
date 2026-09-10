-- The worker robot technologies are registered here, in data-updates, rather than
-- in data.lua, so that technologies added by other mods already exist and can be
-- looked at before we extend the chain.
--
-- Bob's Logistics and 5Dim's New Logistic turn worker-robots-storage-4 into an
-- infinite research. Factorio refuses to load a finite level after an infinite one,
-- so adding our levels 4 to 10 on top of theirs aborted the game outright with
-- "Technology worker-robots-storage: Infinite research followed by level 5".
--
-- Whenever another mod has already extended the chain, its tiers are left alone
-- rather than overwritten.

local add_technos = require("techno").add_technos
local func_techno

---------------------------------------------------------------------
-- returns a reason string when somebody else owns the chain, nil when it is ours
local function robot_storage_taken()
	for name, techno in pairs(data.raw.technology) do
		local level = name:match("^worker%-robots%-storage%-(%d+)$")
		if level or name == "worker-robots-storage" then
			if techno.max_level == "infinite" or (techno.unit and techno.unit.count_formula) then
				return name .. " is an infinite research"
			end
			if level and tonumber(level) >= 4 then
				return name .. " was added by another mod"
			end
		end
	end
	return nil
end

---------------------------------------------------------------------
-- worker-robots-storage

func_techno = function(n,inc)
	return {
		icon = "__base__/graphics/technology/worker-robots-storage.png",
		icon_size = 128,
		effects = {
			{
				type = "worker-robot-storage",
				modifier = 1
			}
		},
		unit = {
			count = 500+inc*100,
			ingredients = {
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"production-science-pack", 1},
				{"utility-science-pack", 1},
			},
			time = 60
		},
		order = "c-k-g-d"..n
	}
end

local taken = robot_storage_taken()
if taken then
	log("BigBags: not extending worker robot storage, " .. taken .. ".")
else
	add_technos("worker-robots-storage",4,10,-1,func_techno)
end

---------------------------------------------------------------------
-- worker-robots-speed

func_techno = function(n,inc)
	return {
		icon = "__base__/graphics/technology/worker-robots-speed.png",
		icon_size = 128,
		effects = {
			{
				type = "worker-robot-speed",
				modifier = "0.8"
			}
		},
		unit = {
			count = 650+50*inc,
			ingredients = {
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
			},
			time = 60,
		},
		order = "c-k-f-f"..n
	}
end

-- add_technos("worker-robots-speed",6,8,-1)


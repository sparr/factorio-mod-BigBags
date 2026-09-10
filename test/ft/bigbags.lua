--- What Big Bags is for: bigger stacks, more slots, longer reach.
---
--- The mod is almost entirely data stage. Its technologies hand out force bonuses, and
--- data-final-fixes rewrites stack sizes across every prototype. Both are checked here
--- against the settings the mod ships with, since a factor that quietly stopped applying
--- would leave the mod loading perfectly and doing nothing.

local FACTOR = settings.startup["my_stack_factor"].value
local OFFSET = settings.startup["my_stack_offset"].value

describe("the technologies it adds", function()
    test("exist at all five levels", function()
        for _, name in pairs { "inventory-size", "pickstick" } do
            assert.is_truthy(prototypes.technology[name], name .. " is missing")
            for n = 2, 5 do
                assert.is_truthy(prototypes.technology[name .. "-" .. n],
                    name .. "-" .. n .. " is missing")
            end
        end
    end)

    test("chain their prerequisites", function()
        -- Each level requires the one below it, so a player cannot skip to level 5.
        for n = 2, 5 do
            local tech = prototypes.technology["inventory-size-" .. n]
            local expected = n == 2 and "inventory-size" or ("inventory-size-" .. (n - 1))
            assert.is_truthy(tech.prerequisites[expected],
                "inventory-size-" .. n .. " does not require " .. expected)
        end
    end)
end)

describe("researching them", function()
    local force

    before_each(function()
        force = game.forces["player"]
        for _, name in pairs { "inventory-size", "pickstick" } do
            force.technologies[name].researched = false
        end
    end)

    test("gives the inventory slots the technology promises", function()
        -- The effect is character-inventory-slots-bonus, 30 at the first level. This is
        -- the mod's headline feature: research it and the bag is bigger.
        local before = force.character_inventory_slots_bonus
        force.technologies["inventory-size"].researched = true
        assert.equals(before + 30, force.character_inventory_slots_bonus,
            "researching inventory-size did not widen the inventory")
    end)

    test("gives the reach the pickstick promises", function()
        -- Four distance effects at 12 per level, plus loot pickup at a flat 0.5.
        local build = force.character_build_distance_bonus
        local reach = force.character_reach_distance_bonus
        local resource = force.character_resource_reach_distance_bonus
        force.technologies["pickstick"].researched = true
        assert.equals(build + 12, force.character_build_distance_bonus, "build distance")
        assert.equals(reach + 12, force.character_reach_distance_bonus, "reach distance")
        assert.equals(resource + 12, force.character_resource_reach_distance_bonus,
            "resource reach distance")
    end)
end)

describe("the worker robot storage tiers", function()
    -- These are registered in data-updates rather than data.lua, so that a mod which
    -- has already made the chain infinite (Bob's Logistics, 5Dim's New Logistic) is
    -- visible before we extend it. Adding a finite level after an infinite one aborts
    -- the game outright, which is what used to happen. Nobody else owns the chain on
    -- vanilla, so here our levels should be present.
    test("extend the vanilla chain to level 10", function()
        for n = 4, 10 do
            assert.is_truthy(prototypes.technology["worker-robots-storage-" .. n],
                "worker-robots-storage-" .. n .. " is missing")
        end
    end)

    test("keep the three base game levels", function()
        for n = 1, 3 do
            assert.is_truthy(prototypes.technology["worker-robots-storage-" .. n],
                "base worker-robots-storage-" .. n .. " went missing")
        end
    end)
end)

describe("the stack size rewrite", function()
    -- data-final-fixes walks every prototype and applies offset + size * factor.
    local function expected(vanilla) return OFFSET + vanilla * FACTOR end

    test("multiplies an ordinary item once", function()
        -- Vanilla iron-plate is 100.
        assert.equals(expected(100), prototypes.item["iron-plate"].stack_size,
            "iron-plate was not scaled by the configured factor")
    end)

    test("multiplies a module once, not twice", function()
        -- Vanilla speed-module is 50. The loop over data.raw already covers data.raw.module,
        -- and data-final-fixes then walks the modules again. The comment on the ammo loop
        -- just above says as much -- "ammo are already modified in the previous loop" -- and
        -- ammo skips the second pass for that reason; modules and capsules do not.
        assert.equals(expected(50), prototypes.item["speed-module"].stack_size,
            "speed-module stack size is not the configured factor applied once")
    end)

    test("multiplies a capsule once, not twice", function()
        -- Vanilla grenade is 100.
        assert.equals(expected(100), prototypes.item["grenade"].stack_size,
            "grenade stack size is not the configured factor applied once")
    end)

    test("leaves things that stack alone alone", function()
        -- The rewrite is guarded on stack_size > 1, so single stack items such as armor
        -- and vehicles keep their size.
        assert.equals(1, prototypes.item["car"].stack_size, "the car should still be one per stack")
    end)
end)

describe("the default request amount", function()
    -- The mod rewrites every item's default logistic request amount so that entering a
    -- new item does not immediately order a full oversized stack. A value of 0 used to
    -- set the request amount to 0, which requested nothing; it now means "leave it".
    --
    -- LuaItemPrototype does not expose the field, so bb-tests records what the data
    -- stage produced on a hidden prototype and the value is read back from there.
    local function observed()
        local order = prototypes.item["bb-tests-observed"].order
        return order:match("^default_request_amount=(.+)$")
    end

    test("follows the setting, and at zero leaves the item's own default", function()
        local want = settings.startup["my_default_req_amount"].value
        local got = observed()
        if want == 0 then
            assert.equals("nil", got,
                "a setting of 0 should leave iron-plate's default request amount unset")
        else
            assert.equals(tostring(want), got,
                "the configured request amount was not applied")
        end
    end)
end)

describe("the running speed tweak", function()
    test("still finds the vanilla value it keys on", function()
        -- data-final-fixes only applies the factor when the vanilla running_speed is exactly
        -- 0.15. If the base game ever changes that number the feature silently stops working,
        -- so this pins the assumption rather than the result.
        local factor = settings.startup["my_running_speed_factor"].value
        local speed = prototypes.entity["character"].running_speed
        if factor == 1 then
            assert.is_true(math.abs(speed - 0.15) < 0.0001,
                "vanilla running speed is no longer 0.15, so the speed setting would do nothing")
        else
            assert.is_true(math.abs(speed - 0.15 * factor) < 0.0001,
                "the running speed factor was not applied")
        end
    end)
end)

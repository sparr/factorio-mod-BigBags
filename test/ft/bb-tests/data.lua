-- Prototypes the stack size fixtures need. They are defined here, in data.lua, rather
-- than in this mod's data-final-fixes, because bb-tests depends on BigBags and so its
-- data-final-fixes runs afterwards. Defined here, they exist before BigBags rewrites
-- anything, which is what the fixtures want to observe.

local function probe(name, flags)
    return {
        type = "item",
        name = name,
        icon = "__base__/graphics/icons/iron-plate.png",
        icon_size = 64,
        stack_size = 5,
        hidden = true,
        flags = flags,
    }
end

data:extend{
    -- never sits in an inventory, so its stack size should be left alone
    probe("bb-tests-cursor-only", {"only-in-cursor"}),
    -- an ordinary item with the same stack size, as a control
    probe("bb-tests-ordinary", nil),
}

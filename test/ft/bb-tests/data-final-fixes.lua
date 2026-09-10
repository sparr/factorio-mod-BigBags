-- LuaItemPrototype does not expose default_request_amount, so the control stage cannot
-- read back what BigBags did to it. Record the value here, where the data stage can
-- still see it, on a hidden prototype the fixtures can read.
--
-- bb-tests depends on BigBags, so this runs after BigBags' own data-final-fixes.
local iron = data.raw.item["iron-plate"]

data:extend({{
    type = "item",
    name = "bb-tests-observed",
    icon = "__base__/graphics/icons/iron-plate.png",
    icon_size = 64,
    stack_size = 1,
    hidden = true,
    order = "default_request_amount=" .. tostring(iron and iron.default_request_amount),
}})

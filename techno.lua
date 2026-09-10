-- Shared builder for the mod's tiered technologies.
--
-- Each caller passes a func_techno(n,inc) returning the prototype body for level
-- n, where inc counts levels above the first. add_technos names the levels, chains
-- each one's prerequisite to the level below, and adds the science pack
-- ingredients. data.lua and data-updates.lua both use it.

local M = {}

		
local function add_techno_level(name,n1,n,add_ingrs,func_techno)
	local techno = func_techno(n,n-n1)
	
	techno.type = "technology"
	techno.upgrade = true
	
	if n > 1 then
		techno.name = name .. "-" .. n
		if n == 2 then
			techno.prerequisites = {name}
		else
		techno.prerequisites = {name .. "-" .. (n-1)}
		end
	else
		techno.name = name
	end
	
	if add_ingrs ~= -1 then
		if n+add_ingrs >= 1 then
			table.insert(techno.unit.ingredients,{"automation-science-pack", 1})
		end
		if n+add_ingrs >= 2 then
			table.insert(techno.unit.ingredients,{"logistic-science-pack", 1})
		end
		if n+add_ingrs >= 3 then
			table.insert(techno.unit.ingredients,{"chemical-science-pack", 1})
		end
		if n+add_ingrs >= 4 then
			table.insert(techno.unit.ingredients,{"production-science-pack", 1})
		end
		if n+add_ingrs >= 5 then
			table.insert(techno.unit.ingredients,{"utility-science-pack", 1})
		end
	end
	
	data:extend({techno})
end

local function add_technos(name,n1,n2,add_ingrs,func_techno)
	for n=n1,n2 do
			add_techno_level(name,n1,n,add_ingrs,func_techno)
	end
end

M.add_techno_level = add_techno_level
M.add_technos = add_technos

return M

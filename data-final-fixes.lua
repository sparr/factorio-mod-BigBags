local my_stack_factor = settings.startup['my_stack_factor'].value
local my_stack_offset = settings.startup['my_stack_offset'].value
local my_mag_factor = settings.startup['my_mag_factor'].value
local my_mag_offset = settings.startup['my_mag_offset'].value
local my_default_req_amount = settings.startup['my_default_req_amount'].value
-- 0 means leave every item's own default request amount alone, rather than setting it to 0.
local my_running_speed_factor = settings.startup['my_running_speed_factor'].value

function new_size( oldvalue, offset, factor )
	if oldvalue == nil then oldvalue = 1 end
	local v = offset + oldvalue * factor
	if v > oldvalue then
		return( v )
	else
		return oldvalue
	end
end

-- running speed
if my_running_speed_factor and my_running_speed_factor ~= 1 and data.raw.character.character.running_speed == 0.15 then data.raw.character.character.running_speed = 0.15 * my_running_speed_factor end

-- item stacks
for _,dat in pairs(data.raw) do
	for _,item in pairs(dat) do
		if item.stack_size and type(item.stack_size) == "number" and item.stack_size > 1 then
			item.stack_size = new_size( item.stack_size, my_stack_offset, my_stack_factor )	
			if my_default_req_amount > 0 then
				item.default_request_amount = my_default_req_amount
			end
		end
	end
end

-- ammo stacks
for _, ammo in pairs(data.raw.ammo) do
	-- ammo.stack_size = new_size( ammo.stack_size, my_stack_offset, my_stack_factor )	-- ammo are already modified in the previsous loop
	if ammo.stack_size and type(ammo.stack_size) == "number" and ammo.stack_size > 1 then
		ammo.magazine_size = new_size( ammo.magazine_size, my_mag_offset, my_mag_factor )
		if my_default_req_amount > 0 then ammo.default_request_amount = my_default_req_amount end
	end
end

-- module and capsule stacks are already modified in the loop over data.raw above,
-- the same way ammo is. Scaling them a second time applied the factor twice: with
-- the default factor of 10 a speed module stacked to 5000 rather than 500.




--discharge-defense-remote"
local Mana_Orb = require("data/tower/towers/mana_orb")
local Shooter = require("data/tower/towers/shooter")
local Brick = require("data/tower/towers/brick")

local t_c_t = {}

t_c_t.get = function(id)
    assert(t_c_t.table[id] ~= nil, "Tower id" .. id .. "not seen in data/tower/towers/tower_class_table.lua!")
    if t_c_t.table[id].__typ == nil then
        return t_c_t.table[id]
    elseif type(t_c_t.table[id]) == "table" then
        return t_c_t.table[id].__typ
    else
        assert(false, "Invalid type" .. type(t_c_t.table[id]) .. "in table at" .. id)
    end
end

t_c_t.mods = function(id)
    assert(t_c_t.table[id] ~= nil, "Tower id" .. id .. "not seen in data/tower/tower/tower_class_table.lua!")
    if t_c_t.table[id].__typ == nil then
        local dummy = {}
        return dummy
    elseif type(t_c_t.table[id] == "table") then
        return t_c_t.table[id]
    else 
        assert(false, "Invalid type" .. type(t_c_t.table[id]) .. "in table at" .. id)
    end
end

t_c_t.table = {
    shooter = Shooter,
    mana_orb = Mana_Orb,
    brick = Brick,
}

t_c_t.number_table = {
    [1] = "shooter",
    [2] = "mana_orb",
    [3] = "brick",
}

t_c_t.special_slot_sprite_locations = {}

t_c_t.special_costs = {}

t_c_t.special_recharges = {}

t_c_t.slot_sprite = function(id)
    if t_c_t.special_slot_sprite_locations[id] then
        return love.graphics.newImage(t_c_t.special_slot_sprite_locations[id])
    else
        return love.graphics.newImage("sprite/tower/slot/" .. id .. ".png")
    end
end

t_c_t.cost = function(id)
    if t_c_t.special_costs[id] then
        return t_c_t.special_costs[id]
    else
        return t_c_t.table[id].manacost
    end
end

t_c_t.recharge = function(id)
    if t_c_t.special_recharges[id] then
        return t_c_t.special_recharges[id]
    else
        return t_c_t.table[id].recharge
    end
end


return t_c_t
local Mana_Orb = require("data/tower/towers/mana_orb")
local Shooter = require("data/tower/towers/shooter")

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
    mana_orb = Mana_Orb
}

return t_c_t
local Bolt = require("data/projectile/projectiles/bolt")
local Mana_Packet = require("data/projectile/projectiles/mana_packet")

local p_c_t = {}

p_c_t.get = function(id)
    assert(p_c_t.table[id] ~= nil, "Projectile id" .. id .. "not seen in data/projectile/projectiles/projectile_class_table.lua!")
    if p_c_t.table[id].__typ == nil then
        return p_c_t.table[id]
    elseif type(p_c_t.table[id]) == "table" then
        return p_c_t.table[id].__typ
    else
        assert(false, "Invalid type" .. type(p_c_t.table[id]) .. "in table at" .. id)
    end
end

p_c_t.mods = function(id)
    assert(p_c_t.table[id] ~= nil, "Projectile id" .. id .. "not seen in data/projectile/projectiles/projectile_class_table.lua!")
    if p_c_t.table[id].__typ == nil then
        local dummy = {}
        return dummy
    elseif type(p_c_t.table[id] == "table") then
        return p_c_t.table[id]
    else 
        assert(false, "Invalid type" .. type(p_c_t.table[id]) .. "in table at" .. id)
    end
end



p_c_t.table = {
    bolt = {__typ = Bolt, sprite = love.graphics.newImage("sprite/projectile/bolt.png")},
    mana_packet = Mana_Packet
}

return p_c_t
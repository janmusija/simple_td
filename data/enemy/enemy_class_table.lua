local Cube = require("data/enemy/enemies/cube")
local Matryoshka = require("data/enemy/enemies/matryoshka")

local e_c_t = {}

e_c_t.get = function(id)
    assert(e_c_t.table[id] ~= nil, "Enemy id" .. id .. "not seen in data/enemy/enemies/enemy_class_table.lua!")
    if e_c_t.table[id].__typ == nil then
        return e_c_t.table[id]
    elseif type(e_c_t.table[id]) == "table" then
        return e_c_t.table[id].__typ
    else
        assert(false, "Invalid type" .. type(e_c_t.table[id]) .. "in table at" .. id)
    end
end

e_c_t.mods = function(id)
    assert(e_c_t.table[id] ~= nil, "Enemy id" .. id .. "not seen in data/enemy/enemies/enemy_class_table.lua!")
    if e_c_t.table[id].__typ == nil then
        local dummy = {}
        return dummy
    elseif type(e_c_t.table[id] == "table") then
        return e_c_t.table[id]
    else 
        assert(false, "Invalid type" .. type(e_c_t.table[id]) .. "in table at" .. id)
    end
end



e_c_t.table = {
    cubeh = Cube,
    matryoshka = Matryoshka,


    -- duplicates-- which can therefore have alternate modifiers, weights, etc...
    also_cube = Cube,
    third_cube = Cube,
    cube = {__typ = Matryoshka, size = 3},
    matryoshka4 = {__typ = Matryoshka, size = 4}
}

return e_c_t
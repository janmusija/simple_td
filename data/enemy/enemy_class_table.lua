local Cube = require("data/enemy/enemies/cube")
local Matryoshka = require("data/enemy/enemies/matryoshka")
local Angry_Cube = require("data/enemy/enemies/angry_cube")
local Steamroller = require("data/enemy/enemies/steamroller")
local Swift_Cube = require("data/enemy/enemies/swift_cube")
local Wavepoint_Bottle = require("data/enemy/enemies/wavepoints_in_a_bottle")

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
    cube = Cube,
    matryoshka = Matryoshka,
    angry_cube = Angry_Cube,
    swift_cube = Swift_Cube,
    steamroller = Steamroller,
    wavepoints_in_a_bottle = Wavepoint_Bottle,

    -- duplicates-- which can therefore have alternate modifiers, weights, etc...
    also_cube = Cube,
    third_cube = Cube,
    matryoshka3 = {__typ = Matryoshka, size = 3},
    matryoshka4 = {__typ = Matryoshka, size = 4},
    hoyryjyra = {__typ = Steamroller, speed = 0.3, health = 200, sprite = love.graphics.newImage("sprite/enemy/hoyryjyra.png")}
}

return e_c_t
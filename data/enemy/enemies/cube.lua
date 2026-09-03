local Enemy = require("data/enemy/enemy")

local Cube = Enemy:extend()

function Cube:new(state,y,mods)
    if mods == nil then mods = {} end
    Cube.super.new(self,state,y,mods) -- common enemy initialization
    self.sprite = mods.sprite or Cube.sprite
    self.hp = mods.hp or 24
end

Cube.compatible_tiles = {normal = true, water = true}

Cube.weight = 4
Cube.sprite = love.graphics.newImage("sprite/enemy/cube.png")

return Cube
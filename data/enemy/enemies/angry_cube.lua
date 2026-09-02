local Enemy = require("data/enemy/enemy")

local Angry_Cube = Enemy:extend()

function Angry_Cube:new(state,y,mods)
    if mods == nil then mods = {} end
    Angry_Cube.super.new(self,state,y,mods) -- common enemy initialization
    self.sprite = mods.sprite or Angry_Cube.sprite
    self.hp = mods.hp or 50
    self.attack_dmg = mods.attack_dmg or 4
end

Angry_Cube.weight = 2
Angry_Cube.wavepoints = 3
Angry_Cube.sprite = love.graphics.newImage("sprite/enemy/angry_cube.png")

return Angry_Cube
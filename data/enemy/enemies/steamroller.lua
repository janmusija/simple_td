local Enemy = require("data/enemy/enemy")

-- hate
local Steamroller = Enemy:extend()

function Steamroller:new(state,y,mods)
    if mods == nil then mods = {} end
    Steamroller.super.new(self,state,y,mods) -- common enemy initialization
    self.sprite = mods.sprite or Steamroller.sprite
    self.hp = mods.hp or 100
    self.speed = mods.speed or 0.2
    self.block_stall_time = 0
    self.attack_dmg = mods.attack_dmg or 40
end

Steamroller.weight = 1
Steamroller.wavepoints = 7
Steamroller.sprite = love.graphics.newImage("sprite/enemy/steamroller.png")

return Steamroller
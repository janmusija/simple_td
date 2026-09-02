local Enemy = require("data/enemy/enemy")

-- hate.
local Wavepoint_Bottle = Enemy:extend()

function Wavepoint_Bottle:new(state,y,mods)
    if mods == nil then mods = {} end
    Wavepoint_Bottle.super.new(self,state,y,mods) -- common enemy initialization
    self.sprite = mods.sprite or Wavepoint_Bottle.sprite
    self.hp = mods.hp or 60
    self.speed = mods.speed or 0.2
    self.wp = mods.wp or 4
    self.stop_x = mods.stop_x or 5
end

Wavepoint_Bottle.weight = 1
Wavepoint_Bottle.wavepoints = 5
Wavepoint_Bottle.sprite = love.graphics.newImage("sprite/enemy/wavepoints_in_a_bottle.png")

function Wavepoint_Bottle:destroy(state)
    state.leveldata.bonus_wavepoints = state.leveldata.bonus_wavepoints + self.wp
end

function Wavepoint_Bottle:moveforward()
    self.x = self.x + self.speed * (1/60)
    if (self.x > self.stop_x) then self.x = self.stop_x end
end

return Wavepoint_Bottle
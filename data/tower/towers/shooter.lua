local Tower = require("data/tower/tower")

local Shooter = Tower:extend()

function Shooter:new(state,x,y,mods)
    if mods == nil then mods = {} end
    Shooter.super.new(self,state,x,y) -- common tower initialization
    self.sprite = mods.sprite or love.graphics.newImage("sprite/tower/shooter.png")
    self.rof = mods.rof or 60 -- ticks per attack
    self.cooldown = 0 -- time left before next able to attack
    self.dps = mods.dps or 2 --damage per shot
end

Shooter.manacost = 40

return Shooter
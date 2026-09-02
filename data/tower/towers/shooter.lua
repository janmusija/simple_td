local Tower = require("data/tower/tower")

-- basic attacker
local Shooter = Tower:extend()

function Shooter:new(state,x,y,mods)
    if mods == nil then mods = {} end
    Shooter.super.new(self,state,x,y,mods) -- common tower initialization
    self.sprite = mods.sprite or love.graphics.newImage("sprite/tower/shooter.png")
    self.rof = mods.rof or 60 -- ticks per attack
    self.cooldown = 5 -- time left before next able to attack
    self.dps = mods.dps or 2 --damage per shot
    self.projectile = mods.projectile or "bolt"
end

Shooter.manacost = 40

function Shooter:update(state)
    Shooter.super.update(self,state)
    -- decrease cooldown
    if (self.cooldown > 0) then self.cooldown = self.cooldown -1
    else
        if self:valid_forward_target(state) then
            self.cooldown = self.rof
            self:fire_projectile(state,"bolt",-5/60,0)
        end
    end
end

return Shooter
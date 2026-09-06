local Tower = require("data/tower/tower")

-- basic attacker
local Snowflake = Tower:extend()

function Snowflake:new(state,x,y,mods)
    if mods == nil then mods = {} end
    Snowflake.super.new(self,state,x,y,mods) -- common tower initialization
    self.sprite = mods.sprite or Snowflake.sprite
    self.rof = mods.rof or 60 -- ticks per attack
    self.cooldown = 5 -- time left before next able to attack
    self.dps = mods.dps or 1 --damage per shot
    self.projectile = mods.projectile or "ice_bolt"
end

Snowflake.manacost = 50
Snowflake.sprite = love.graphics.newImage("sprite/tower/snowflake.png")

function Snowflake:update(state)
    Snowflake.super.update(self,state)
    -- decrease cooldown
    if (self.cooldown > 0) then self.cooldown = self.cooldown -1
    else
        if self:valid_forward_target(state) then
            self.cooldown = self.rof
            local damage_OR = {dmg = self.dps}
            self:fire_projectile(state,"ice_bolt",-5/60,0,damage_OR)
        end
    end
end

return Snowflake
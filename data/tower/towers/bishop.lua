local Tower = require("data/tower/tower")

-- diagonal attacker
local Bishop = Tower:extend()

function Bishop:new(state,x,y,mods)
    if mods == nil then mods = {} end
    Bishop.super.new(self,state,x,y,mods) -- common tower initialization
    self.sprite = mods.sprite or Bishop.sprite
    self.rof = mods.rof or 70 -- ticks per attack
    self.cooldown = 5 -- time left before next able to attack
    self.dps = mods.dps or 2 --damage per shot
    self.projectile = mods.projectile or "bolt"
end

Bishop.manacost = 50
Bishop.sprite = love.graphics.newImage("sprite/tower/bishop.png")

function Bishop:update(state)
    Bishop.super.update(self,state)
    -- decrease cooldown
    if (self.cooldown > 0) then self.cooldown = self.cooldown -1
    else
        local b = false
        for i = 1, #state.leveldata.ENEMY_ARRAY do
        local en = state.leveldata.ENEMY_ARRAY[i]
            if (math.abs((en.x + en.y) - (self.x + self.y) ) <= 1 or math.abs((en.x - en.y) - (self.x - self.y) ) <= 1) then 
                b = true
                break
            end
        end
        if b then
            self.cooldown = self.rof
            local damage_OR = {dmg = self.dps}
            self:fire_projectile(state,"pellet",-3.5/60,-3.5/60,damage_OR)
            self:fire_projectile(state,"pellet",-3.5/60,3.5/60,damage_OR)
            self:fire_projectile(state,"pellet",3.5/60,-3.5/60,damage_OR)
            self:fire_projectile(state,"pellet",3.5/60,3.5/60,damage_OR)
        end
    end
end

return Bishop
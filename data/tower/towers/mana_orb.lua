local Tower = require("data/tower/tower")

-- mana production
local Mana_Orb = Tower:extend()

function Mana_Orb:new(state,x,y,mods)
    if mods == nil then mods = {} end
    Mana_Orb.super.new(self,state,x,y,mods) -- common tower initialization
    self.sprite = mods.sprite or love.graphics.newImage("sprite/tower/mana_orb.png")
    self.production_size = mods.production_size or 10 -- produce mana in packets of this size
    self.production_period = mods.production_period or 19*60 -- in seconds
    self.tick_countdown = mods.tick_countdown or 5*60 -- first packet of mana produced in 5 seconds
    -- yes, I chose these values arbitrarily. they are subject to change
end

Mana_Orb.manacost = 20

function Mana_Orb:update(state)
    Mana_Orb.super.update(self,state)
    -- decrease cooldown
    if (self.tick_countdown > 0) then self.tick_countdown = self.tick_countdown -1
    else
        self.tick_countdown = self.production_period
        local m = {mv = self.production_size}
        self:fire_projectile(state,"mana_packet",0,-1/3,m)
    end
end

return Mana_Orb
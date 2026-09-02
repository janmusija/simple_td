local Tower = require("data/tower/tower")

local Mana_Orb = Tower:extend()

function Mana_Orb:new(state,x,y,mods)
    if mods == nil then mods = {} end
    Mana_Orb.super.new(self,state,x,y,mods) -- common tower initialization
    self.sprite = mods.sprite or love.graphics.newImage("sprite/tower/mana_orb.png")
    self.production_size = mods.production_size or 10 -- produce mana in packets of this size
    self.production_period = mods.production_period or 15*60 -- in seconds
    self.tick_countdown = mods.tick_countdown or 7*60 -- first packet of mana produced in 7 seconds
    -- yes, I chose these values arbitrarily. they are subject to change
end

Mana_Orb.manacost = 30

return Mana_Orb
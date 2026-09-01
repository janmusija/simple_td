local Tower = require("data/tower/tower")

local Mana_Orb = Tower:extend()

function Mana_Orb:new(state,x,y)
    Mana_Orb.super.new(self,state,x,y) -- common tower initialization
    self.sprite = love.graphics.newImage("sprite/tower/shooter.png")
end

return Mana_Orb
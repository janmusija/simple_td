local Tower = require("data/tower/tower")

local Shooter = Tower:extend()

function Shooter:new(state,x,y)
    Shooter.super.new(self,state,x,y) -- common tower initialization
    self.sprite = love.graphics.newImage("sprite/tower/shooter.png")
end

return Shooter
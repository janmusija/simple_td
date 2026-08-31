local Tower = require("data/tower/tower")

function Shooter:new(state,x,y)
    Shooter.super.new(self,state,x,y) -- common enemy initialization
    self.sprite = love.graphics.newImage("sprite/tower/shooter.png")
end

return Shooter
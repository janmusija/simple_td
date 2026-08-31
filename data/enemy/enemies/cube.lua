local Enemy = require("data/enemy/enemy")

local Cube = Enemy:extend()

function Cube:new(state,y)
    Cube.super.new(self,state,y) -- common enemy initialization
    self.sprite = love.graphics.newImage("sprite/enemy/cube.png")
end

return Cube
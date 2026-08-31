local Enemy = require("data/enemy/enemy")

local Cube = Enemy:extend()

function Cube:new(state,y,mods)
    if mods == nil then mods = {} end
    Cube.super.new(self,state,y) -- common enemy initialization
    self.sprite = mods.sprite or love.graphics.newImage("sprite/enemy/cube.png")
end

Cube.weight = 3

return Cube
local Enemy = require("data/enemy/enemy")

local Swift_Cube = Enemy:extend()

function Swift_Cube:new(state,y,mods)
    if mods == nil then mods = {} end
    Cube.super.new(self,state,y,mods) -- common enemy initialization
    self.sprite = mods.sprite or love.graphics.newImage("sprite/enemy/swift_cube.png")
    self.hp = mods.hp or 20
    self.speed = mods.speed or 0.5
end

Swift_Cube.weight = 2
Swift_Cube.wavepoints = 3

return Swift_Cube
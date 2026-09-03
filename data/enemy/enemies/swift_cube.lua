local Enemy = require("data/enemy/enemy")

local Swift_Cube = Enemy:extend()

function Swift_Cube:new(state,y,mods)
    if mods == nil then mods = {} end
    Swift_Cube.super.new(self,state,y,mods) -- common enemy initialization
    self.sprite = mods.sprite or love.graphics.newImage("sprite/enemy/swift_cube.png")
    self.hp = mods.hp or 20
    self.speed = mods.speed or 0.5
end

Swift_Cube.compatible_tiles = {normal = true, water = true, air = true}

Swift_Cube.weight = 2
Swift_Cube.wavepoints = 3

function Swift_Cube:moveforward()
    if self.debuffs.slow then
        self.x = self.x + self.speed * (1/90) -- less debuffed by slow
    else
        self.x = self.x + self.speed * (1/60) -- speed is x per 60 frames
    end
end

return Swift_Cube
local Tower = require("data/tower/tower")


-- THE wall.
local Brick = Tower:extend()

function Brick:new(state,x,y,mods)
    if mods == nil then mods = {} end
    Brick.super.new(self,state,x,y,mods) -- common tower initialization
    self.sprite = mods.sprite or Brick.sprite
    self.hp = 300 
end

Brick.sprite = love.graphics.newImage("sprite/tower/brick.png")
Brick.manacost = 30
Brick.recharge = 15*60

return Brick
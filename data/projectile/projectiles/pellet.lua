local Projectile = require("data/projectile/projectile")

local Pellet = Projectile:extend()

function Pellet:new(state,x,y,velocityx,velocityy,mods)
    if mods == nil then mods = {} end
    Pellet.super.new(self,state,x,y,velocityx,velocityy,mods) -- common projectile initialization
    self.sprite = mods.sprite or Pellet.sprite
    self.dmg = mods.dmg or 2
    self.damagestowers = mods.damagestowers or false
    self.damagesenemies = mods.damagesenemies or true
    self.hitboxradius = mods.hitboxradius or 0.3
end

Pellet.sprite = love.graphics.newImage("sprite/projectile/pellet.png")


return Pellet
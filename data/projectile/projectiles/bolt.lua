local Projectile = require("data/projectile/projectile")

local Bolt = Projectile:extend()

function Bolt:new(state,x,y,velocityx,velocityy,mods)
    if mods == nil then mods = {} end
    Bolt.super.new(self,state,x,y,velocityx,velocityy,mods) -- common projectile initialization
    self.sprite = mods.sprite or Bolt.sprite
    self.dmg = mods.dmg or 2
    self.damagestowers = mods.damagestowers or false
    self.damagesenemies = mods.damagesenemies or true
    self.hitboxradius = 0.2
end

Bolt.sprite = love.graphics.newImage("sprite/projectile/bolt.png")


return Bolt
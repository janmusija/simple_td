local Projectile = require("data/projectile/projectile")

local Foe_Bolt = Projectile:extend()

function Foe_Bolt:new(state,x,y,velocityx,velocityy,mods)
    if mods == nil then mods = {} end
    Foe_Bolt.super.new(self,state,x,y,velocityx,velocityy,mods) -- common projectile initialization
    self.sprite = mods.sprite or Foe_Bolt.sprite
    self.dmg = mods.dmg or 2
    self.damagestowers = mods.damagestowers or true
    self.damagesenemies = mods.damagesenemies or false
    self.hitboxradius = mods.hitboxradius or 0.2
end

Foe_Bolt.sprite = love.graphics.newImage("sprite/projectile/foe_bolt.png")


return Foe_Bolt
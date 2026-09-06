local Projectile = require("data/projectile/projectile")

local Ice_Bolt = Projectile:extend()

function Ice_Bolt:new(state,x,y,velocityx,velocityy,mods)
    if mods == nil then mods = {} end
    Ice_Bolt.super.new(self,state,x,y,velocityx,velocityy,mods) -- common projectile initialization
    self.sprite = mods.sprite or Ice_Bolt.sprite
    self.dmg = mods.dmg or 1
    self.damagestowers = mods.damagestowers or false
    self.damagesenemies = mods.damagesenemies or true
    self.hitboxradius = mods.hitboxradius or 0.2
end

Ice_Bolt.sprite = love.graphics.newImage("sprite/projectile/ice_bolt.png")

function Ice_Bolt:damage_enemy(targ,state)
    targ:damage(state,self.dmg)
    if ((not targ.debuffs.slow) or targ.debuffs.slow <= 180) then
        targ.debuffs.slow = 180
    end
end


return Ice_Bolt
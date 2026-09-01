local Object = require("classic")

Projectile = Object:extend()

--[[ members of instances:
.alive -> flag for projectiles that are currently extant. others will be destroyed
.dmg -> damage dealt by this projectile when it hits
.velocityx -> selfexplanatory. generally will be decreasing to shoot at enemies.
.velocityy -> selfexplanatory. often 0
.y -> which row it is in
.x -> position (smaller number -> closer to where enemies spawn)
.damagestowers -> selfexp
.damagesenemies -> selfexp
.sprite -> image for this tower
.hitboxradius = chebyshev distance to check for collisions in

:new -> create new projectile
:destroy -> actions to perform when destroyed
:update -> update per frame.
:draw -> depict it
]]

function Projectile:new(state,x,y,velocityx,velocityy,mods)
    if mods == nil then mods = {} end
    -- common tower initialization
    self.sprite = mods.sprite or nil
    self.velocityx = velocityx
    self.velocityy = velocityy or 0
    self.y = y
    self.x = x
    self.dmg = mods.dmg or 2
    self.alive = true
    self.damagestowers = mods.damagestowers or false
    self.damagesenemies = mods.damagesenemies or true
    self.hitboxradius = 0.2
end

function Projectile:destroy(state)
    -- destroy by default does nothing because destruction is done within the table of projectiles. but this will be called before destroying projectiles
end

function Projectile:draw(state)
    -- render it. TK
    if self.sprite then
        
    else
    
    end
end

function Projectile:update(state)
    if self.alive then 
        -- check for collision
        
        -- otherwise move
        self.y = self.y + velocityy
        self.x = self.x + velocityx
    end
end

return Projectile
local Object = require("classic")

local Projectile = Object:extend()

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

local cam = require("camera")
function Projectile:draw(state)
    -- render it. TK
    if self.sprite then
        local scale = cam.ZOOM_SF_ENTITY(state.leveldata.camerazoom)
        local x,y = cam.get_canvas_position(state.leveldata.camerax, state.leveldata.cameray, state.leveldata.camerazoom, self.x, self.y)
        love.graphics.draw(self.sprite, x-1, y, 0, scale, scale)
    else
    
    end
end

function Projectile:culling(state) -- cull offscreen projectiles
    if (self.x < -1 or self.y < -1 or self.x > state.leveldata.length + 1 or self.y > state.leveldata.breadth + 1) then
        self.alive = false
    end
end

function Projectile:update(state)
    if self.alive then 
        -- check for collision
        if self.damagesenemies then
            for i = 1, #state.leveldata.ENEMY_ARRAY do
                local en = state.leveldata.ENEMY_ARRAY[i]
                if (math.abs(en.y - self.y) < self.hitboxradius and math.abs(en.x - self.x) < self.hitboxradius) then 
                    -- todo: further logic on whether this projectile can hit this enemy! but that's for when actual content exists.
                    self.alive = false
                    en:damage(state,self.dmg)
                    break
                end
            end
        end
        if self.alive and self.damagestowers then
            for i = 1, #state.leveldata.TOWER_ARRAY do
                local t = state.leveldata.TOWER_ARRAY[i]
                if (math.abs(t.y - self.y) < self.hitboxradius and math.abs(t.x - self.x) < self.hitboxradius) then 
                    -- todo: further logic on whether this projectile can hit this tower! but that's for when actual content exists.
                    self.alive = false
                    t:damage(state,self.dmg)
                    break
                end
            end
        end
        
        -- otherwise move
        self.x = self.x + self.velocityx
        self.y = self.y + self.velocityy
    end

    self:culling(state) -- cull based on usual conditions
end

return Projectile
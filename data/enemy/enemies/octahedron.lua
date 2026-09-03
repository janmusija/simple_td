local Enemy = require("data/enemy/enemy")

local Octahedron = Enemy:extend()

function Octahedron:new(state,y,mods)
    if mods == nil then mods = {} end
    Octahedron.super.new(self,state,y,mods) -- common enemy initialization
    self.sprite = mods.sprite or Octahedron.sprite
    self.hp = mods.hp or 18
    self.speed = mods.speed or 0.25
    self.reload = mods.reload or 180
    self.cooldown = 180
    self.modoverride = mods.modoverride
    self.projectile = mods.projectile or "foe_bolt"
end

Octahedron.compatible_tiles = {normal = true, air = true}

Octahedron.weight = 2
Octahedron.wavepoints = 3
Octahedron.sprite = love.graphics.newImage("sprite/enemy/octahedron.png")

local Projectile = require("data/projectile/projectile")
local p_c_t = require("data/projectile/projectile_class_table")

function Octahedron:update(state)
    Octahedron.super.update(self,state)
    if self.alive then
        -- fire projectile
        if (self.cooldown <= 0) then
            self.cooldown = 3*self.reload
            local p
            if (modoverride ~= nil) then
                p = p_c_t.get(self.projectile)(state,self.x,self.y,5/60,0,modoverride)
            else
                p = p_c_t.get(self.projectile)(state,self.x,self.y,5/60,0,p_c_t.mods(self.projectile))
            end
            table.insert(state.leveldata.PROJECTILE_ARRAY,p)
        else
            if (self.debuffs.slow) then
                self.cooldown = self.cooldown - 2
            else
                self.cooldown = self.cooldown - 3
            end
        end
    end
end

return Octahedron
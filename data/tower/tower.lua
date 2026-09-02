local Object = require("classic")

local array = require("array")

local Tower = Object:extend()

--[[ members of instances:
.alive -> flag for towers that are currently alive. dead towers no longer exist and will be destroyed.
.hp -> health
.y -> which row it is in
.x -> position (smaller number -> closer to where enemies spawn)
.speed -> tiles traveled per 60 frames.
.sprite -> image for this tower

members of class itself:
.manacost -> cost
.recharge -> time to recharge the tower (in 60-frame units)

:new -> create new tower
:destroy -> actions to perform when destroyed
:damage -> do damage to this tower
:update -> update per frame.
:draw -> depict it
]]

function Tower:new(state,x,y,mods)
    if mods == nil then mods = {} end
    -- common tower initialization
    self.sprite = mods.sprite or nil
    self.y = y
    self.x = x
    self.hp = 20
    self.alive = true
end

Tower.recharge = 5
Tower.manacost = 0


function Tower:damage(state,dmg)
    self.hp = self.hp - dmg
    if (self.hp <= 0) then self.alive = false end
end

function Tower:destroy(state)
    -- destroy by default does nothing because destruction is done within the table of towers. but this will be called before destroying towers
end


local cam = require("camera")
function Tower:draw(state)
    -- render it. TK
    if self.sprite then
        local scale = cam.ZOOM_SF_ENTITY(state.leveldata.camerazoom)
        local x,y = cam.get_canvas_position(state.leveldata.camerax, state.leveldata.cameray, state.leveldata.camerazoom, self.x, self.y)
        love.graphics.draw(self.sprite, x-1, y, 0, scale, scale)
    else
    
    end
end

function Tower:update(state)
    
end

function Tower:valid_forward_target(state)
    local out = false
    for i = 1, array.size(state.leveldata.ENEMY_ARRAY) do
        local en = array.get(state.leveldata.ENEMY_ARRAY,i)
        if (math.abs(en.y - self.y) < 0.5 and en.x < self.x - 0.5) then 
            out = true
            break
        end
    end
    return out
end

local Projectile = require("data/projectile/projectile")
local p_c_t = require("data/projectile/projectile_class_table")

function Tower:fire_projectile(state,projid,velocityx,velocityy,modoverride)
    local p
    if (modoverride ~= nil) then
        p = p_c_t.get(projid)(state,self.x,self.y,velocityx,velocityy,modoverride)
    else
        p = p_c_t.get(projid)(state,self.x,self.y,velocityx,velocityy,p_c_t.mods(projid))
    end
    array.append(state.leveldata.PROJECTILE_ARRAY,p)
end

return Tower
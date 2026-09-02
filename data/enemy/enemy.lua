local Object = require("classic")
local cam = require("camera")

local Enemy = Object:extend()
--[[ members of instances:
.alive -> flag for enemies that are currently alive. dead enemies no longer exist and will be destroyed.
.hp -> health
.y -> which row it is in
.x -> column position (larger number -> closer to leaking)
.speed -> tiles traveled per 60 frames.
.sprite -> image for this enemy
.attack_dmg -> attack damage
.attack_recharge -> rate at which attacks are


.block_stall_time -> if blocked, frames before un-blocking.
.next_attack_ticks -> time until next attack

:new -> create new enemy
:destroy -> actions to perform when destroyed (e.g. matryoshkas spawn further, smaller matryoshkas)
:damage -> deal damage to this enemy
:update -> update per frame.
:draw -> depict it
:moveforward -> move by speed/60 spaces (called by update, thus per frame)
]]

--[[ members of class itself:
.wavepoints -> how much of the wavepoint "budget" is occupied by this enemy, by default
.weight -> how likely it is to spawn, by default
]]

function Enemy:new(state,y,mods)
    -- common enemy initialization
    if mods == nil then mods = {} end
    self.sprite = mods.sprite or nil
    self.y = y or 1 
    self.x = -0.5
    self.speed = mods.speed or 0.3
    self.hp = mods.hp or 20
    self.alive = true
    self.block_stall_time = 10
    self.attack_dmg = mods.attack_dmg or 4
    self.attack_recharge = mods.attack_recharge or 30
    self.next_attack_ticks = 0
    if (y == -1) then self.alive = false end -- dummy
end

Enemy.wavepoints = 2
Enemy.weight = 1

function Enemy:damage(state,dmg)
    self.hp = self.hp - dmg
    if (self.hp <= 0) then self.alive = false end
end

function Enemy:destroy(state)
    -- destroy by default does nothing because destruction is done within the table of enemies. but this will be called before destroying enemies
end

function Enemy:draw(state)
    -- render it. TK
    if self.sprite then
        local scale = cam.ZOOM_SF_ENTITY(state.leveldata.camerazoom)
        local x,y = cam.get_canvas_position(state.leveldata.camerax, state.leveldata.cameray, state.leveldata.camerazoom, self.x, self.y)
        love.graphics.draw(self.sprite, x-1, y, 0, scale, scale)
    else
    
    end
end

function Enemy:moveforward()
    self.x = self.x + self.speed * (1/60) -- speed is x per 60 frames
end


function Enemy:update(state)
    if self.alive then
        if self.next_attack_ticks > 0 then self.next_attack_ticks = self.next_attack_ticks -1 end
        if self.block_stall_time <= 0 then
            self:moveforward()
        end
        -- if blocked: attack. TK
        local blocked = false
        for i = 1, #state.leveldata.TOWER_ARRAY do
            local t = state.leveldata.TOWER_ARRAY[i]
            local xdist = self.x - t.x
            local ydist = self.y - t.y
            if (xdist < 0.25 and xdist > -0.35 and math.abs(ydist) <0.5 ) then
                blocked = true
                self.block_stall_time = 10
                
                -- attack tower
                if (self.next_attack_ticks <= 0) then
                self.next_attack_ticks = self.attack_recharge
                t:damage(state,self.attack_dmg)
                end
                break
            end
        end
        if not blocked and self.block_stall_time > 0 then
            self.block_stall_time = self.block_stall_time -1
        end
    end
end

return Enemy
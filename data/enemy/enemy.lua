local Object = require("classic")

Enemy = Object:extend()
--[[ members:
.alive -> flag for enemies that are currently alive. dead enemies no longer exist and will be destroyed.
.hp -> health
.y -> which row it is in
.x -> column position (larger number -> closer to leaking)
.speed -> tiles traveled per 60 frames.
.sprite -> image for this enemy
.block_stall_time -> if blocked, frames before un-blocking.
.wavepoints -> how much of the wavepoint "budget" occupied by this enemy

:new -> create new enemy
:destroy -> actions to perform when destroyed (e.g. matryoshkas spawn further, smaller matryoshkas)
:damage -> deal damage to this enemy
:update -> update per frame.
:draw -> depict it
:moveforward -> move by speed/60 spaces (called by update, thus per frame)
]]

function Enemy:new(state,y)
    -- common enemy initialization
    self.sprite = nil
    self.y = y or 1 
    self.x = 0
    self.speed = 0.40
    self.hp = 20
    self.alive = true
    self.wavepoints = 2
end

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

    else
    
    end
end

function Enemy:moveforward()
    self.x = self.x + self.speed * (1/60) -- speed is x per 60 frames
end

function Enemy:update(state)
    if self.alive then
        if self.block_stall_time <= 0 then
            self:moveforward()
        end
        -- if blocked: attack. TK
    end
end

return Enemy
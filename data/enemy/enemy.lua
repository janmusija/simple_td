local Object = require("classic")

Enemy = Object:extend()
--[[ members of instances:
.alive -> flag for enemies that are currently alive. dead enemies no longer exist and will be destroyed.
.hp -> health
.y -> which row it is in
.x -> column position (larger number -> closer to leaking)
.speed -> tiles traveled per 60 frames.
.sprite -> image for this enemy

.block_stall_time -> if blocked, frames before un-blocking.

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
    self.x = 0
    self.speed = mods.speed or 0.40
    self.hp = mods.hp or 20
    self.alive = true
    self.block_stall_time = 0
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
    print("x: " .. self.x .. ", killed.")
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
    print("x: " .. self.x) -- test to demonstrate this is happening now
    if self.alive then
        if self.block_stall_time <= 0 then
            self:moveforward()
        end
        -- if blocked: attack. TK
    end
    if (self.x >10) then
        self.alive = false
    end
end

return Enemy
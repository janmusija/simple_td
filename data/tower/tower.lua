local Object = require("classic")

Tower = Object:extend()
--[[ members:
.alive -> flag for towers that are currently alive. dead towers no longer exist and will be destroyed.
.hp -> health
.y -> which row it is in
.x -> position (smaller number -> closer to where enemies spawn)
.speed -> tiles traveled per 60 frames.
.sprite = image for this enemy

:new -> create new tower
:destroy -> actions to perform when destroyed
:damage -> do damage to this tower
:update -> update per frame.
:draw -> depict it
]]

function Tower:new(state,x,y)
    -- common tower initialization
    self.sprite = nil
    self.y = y
    self.x = x
    self.hp = 20
    self.alive = true
end


function Tower:damage(state,dmg)
    self.hp = self.hp - dmg
    if (self.hp <= 0) then self.alive = false end
end

function Tower:destroy(state)
    -- destroy by default does nothing because destruction is done within the table of enemies. but this will be called before destroying enemies
end

function Tower:draw(state)
    -- render it. TK
    if self.sprite then

    else
    
    end
end

function Tower:update(state)
    
end

return Tower
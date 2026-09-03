local Tower = require("data/tower/tower")


-- THE aquatic platform.
local Raft = Tower:extend()

function Raft:new(state,x,y,mods)
    if mods == nil then mods = {} end
    Raft.super.new(self,state,x,y,mods) -- common tower initialization
    self.sprite = mods.sprite or Raft.sprite 
    self.platform = true
end

Raft.sprite = love.graphics.newImage("sprite/tower/raft.png")
Raft.manacost = 10
Raft.recharge = 3*60
Raft.compatible_tiles = {water = true}

return Raft
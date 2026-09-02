local Projectile = require("data/projectile/projectile")

local Mana_Packet = Projectile:extend()

function Mana_Packet:new(state,x,y,velocityx,velocityy,mods)
    if mods == nil then mods = {} end
    Mana_Packet.super.new(self,state,x,y,velocityx,velocityy,mods) -- common projectile initialization
    self.sprite = mods.sprite or love.graphics.newImage("sprite/projectile/mana_packet.png")
    self.dmg = mods.dmg or 0
    self.damagestowers = mods.damages_towers or false
    self.damagesenemies = mods.damagesenemies or false
    self.hitboxradius = 0.2
    self.mv = mods.mv or 10
    self.lifetime = 60*10 -- lifetime in ticks
end

function Mana_Packet:update(state)
    Mana_Packet.super.update(self,state)
    if (self.lifetime <= 0) then
        self.alive = false
    end
    if (math.abs(self.x - state.leveldata.board_cursor_x+0.5) <= 1) and (math.abs(self.y - state.leveldata.board_cursor_y+0.5) <= 1) and self.alive then
        self.alive = false
        state.leveldata.mana = state.leveldata.mana + self.mv
    end
    self.velocityx = self.velocityx/2
    self.velocityy = self.velocityy/2
    self.lifetime = self.lifetime -1
end


return Mana_Packet
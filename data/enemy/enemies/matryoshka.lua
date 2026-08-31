local Enemy = require("data/enemy/enemy")

local Matryoshka = Enemy:extend()

function Matryoshka:new(state,y,mods)
    if mods == nil then mods = {} end
    Matryoshka.super.new(self,state,y) -- common enemy initialization
    self.sprite = mods.sprite or love.graphics.newImage("sprite/enemy/matryoshka.png")
    self.size = mods.size or 2
    self.speed = mods.speed or 0.1 + (0.3/math.max((self.size+2/3),1))
    self.hp = mods.hp or self.size * 10
    self.stunframes = 0
end

Matryoshka.wavepoints = 4
Matryoshka.weight = 1

function Matryoshka:destroy(state)
    -- [create a new matryoshka]
    if self.size > 1 then
    local m = Matryoshka(self.y,self.size-1)
    m.stunframes = 10
    m.x = self.x
    -- TK: put it into enemyarray
    end
end

function Matryoshka:moveforward()
    if stunframes > 0 then
        stunframes = stunframes - 1
    else
        Matryoshka.super.moveforward(self)
    end
end

return Matryoshka
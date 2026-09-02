local Enemy = require("data/enemy/enemy")
local array = require("array")

local Matryoshka = Enemy:extend()

function Matryoshka:new(state,y,mods)
    if mods == nil then mods = {} end
    Matryoshka.super.new(self,state,y,mods) -- common enemy initialization
    self.sprite = mods.sprite or love.graphics.newImage("sprite/enemy/matryoshka.png")
    self.size = mods.size or 2
    self.speed = mods.speed or 0.1 + (0.2/math.max((self.size+2/3),1))
    self.hp = mods.hp or self.size * 10
    self.stunframes = 0
end

Matryoshka.wavepoints = 4
Matryoshka.weight = 1

function Matryoshka:destroy(state)
    -- [create a new matryoshka]
    if self.size > 1 then
    local m = Matryoshka(state,self.y)
    m.stunframes = 60
    m.x = self.x
    m.size = self.size - 1
    array.append(state.leveldata.ENEMY_ARRAY,m)
    end
end

function Matryoshka:moveforward()
    if stunframes == nil then stunframes = 0 end
    if stunframes > 0 then
        stunframes = stunframes - 1
    else
        Matryoshka.super.moveforward(self)
    end
end

return Matryoshka
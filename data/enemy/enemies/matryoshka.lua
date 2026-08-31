local Enemy = require("data/enemy/enemy")

function Matryoshka:new(state,y,size)
    Matryoshka.super.new(self,state,y) -- common enemy initialization
    self.sprite = love.graphics.newImage("sprite/enemy/matryoshka.png")
    self.size = size or 2
    self.speed = 0.1 + (0.3/math.max((size+2/3),1))
    self.hp = self.size * 10
    self.alive = true
    self.stunframes = 0
end

function Matryoshka:destroy(state)
    -- [create a new matryoshka]
    if size > 1 then
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
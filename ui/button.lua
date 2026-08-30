-- ui/button.lua
local Object = require("classic")

local Button = Object:extend()

function Button:new(x,y,width,height,text,fun,color,downcolor) -- x-coordinate, y-coordinate, width, height, function to enact
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.fun = fun or function() end
    self.text = text
    self.color = color or {1,1,1}
    self.downcolor = downcolor or {self.color[1]-0.15,self.color[2]-0.15,self.color[3]-0.15}
    self.textcolor = {0,0,0}
    self.down = false
end

function Button:update()
    local mousex, mousey = love.mouse.getX(), love.mouse.getY()
    if (mousex <= self.x + self.width and mousex >= self.x and mousey <= self.y + self.height and mousey >= self.y and love.mouse.isDown(1)) then
        if not self.down then    
            self.fun()
            self.down = true
        end
    else
        self.down = false
    end
end

function Button:draw()
    local col = self.color
    if self.down then col = self.downcolor end
    love.graphics.setColor(col)
    love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)
    love.graphics.setColor(self.textcolor)
    love.graphics.print(self.text, self.x+3, self.y+3)
end

return Button
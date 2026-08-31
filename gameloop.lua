local w, h = love.graphics.getDimensions()

function updatepause(dt, state)

end

function drawpause(dt, state)
    love.graphics.print("omg! gaming")

    -- probably this basically entails running drawgaming but with this over it

    love.graphics.setColor(0,0,0,0.2)
    love.graphics.rectangle("fill",0,0,w,h)
end

function updategaming(dt, state)

end

function drawgaming(dt, state)
    love.graphics.print("omg! gaming")
end
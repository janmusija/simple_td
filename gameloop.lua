local w, h = love.graphics.getDimensions()

function updatepause(state)

end

function drawpause(state)
    love.graphics.print("omg! pausing")

    -- probably this basically entails running drawgaming but with this over it

    love.graphics.setColor(0,0,0,0.2)
    love.graphics.rectangle("fill",0,0,w,h)
    love.graphics.setColor(1,1,1)
end

function updategaming(state)

end

function drawgaming(state)
    love.graphics.setColor(1,1,1)
    if (state.leveldata.phase == "select") then love.graphics.print("omg! selecting")
    elseif (state.leveldata.phase == "play") then love.graphics.print("omg! playing")
    end
end
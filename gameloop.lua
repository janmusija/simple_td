local font36 = love.graphics.newFont(36)
local font18 = love.graphics.newFont(18)
local w, h = love.graphics.getDimensions()

local menunames = require("data/menu/menunames")

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
    if (state.leveldata.phase == "select") then
        -- display level name
        local str = "Level " .. state.level
        if menunames[state.level] then str = menunames[state.level] .. " (" .. str .. ")" end
        love.graphics.setFont(font36)
        love.graphics.print(str,6,18)
        love.graphics.setFont(font18)
        -- display enemies in level
        local i = 0
        for k,v in pairs (state.leveldata.enemies) do
            local str = k .. " (Weight: " .. state.leveldata.enemy_weights[k] .. ", Wavepoints: " ..  state.leveldata.enemy_wavepoints[k] .. ")"
            love.graphics.print(str,6,72+i*36)
            i = i+1
        end
        -- display selection etc
    elseif (state.leveldata.phase == "play") then love.graphics.print("omg! playing")
    end
end
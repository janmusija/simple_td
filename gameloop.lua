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


local function get_enemy(state,budget)
    local totalweight = 0
    local thresholds = {}
    local i = 1
    for k,v in pairs(state.leveldata.enemy_weights) do
        if state.leveldata.enemy_wavepoints[k] <= budget then
            totalweight = totalweight + v
            thresholds[i] = {w = totalweight, e = k}
            i = i+1
        end
    end
    local random_int = 0 -- 0<= random_int < totalweight -- TK
    local out = ""
    for j,v in ipairs(thresholds) do
        if random_int < v.w then
            out = v.e
        end
        break
    end
    return out
end

function updategaming(state)
    if (state.leveldata.phase == "play") then
        -- tick timer, check if next wave should spawn
        state.leveldata.timer = state.leveldata.timer + 1
        state.leveldata.wavetimer = state.leveldata.wavetimer + 1

        
        --print(state.leveldata.timer, state.leveldata.wavetimer, state.leveldata.budget, state.leveldata.__minwp)

        if (state.leveldata.wave < state.leveldata.waves and state.leveldata.wavetimer >= 2*60 and
            (state.leveldata.wavetimer >= 20*60 or false)) then
            -- the longest a wave is allowed to go before spawning the next is 20 seconds, and the least it can go is 2 seconds. additional conditions for spawning a wave early TBA
            state.leveldata.wavetimer = 0
            state.leveldata.wave = state.leveldata.wave + 1
            if (type(state.leveldata.wavepoint_scaling) == "number") then
                state.leveldata.budget = state.leveldata.budget + state.leveldata.initial_wavepoints + state.leveldata.wavepoint_scaling * (state.leveldata.wave -1)
            elseif (type(state.leveldata.wavepoint_scaling) == "function") then
                state.leveldata.budget = state.leveldata.budget + state.leveldata.wavepoint_scaling(state.leveldata.wave)
            end
        end

        -- destroy enemies and towers that are no longer alive

        -- tick selected towers slots

        -- tick towers
        
        -- tick projectiles

        -- tick enemies

        -- tick enemy projectiles

        -- spawn enemies
        if (state.leveldata.budget >= state.leveldata.__minwp) then
            -- select enemy
            local enid = get_enemy(state,state.leveldata.budget)

            -- attempt to spawn it
            print(enid) -- TEMP
            state.leveldata.budget = state.leveldata.budget - state.leveldata.enemy_wavepoints[enid]
        end

        -- check if level is over (no enemies remain, budget is zero, and we have reached the final wave)
    end
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
local font36 = love.graphics.newFont(36)
local font18 = love.graphics.newFont(18)
local w, h = love.graphics.getDimensions()

local menunames = require("data/menu/menunames")

function updatepause(state)

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
    local random_int = math.random(0,totalweight-1)
    local out = "FAILURE"
    for j,v in ipairs(thresholds) do
        if random_int < v.w then
            out = v.e
            break
        end
    end
    return out
end

local array = require("array")
local e_c_t = require("data/enemy/enemy_class_table")
local t_c_t = require("data/tower/tower_class_table")
local p_c_t = require("data/projectile/projectile_class_table")
local cam = require("camera")

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

        -- destroy enemies, projectiles, and towers that are no longer alive
        do
            local i = 1
            while i <= array.size(state.leveldata.ENEMY_ARRAY) do
                local en = array.get(state.leveldata.ENEMY_ARRAY,i)
                if en.alive == false then
                    en:destroy(state)
                    array.delete(state.leveldata.ENEMY_ARRAY,i)
                else
                    i = i+1
                end
            end
            i = 1
            while i <= array.size(state.leveldata.PROJECTILE_ARRAY) do
                local en = array.get(state.leveldata.PROJECTILE_ARRAY,i)
                if en.alive == false then
                    en:destroy(state)
                    array.delete(state.leveldata.PROEJCTILE_ARRAY,i)
                else
                    i = i+1
                end
            end
            i = 1
            while i <= array.size(state.leveldata.TOWER_ARRAY) do
                local en = array.get(state.leveldata.TOWER_ARRAY,i)
                if en.alive == false then
                    en:destroy(state)
                    array.delete(state.leveldata.TOWER_ARRAY,i)
                else
                    i = i+1
                end
            end
        end

        -- tick selected towers slots

        -- tick towers
        
        -- tick projectiles

        -- tick enemies
        for i = 1, array.size(state.leveldata.ENEMY_ARRAY) do
            local en = array.get(state.leveldata.ENEMY_ARRAY,i)
            en:update(state)
        end

        -- tick enemy projectiles

        -- spawn enemies
        if (state.leveldata.budget >= state.leveldata.__minwp) then
            -- select enemy
            local enid = get_enemy(state,state.leveldata.budget)
            -- attempt to spawn it
            if (enid ~= "FAILURE") then
                -- more detailed lane selection that can blacklist certain lanes for certain enemies TBA
                local lane = -1
                lane = math.random(1,state.leveldata.breadth)
                local a = e_c_t.get(enid)(state,lane,e_c_t.mods(enid))
                
                array.append(state.leveldata.ENEMY_ARRAY,a)

                state.leveldata.budget = state.leveldata.budget - state.leveldata.enemy_wavepoints[enid]
            else 
                print("Error: failed to spawn!")
            end
        end

        -- check if level is over
        -- loss = enemy past all defenses
        for i = 1, array.size(state.leveldata.ENEMY_ARRAY) do
            local en = array.get(state.leveldata.ENEMY_ARRAY,i)
            if (en.alive and en.x > state.leveldata.length + 1) then 
                state.leveldata.phase = "loss"
                en.alive = false
            end
        end
        -- victory = (no enemies remain, budget is zero, and we have reached the final wave)
        if (array.size(state.leveldata.ENEMY_ARRAY) == 0 and state.leveldata.budget < state.leveldata.__minwp and state.leveldata.wave >= state.leveldata.waves) then
            state.leveldata.phase = "win"
            state.playerdata.completed_levels[state.level] = true
        end
    end
end

function drawgaming(state)
    love.graphics.setColor(1,1,1)
    local cx = state.leveldata.camerax
    local cy = state.leveldata.cameray
    local cz = state.leveldata.camerazoom
    local ZOOMED_SCALE_FACTOR = cam.ZOOMED_SCALE_FACTOR(cz)
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
    elseif (state.leveldata.phase == "play" or state.leveldata.phase == "win" or state.leveldata.phase == "loss") then
        --love.graphics.print("omg! playing")

        -- display background, tiles
        for j = 1, state.leveldata.breadth do
            for i = 1, state.leveldata.length do
                if (math.fmod(i+j,2) == 1) then love.graphics.setColor(0.8,0.8,0.8) else love.graphics.setColor(0.6,0.6,0.6) end
                love.graphics.rectangle("fill",(-cx + i - 1)*ZOOMED_SCALE_FACTOR, (-cy + j - 1) * ZOOMED_SCALE_FACTOR,ZOOMED_SCALE_FACTOR,ZOOMED_SCALE_FACTOR)
            end
        end
        love.graphics.setColor(1,1,1)

        -- display projectiles
        for i = 1, array.size(state.leveldata.PROJECTILE_ARRAY) do
            local proj = array.get(state.leveldata.PROJECTILE_ARRAY,i)
            proj:draw(state)
        end

        -- display towers
        for i = 1, array.size(state.leveldata.TOWER_ARRAY) do
            local t = array.get(state.leveldata.TOWER_ARRAY,i)
            t:draw(state)
        end
        
        -- display enemies
        for i = 1, array.size(state.leveldata.ENEMY_ARRAY) do
            local en = array.get(state.leveldata.ENEMY_ARRAY,i)
            en:draw(state)
        end

        -- display slots/ui

        -- winloss overlay
        if (state.leveldata.phase == "win") then

        love.graphics.setColor(0,0,0,0.2)
        love.graphics.rectangle("fill",0,0,w,h)
        love.graphics.setColor(1,1,1)

        elseif (state.leveldata.phase == "loss") then

        love.graphics.setColor(0.5,0,0,0.3)
        love.graphics.rectangle("fill",0,0,w,h)
        love.graphics.setColor(1,1,1)

        end
    end
end

function drawpause(state)
    drawgaming(state)

    love.graphics.setColor(0,0,0,0.2)
    love.graphics.rectangle("fill",0,0,w,h)
    love.graphics.setColor(1,1,1)
end
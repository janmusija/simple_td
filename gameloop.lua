local font36 = love.graphics.newFont(36)
local font18 = love.graphics.newFont(18)
local w, h = love.graphics.getDimensions()
local td_constants = require("data/td_constants")

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
local locked = require("data/menu/locked")

function updategaming(state)
    if (state.leveldata.spawn_cooldown == nil) then
        state.leveldata.spawn_cooldown = 0
    end
    if (state.leveldata.phase == "select") then
        if ((state.leveldata.camera_locked == true) and state.leveldata.camerax > -5) then
            state.leveldata.camerax = state.leveldata.camerax - state.leveldata.camera_pan_velocity
            state.leveldata.camera_pan_velocity = state.leveldata.camera_pan_velocity + 1/512
        end
        if (state.leveldata.camera_locked == true and state.leveldata.camerax <= -5) then
            state.leveldata.camera_locked = false
            state.leveldata.camerax = -5
            state.leveldata.camera_pan_velocity = nil
        end
    end

    if (state.leveldata.camera_pan_velocity == nil and state.leveldata.show_selection == true) then -- show selection

    end

    if (state.leveldata.phase == "play") then
        -- tick timer, check if next wave should spawn
        state.leveldata.timer = state.leveldata.timer + 1
        state.leveldata.wavetimer = state.leveldata.wavetimer + 1
        if (state.leveldata.spawn_cooldown > 0) then state.leveldata.spawn_cooldown = state.leveldata.spawn_cooldown - 1 end
        if (state.leveldata.passive_mana == true) then
            if (state.leveldata.time_till_next_passive_mana > 0) then state.leveldata.time_till_next_passive_mana = state.leveldata.time_till_next_passive_mana - 1 else
                state.leveldata.time_till_next_passive_mana = state.leveldata.ticks_per_passive_mana
                state.leveldata.mana = state.leveldata.mana + 1
            end
        end

        
        --print(state.leveldata.wave, state.leveldata.timer, state.leveldata.wavetimer, state.leveldata.budget, state.leveldata.__minwp)

        if (state.leveldata.wave < state.leveldata.waves and state.leveldata.budget < state.leveldata.__minwp and state.leveldata.wavetimer >= 2*60 and ( -- The least time between two waves is 2 seconds.
            (state.leveldata.wave > 0 and state.leveldata.wavetimer >= 20*60) or -- the longest a wave is allowed to go before spawning the next is 20 seconds.
            (state.leveldata.wave > 0 and array.size(state.leveldata.ENEMY_ARRAY) == 0) or -- if all enemies in a wave are destroyed, the next wave can spawn.
            (state.leveldata.wave == 0 and state.leveldata.wavetimer >= state.leveldata.initial_wait) or -- initial wait
            false)) then --  additional conditions for spawning a wave early TBA
            
            state.leveldata.wavetimer = 0
            state.leveldata.wave = state.leveldata.wave + 1
            if (type(state.leveldata.wavepoint_scaling) == "number") then
                state.leveldata.budget = state.leveldata.initial_wavepoints + state.leveldata.wavepoint_scaling * math.min(0,state.leveldata.wave -2)
            elseif (type(state.leveldata.wavepoint_scaling) == "function") then
                state.leveldata.budget = state.leveldata.wavepoint_scaling(state.leveldata.wave)
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
                    array.delete(state.leveldata.PROJECTILE_ARRAY,i)
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
        if state.leveldata.CHOSEN_TOWER_COOLDOWNS == nil then
            state.leveldata.CHOSEN_TOWER_COOLDOWNS = {}
        end
        for i = 1, array.size(state.leveldata.CHOSEN_TOWERS) do
            local t = array.get(state.leveldata.CHOSEN_TOWERS,i)
            -- todo
            if state.leveldata.CHOSEN_TOWER_COOLDOWNS[i] == nil then
                state.leveldata.CHOSEN_TOWER_COOLDOWNS[i] = 0
            elseif  state.leveldata.CHOSEN_TOWER_COOLDOWNS[i] > 0 then
                state.leveldata.CHOSEN_TOWER_COOLDOWNS[i] = state.leveldata.CHOSEN_TOWER_COOLDOWNS[i] - 1
            end
        end

        -- tick towers
        for i = 1, array.size(state.leveldata.TOWER_ARRAY) do
            local t = array.get(state.leveldata.TOWER_ARRAY,i)
            t:update(state)
        end
        
        -- tick projectiles
        for i = 1, array.size(state.leveldata.PROJECTILE_ARRAY) do
            local proj = array.get(state.leveldata.PROJECTILE_ARRAY,i)
            proj:update(state)
        end

        -- tick enemies
        for i = 1, array.size(state.leveldata.ENEMY_ARRAY) do
            local en = array.get(state.leveldata.ENEMY_ARRAY,i)
            en:update(state)
        end

        -- spawn enemies
        if (state.leveldata.budget >= state.leveldata.__minwp and state.leveldata.spawn_cooldown <= 0) then
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

                state.leveldata.spawn_cooldown = math.random(10,30)
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
    -- display background, tiles
    for j = 1, state.leveldata.breadth do
        for i = 1, state.leveldata.length do
            if (math.fmod(i+j,2) == 1) then love.graphics.setColor(0.8,0.8,0.8) else love.graphics.setColor(0.6,0.6,0.6) end
            love.graphics.rectangle("fill",(-cx + i - 1)*ZOOMED_SCALE_FACTOR, (-cy + j - 1) * ZOOMED_SCALE_FACTOR,ZOOMED_SCALE_FACTOR,ZOOMED_SCALE_FACTOR)
        end
    end
    love.graphics.setColor(1,1,1)
    
    local selection_x = 4*w/11
    local selection_y = 3*h/14
    local slotwidth = (w - selection_x) / (td_constants.SELECTION_BOX_WIDTH)
    
    if (state.leveldata.phase == "select") then
        -- display selection etc
        if (state.leveldata.camera_pan_velocity == nil and state.leveldata.show_selection == true) then
            love.graphics.setColor(0.2,0,0.2)
            love.graphics.rectangle("fill",0,0,w,slotwidth) -- selected towers bar
            love.graphics.setColor(0.2,0,0.2,0.5)
            
            love.graphics.rectangle("fill",selection_x,selection_y,w,h)
            love.graphics.setColor(1,1,1)
            for i,v in ipairs(t_c_t.number_table) do
                if (locked.unlocked("tower_" .. v) or (type(state.leveldata.forceunlocks) == "table" and state.leveldata.forceunlocks[v] == true)) then -- only displpay unlocked towers.
                    local x = math.fmod((i-1),td_constants.SELECTION_BOX_WIDTH)
                    local y = math.floor((i-1)/td_constants.SELECTION_BOX_WIDTH)
                    love.graphics.draw(t_c_t.slot_sprite(v),selection_x+x*slotwidth,selection_y+y*slotwidth,0,slotwidth/128,slotwidth/128)
                end
            end

            for i = 1, array.size(state.leveldata.CHOSEN_TOWERS) do
                local str = array.get(state.leveldata.CHOSEN_TOWERS,i)
                local x = math.fmod((i-1),td_constants.SELECTION_BOX_WIDTH)
                love.graphics.draw(t_c_t.slot_sprite(str),x*slotwidth,0,0,slotwidth/128,slotwidth/128)
            end
        end
        -- display enemies in level
        local i = 0
        love.graphics.setFont(font18)
        love.graphics.setColor(1,1,1)
        for k,v in pairs (state.leveldata.enemies) do
            local str = k .. " (Weight: " .. state.leveldata.enemy_weights[k] .. ", Wavepoints: " ..  state.leveldata.enemy_wavepoints[k] .. ")"
            if (state.leveldata.show_selection == true) then
                love.graphics.print(str,6,slotwidth + 60+i*36)
            else
                love.graphics.print(str,6,72+i*36)
            end
            i = i+1
        end

        -- cursors
        if (state.leveldata.show_selection == true and state.leveldata.camera_pan_velocity == nil) then
        if state.leveldata.slotstoggle then love.graphics.setColor(0.4,0.25,0) else love.graphics.setColor(0.8,0.5,0) end
        love.graphics.rectangle("line",selection_x + (state.leveldata.selection_cursor_x - 1)* slotwidth,selection_y + (state.leveldata.selection_cursor_y - 1)* slotwidth,slotwidth,slotwidth)
        if state.leveldata.slotstoggle then love.graphics.setColor(0.8,0.5,0) else love.graphics.setColor(0.4,0.25,0) end
        love.graphics.rectangle("line",(state.leveldata.slots_cursor_x - 1)* slotwidth,0,slotwidth,slotwidth)
        end

        -- display level name
        local str = "Level " .. state.level
        if menunames[state.level] then str = menunames[state.level] .. " (" .. str .. ")" end
        love.graphics.setFont(font36)
        love.graphics.setColor(1,1,1)
        if (state.leveldata.show_selection == true) then
            love.graphics.print(str,6,slotwidth + 6)
        else
            love.graphics.print(str,6,18)
        end
    elseif (state.leveldata.phase == "play" or state.leveldata.phase == "win" or state.leveldata.phase == "loss") then
        --love.graphics.print("omg! playing")

        -- display projectiles
        for i = 1, array.size(state.leveldata.PROJECTILE_ARRAY) do
            local proj = array.get(state.leveldata.PROJECTILE_ARRAY,i)
            if proj.alive then
                proj:draw(state)
            end
        end

        -- display towers
        for i = 1, array.size(state.leveldata.TOWER_ARRAY) do
            local t = array.get(state.leveldata.TOWER_ARRAY,i)
            if t.alive then
                t:draw(state)
            end
        end
        
        -- display enemies
        for i = 1, array.size(state.leveldata.ENEMY_ARRAY) do
            local en = array.get(state.leveldata.ENEMY_ARRAY,i)
            if en.alive then
                en:draw(state)
            end
        end

        -- display slots/ui
        love.graphics.setColor(0.2,0,0.2)
        love.graphics.rectangle("fill",0,0,w,slotwidth) -- selected towers bar

        for i = 1, array.size(state.leveldata.CHOSEN_TOWERS) do
            love.graphics.setColor(1,1,1)
            local str = array.get(state.leveldata.CHOSEN_TOWERS,i)
            local x = math.fmod((i-1),td_constants.SELECTION_BOX_WIDTH)
            love.graphics.draw(t_c_t.slot_sprite(str),x*slotwidth,0,0,slotwidth/128,slotwidth/128)
            love.graphics.setColor(0,0,0,0.2)
            if (state.leveldata.CHOSEN_TOWER_COOLDOWNS and state.leveldata.CHOSEN_TOWER_COOLDOWNS[i] and state.leveldata.CHOSEN_TOWER_COOLDOWNS[i] > 0 and t_c_t.recharge(str) > 0) then
                love.graphics.rectangle("fill",x*slotwidth,0,slotwidth,(slotwidth)*(state.leveldata.CHOSEN_TOWER_COOLDOWNS[i]/t_c_t.recharge(str)))
            end
        end
        -- cursors
        if state.leveldata.slotstoggle then love.graphics.setColor(0.4,0.25,0) else love.graphics.setColor(0.8,0.5,0) end
        love.graphics.rectangle("line",(-cx + state.leveldata.board_cursor_x - 1)*ZOOMED_SCALE_FACTOR, (-cy + state.leveldata.board_cursor_y - 1) * ZOOMED_SCALE_FACTOR,ZOOMED_SCALE_FACTOR,ZOOMED_SCALE_FACTOR)
        if state.leveldata.slotstoggle then love.graphics.setColor(0.8,0.5,0) else love.graphics.setColor(0.4,0.25,0) end
        love.graphics.rectangle("line",(state.leveldata.slots_cursor_x - 1)* slotwidth,0,slotwidth,slotwidth)
        
        love.graphics.setColor(1,1,1)
        love.graphics.setFont(font18)
        love.graphics.print("Mana: " .. state.leveldata.mana, 2*w/3,6) -- placeholder


        -- winloss overlay
        if (state.leveldata.phase == "win") then

        love.graphics.setColor(0,0,0,0.2)
        love.graphics.rectangle("fill",0,0,w,h)
        love.graphics.setColor(0,0.8,0)

        love.graphics.setFont(font36)
        love.graphics.print("You Won!!",w/2,h/2)
        love.graphics.setFont(font18)
        love.graphics.print("press the select key to continue",w/2,(h/2) + 48)

        elseif (state.leveldata.phase == "loss") then

        love.graphics.setColor(0.5,0,0,0.3)
        love.graphics.rectangle("fill",0,0,w,h)
        love.graphics.setColor(1,0,0)

        love.graphics.setFont(font36)
        love.graphics.print("YOU LOSE",w/2,h/2)
        love.graphics.setFont(font18)
        love.graphics.print("press the select key to continue",w/2,(h/2) + 48)

        end
    end
end

function drawpause(state)
    drawgaming(state)

    love.graphics.setColor(0,0,0,0.2)
    love.graphics.rectangle("fill",0,0,w,h)
    love.graphics.setColor(1,1,1)

    if state.leveldata.want_to_quit ~= nil then
        love.graphics.setFont(font36)
        love.graphics.print("Really Quit?",w/2,h/2)
        love.graphics.setFont(font18)
        love.graphics.print("press select key for yes, otherwise any other key",w/2,h/2 + 40)
    else
        love.graphics.setFont(font18)
        love.graphics.print("[press pause key to unpause]",w/2,h/2)
    end
end
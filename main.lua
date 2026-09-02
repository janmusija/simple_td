-- main.lua
local settings = require("settings")
local gameloop = require("gameloop")
local menu = require("menu")
local Object = require("classic") -- https://github.com/rxi/classic/blob/master/classic.lua
local Button = require("ui/button")
local sl = require("save_load")
local array = require("array")

local td_constants = require("data/td_constants")

local load_level = require("data/load_level_from_disk")

local locked = require("data/menu/locked")

local w, h = love.graphics.getDimensions()
local font = love.graphics.getFont()



local function iskey(k, x)
    local the = settings.keybinds[x]
    if k == the then return true end
    if type(the) == "table" then
        for i, v in ipairs(the) do
            if k == v then return true end
        end
    end
end

local function isheld(x)
    local the = settings.keybinds[x]
    if the == "" then return true end
    if type(the) == "string" and love.keyboard.isDown(the) then
        return true
    end
    if type(the) == "table" then
        for i, v in ipairs(the) do
            if love.keyboard.isDown(v) then return true end
        end
    end
end
local state = {
    profile = td_constants.DEFAULT_FILE_NAME,
    [""] = "menu", -- (can be "menu" in menus, "pause" when paused, or "gaming" when playing the game)
    menu = "main", -- the screen of the menu
    cursor = 1, -- cursor position in menu (navigated  with arrow keys)
    menuentryflag = true, -- turned on when entering a menu. then turned off once relevant code is executed
    level = 0, -- what level is being played. 0 when not in use
    leveldata = { -- data about current level
        --[[
        phase -> "select" to select towers. can also be "play" to be play, "win" when won, and "loss" when lost.
        wave -> current wave
        wavetimer -> time (frames) in this wave
        timer -> current time (frames) in this level
        budget -> remaining budget for this wave
        exitmenu -> menu to exit to upon level completion

        selected_slot -> id of currently selected tower slot

        ENEMY_ARRAY -> collection of currently extant enemies
        CHOSEN_TOWERS -> collection of towers. specifically, {sprite = [sprite of tower], id = [tower id], cooldown = [time in ticks until next use], recharge = [max cooldown duration], cost = [mama cost]}
        TOWER_ARRAY -> collection of currently extant towers
        PROJECTILE_ARRAY -> collection of currently extant projectiles
        mana = current player mana

        enemies -> set of enemies that appear in this level
        enemy_weights (optional, defaults per-enemy) -> weights of enemies-- how likely they are to spawn when the budget allows them. 
        enemy_wavepoints (optional, defaults per-enemy) -> wavepoints of enemies -- how much of the budget the enemy takes
        initial_mana -> initial mana budget
        initial_wait -> time in ticks before first wave spawns
        initial_wavepoints -> wavepoints in beginning of level
        wavepoint_scaling -> either a numeric value (constant number of wavepoints added per wave) or a function which maps wave number to wavepoints in that wave (in which case "initial_wavepoints" is ignored)
        waves -> number of waves
        length -> length of board (default 9)
        breadth -> breadth of board (default 5)
        map -> layout of board (more details later). default to just regular tiles


        camera_locked -> ability to pan camera
        camerax -> position of top left corner of screen
        cameray -> position of top left corner of screen
        camerazoom -> scaling factor. 1.0 = default; larger = more zoomed

        __minwp -> smallest wavepoints among any enemy in this level

        --]]
    },
    playerdata = { -- data about the player.
    --[[
    yen -> money
    completed_levels -> self explanatory
    seed -> seed of this run
    max_slots -> most selectable slots
    ]]
        yen = 0,
        completed_levels = {},
        max_slots = td_constants.INITIAL_MAX_SLOTS
    }
}

local test = 0

function love.load() -- when game opens
    love.window.setTitle( "Tower defense (but only for people who like having exactly one tower whose projectiles ignore everything)" )
    math.randomseed(os.time())
    local seed = math.random(0,16777215)
    state.playerdata.seed = seed
    if io.open("save/" .. td_constants.DEFAULT_FILE_NAME .. ".json", "r") then sl.load_player_data(td_constants.DEFAULT_FILE_NAME,state) end
    locked.updateLocks(state)
end

local accumulator = 0.0
local MAX_FPS = 60
local spf = 1/MAX_FPS


local function updatecamera(state)
    if isheld("panup") and state.leveldata.camera_locked == false then
        state.leveldata.cameray = state.leveldata.cameray - settings.pan_sensitivity
        if (state.leveldata.phase == "play") then
            state.leveldata.cameray = math.max(state.leveldata.cameray,-2.0/state.leveldata.camerazoom)
        end
    end
    if isheld("pandown") and state.leveldata.camera_locked == false then
        state.leveldata.cameray = state.leveldata.cameray + settings.pan_sensitivity
    end
    if isheld("panleft") and state.leveldata.camera_locked == false then
        state.leveldata.camerax = state.leveldata.camerax - settings.pan_sensitivity
        if (state.leveldata.phase == "play") then
            state.leveldata.camerax = math.max(state.leveldata.camerax,-2.0/state.leveldata.camerazoom)
        end
    end
    if isheld("panright") and state.leveldata.camera_locked == false then
        state.leveldata.camerax = state.leveldata.camerax + settings.pan_sensitivity
    end
end

function love.update(dt)
    accumulator = accumulator + dt
    if accumulator >= spf then 
        local s = state[""]
        if s == "menu" then
            updatemenu(state)
        elseif s == "pause" then
            updatepause(state)
        elseif s == "gaming" then
            updategaming(state)
        else 
        -- damage control
        end
        accumulator = accumulator - spf
    end
end

function love.draw()
    local s = state[""]
    --[[love.graphics.setColor(1,0.8,0)
    love.graphics.print(test,w/4,3*h/4)]]
    if s == "menu" then
        drawmenu(state)
    elseif s == "gaming" then
        updatecamera(state)
        drawgaming(state)
    elseif s == "pause" then
        updatecamera(state)
        drawpause(state)
    end
end


local menutree = require("data/menu/tree")
local t_c_t = require("data/tower/tower_class_table")

function love.keypressed(k)
    local s = state[""]
    if s == "pause" then
        -- keybinds when paused)
        if state.leveldata.want_to_quit ~= nil then
            state.leveldata.want_to_quit = nil
            if iskey(k,"menuselect") then
            state[""] = "menu"
            state["menu"] = state.leveldata.exitmenu or "main"
            state["menuentryflag"] = true
            state["cursor"] = 1
            end
        else
            if iskey(k,"pause") then state[""] = "gaming" end
            if iskey(k,"menuquit") then state.leveldata.want_to_quit = true end
        end
    elseif s == "menu" then
        -- keybinds when in menu
        if iskey(k,"menuup") then state["cursor"] = state["cursor"] - 1 end
        if iskey(k,"menudown") then state["cursor"] = state["cursor"] + 1 end
        if iskey(k,"menuselect") and menutree[state["menu"]][state["cursor"]] and locked.unlocked(menutree[state["menu"]][state["cursor"]]) then
            state["menu"] = menutree[state["menu"]][state["cursor"]]
            state["menuentryflag"] = true
            state["cursor"] = 1
        end
        if iskey(k,"menuquit") then state["menu"] = "quit"
            state["menuentryflag"] = true end
    elseif s == "gaming" then
        if iskey(k,"menuquit") then
            state.leveldata.want_to_quit = true
            state[""] = "pause"
        end
        -- keybinds while in-game.
        if state.leveldata.phase == "select" then -- selection phase keybinds
            if iskey(k,"slotstoggle") then
                state.leveldata.slotstoggle = not state.leveldata.slotstoggle
            end
            if iskey(k,"hideselection") then
                state.leveldata.show_selection = not state.leveldata.show_selection
                end
            if iskey(k,"startlevel") then
                state.leveldata.phase = "play"
                state.leveldata.camera_locked = false
                state.leveldata.camerax = -0.5
            end
            if iskey(k, "menuselect") then
                if (state.leveldata.slotstoggle) then
                    -- currently on slots. deselect this slot
                    if array.size(state.leveldata.CHOSEN_TOWERS) >= state.leveldata.slots_cursor_x then
                        array.delete_shift(state.leveldata.CHOSEN_TOWERS,state.leveldata.slots_cursor_x)
                    end
                else
                    local tid = state.leveldata.selection_cursor_x + 9* (state.leveldata.selection_cursor_y - 1)
                    -- currently on selection. add this to slots if unlocked and space exists
                    if array.size(state.leveldata.CHOSEN_TOWERS) < state.playerdata.max_slots and -- space exists
                    t_c_t.number_table[tid] ~= nil and -- and there is a thing to select at all
                    locked.unlocked("tower_" .. t_c_t.number_table[tid]) or (type(state.leveldata.forceunlocks) == "table" and state.leveldata.forceunlocks[t_c_t.number_table[tid]] == true) -- unlocked
                    then
                        local alreadychosen = false
                        for i = 1, array.size(state.leveldata.CHOSEN_TOWERS) do
                            if t_c_t.number_table[tid] == array.get(state.leveldata.CHOSEN_TOWERS,i) then
                                alreadychosen = true
                                break
                            end
                        end
                        if not alreadychosen then array.append(state.leveldata.CHOSEN_TOWERS,t_c_t.number_table[tid]) end
                    end
                end
            end
            if iskey(k,"menuup") then
                if (state.leveldata.slotstoggle == false and state.leveldata.selection_cursor_y > 1) then
                    state.leveldata.selection_cursor_y = state.leveldata.selection_cursor_y - 1
                end
            end
            if iskey(k,"menudown") then
                if (state.leveldata.slotstoggle == false) then
                    state.leveldata.selection_cursor_y = state.leveldata.selection_cursor_y + 1
                end
            end
            if iskey(k,"menuleft") then
                if (state.leveldata.slotstoggle == false) then
                    if state.leveldata.selection_cursor_x > 1 then
                    state.leveldata.selection_cursor_x = state.leveldata.selection_cursor_x - 1
                    end
                elseif (state.leveldata.slots_cursor_x > 1) then
                    state.leveldata.slots_cursor_x = state.leveldata.slots_cursor_x - 1
                end
            end
            if iskey(k,"menuright") then
                if (state.leveldata.slotstoggle == false) then
                    if state.leveldata.selection_cursor_x < td_constants.SELECTION_BOX_WIDTH then
                    state.leveldata.selection_cursor_x = state.leveldata.selection_cursor_x + 1
                    end
                elseif (state.leveldata.slots_cursor_x < state.playerdata.max_slots) then
                    state.leveldata.slots_cursor_x = state.leveldata.slots_cursor_x + 1
                end
            end
        end
        if state.leveldata.phase == "play" then -- play phase keybinds
            if iskey(k,"slotstoggle") then
                state.leveldata.slotstoggle = not state.leveldata.slotstoggle
            end
            if iskey(k,"menuup") then
                if (state.leveldata.slotstoggle == false and state.leveldata.board_cursor_y > 1) then
                    state.leveldata.board_cursor_y = state.leveldata.board_cursor_y - 1
                end
            end
            if iskey(k,"menudown") then
                if (state.leveldata.slotstoggle == false and state.leveldata.board_cursor_y < state.leveldata.breadth) then
                    state.leveldata.board_cursor_y = state.leveldata.board_cursor_y + 1
                end
            end
            if iskey(k,"menuleft") then
                if (state.leveldata.slotstoggle == false) then
                    if state.leveldata.board_cursor_x > 1 then
                    state.leveldata.board_cursor_x = state.leveldata.board_cursor_x - 1
                    end
                elseif (state.leveldata.slots_cursor_x > 1) then
                    state.leveldata.slots_cursor_x = state.leveldata.slots_cursor_x - 1
                end
            end
            if iskey(k,"menuright") then
                if (state.leveldata.slotstoggle == false) then
                    if state.leveldata.board_cursor_x < state.leveldata.length then
                    state.leveldata.board_cursor_x = state.leveldata.board_cursor_x + 1
                    end
                elseif (state.leveldata.slots_cursor_x < array.size(state.leveldata.CHOSEN_TOWERS)) then
                    state.leveldata.slots_cursor_x = state.leveldata.slots_cursor_x + 1
                end
            end
            if iskey(k,"menuselect") then
                if (state.leveldata.slots_cursor_x <= array.size(state.leveldata.CHOSEN_TOWERS)) then -- attempt to place a tower
                    local tid = array.get(state.leveldata.CHOSEN_TOWERS,state.leveldata.slots_cursor_x)
                    if (state.leveldata.mana >= t_c_t.cost(tid)) then -- can afford the tower...
                        local x, y = state.leveldata.board_cursor_x, state.leveldata.board_cursor_y
                        local obstructed = false
                        for i = 1, array.size(state.leveldata.TOWER_ARRAY) do
                            local t = array.get(state.leveldata.TOWER_ARRAY,i)
                            if (t.x == x) and (t.y == y) then
                                -- todo: handling obstructions more nuancedly-- some towers may only obstruct some others
                                obstructed = true
                                break
                            end
                        end
                        if (not obstructed) then
                            -- place tower
                            state.leveldata.mana = state.leveldata.mana - t_c_t.cost(tid)
                            local a = t_c_t.get(tid)(state,x,y,t_c_t.mods(tid))
                            array.append(state.leveldata.TOWER_ARRAY,a)
                        end
                    end
                end
            end
        end
        if iskey(k,"menuselect") and (state.leveldata.phase == "loss" or state.leveldata.phase == "win") then
            state[""] = "menu"
            state["menu"] = state.leveldata.exitmenu or "main"
            state["menuentryflag"] = true
            state["cursor"] = 1
        end
        if (iskey(k,"zoomin")) then
            state.leveldata.camerazoom = state.leveldata.camerazoom * 2
        end
        if (iskey(k,"zoomout")) then
            state.leveldata.camerazoom = state.leveldata.camerazoom / 2
        end
        if (iskey(k,"zoomreset")) then
            state.leveldata.camerazoom = 1.0
        end
        if iskey(k,"pause") then state[""] = "pause" end
    end
end
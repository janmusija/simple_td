-- main.lua
local settings = require("settings")
local gameloop = require("gameloop")
local menu = require("menu")
local Object = require("classic") -- https://github.com/rxi/classic/blob/master/classic.lua
local Button = require("ui/button")
local sl = require("save_load")

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

local DEFAULT_FILE_NAME = "default"
local state = {
    profile = DEFAULT_FILE_NAME,
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

        ENEMY_ARRAY -> collection of currently extant enemies
        CHOSEN_TOWERS -> collection of towers
        TOWER_ARRAY -> collection of currently extant towers
        PROJECTILE_ARRAY -> collection of currently extant projectiles
        MANA = current player mana

        enemies -> set of enemies that appear in this level
        enemy_weights (optional, defaults per-enemy) -> weights of enemies-- how likely they are to spawn when the budget allows them. 
        enemy_wavepoints (optional, defaults per-enemy) -> wavepoints of enemies -- how much of the budget the enemy takes
        initial_mana -> initial mana budget
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
    ]]
        yen = 0,
        completed_levels = {}
    }
}

local test = 0

function love.load() -- when game opens
    love.window.setTitle( "Tower defense (but only for people who dislike having towers)" )
    math.randomseed(os.time())
    local seed = math.random(0,16777215)
    state.playerdata.seed = seed
    if io.open("save/" .. DEFAULT_FILE_NAME .. ".json", "r") then sl.load_player_data(DEFAULT_FILE_NAME,state) end
    locked.updateLocks(state)
end

local accumulator = 0.0
local MAX_FPS = 60
local spf = 1/MAX_FPS


local function updatecamera(state)
    if isheld("panup") and state.leveldata.camera_locked == false then
        state.leveldata.cameray = math.max(state.leveldata.cameray - settings.pan_sensitivity,-2.0/state.leveldata.camerazoom)
    end
    if isheld("pandown") and state.leveldata.camera_locked == false then
        state.leveldata.cameray = state.leveldata.cameray + settings.pan_sensitivity
    end
    if isheld("panleft") and state.leveldata.camera_locked == false then
        state.leveldata.camerax = math.max(state.leveldata.camerax - settings.pan_sensitivity,-0.5/state.leveldata.camerazoom)
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

function love.keypressed(k)
    local s = state[""]
    if s == "pause" then
        -- keybinds when paused)
        if iskey(k,"pause") then state[""] = "gaming" end
    elseif s == "menu" then
        -- keybinds when in menu
        if iskey(k,"menuup") then state["cursor"] = state["cursor"] - 1 end
        if iskey(k,"menudown") then state["cursor"] = state["cursor"] + 1 end
        if iskey(k,"menuselect") and menutree[state["menu"]][state["cursor"]] and locked.unlocked(menutree[state["menu"]][state["cursor"]]) then
            state["menu"] = menutree[state["menu"]][state["cursor"]]
            state["menuentryflag"] = true
            state["cursor"] = 1
            locked.updateLocks(state) -- likely overzealous
        end
        if iskey(k,"menuquit") then state["menu"] = "quit"
            state["menuentryflag"] = true end
    elseif s == "gaming" then
        -- keybinds while in-game.
        if iskey(k,"menuselect") and state.leveldata.phase == "select" then
            -- condition to enure this only happens while key is on "start button": TK, you know, when start button exists
            state.leveldata.phase = "play"
            state.leveldata.camera_locked = false
        elseif iskey(k,"menuselect") and (state.leveldata.phase == "loss" or state.leveldata.phase == "win") then
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
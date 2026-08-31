-- main.lua
local settings = require("settings")
local gameloop = require("gameloop")
local menu = require("menu")
local Object = require("classic") -- https://github.com/rxi/classic/blob/master/classic.lua
local Button = require("ui/button")
local save_player_data, load_player_data = require("save_load")

local load_level = require("data/load_level_from_disk")

local w, h = love.graphics.getDimensions()
local font = love.graphics.getFont()
local state = {
    [""] = "menu", -- (can be "menu" in menus, "pause" when paused, or "gaming" when playing the game)
    menu = "main", -- the screen of the menu
    cursor = 1, -- cursor position in menu (navigated  with arrow keys)
    menuentryflag = true, -- turned on when entering a menu. then turned off once relevant code is executed
    level = 0, -- what level is being played. 0 when not in use
    leveldata = { -- data about current level
        phase = "select" -- select towers. can also be "play" to be play, "win" when won, and "lose" when lost.
    },
    playerdata = { -- data about the player
        test = true
    }
}

local test = 0

function love.load() -- when game opens
    love.window.setTitle( "Menu Navigator 10000" )
end

function love.update()
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
end

function love.draw()
    local s = state[""]
    --[[love.graphics.setColor(1,0.8,0)
    love.graphics.print(test,w/4,3*h/4)]]
    if s == "menu" then
        drawmenu(state)
    elseif s == "gaming" then
        drawgaming(state)
    elseif s == "pause" then
        drawpause(state)
    end
end

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
        if iskey(k,"menuselect") and menutree[state["menu"]][state["cursor"]] then
            -- TODO: implement locked menus (so that you can't, like, enter levels illegally.)
            state["menu"] = menutree[state["menu"]][state["cursor"]]
            state["menuentryflag"] = true
            state["cursor"] = 1 end
        if iskey(k,"menuquit") then state["menu"] = "quit"
            state["menuentryflag"] = true end
    elseif s == "gaming" then
        -- keybinds while in-game.
        if iskey(k,"pause") then state[""] = "pause" end
    end
end
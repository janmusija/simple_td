-- main.lua
local settings = require("settings")
local gameloop = require("gameloop")
local menu = require("menu")
local Object = require("classic") -- https://github.com/rxi/classic/blob/master/classic.lua
local Button = require("ui/button")

local w, h = love.graphics.getDimensions()
local font = love.graphics.getFont()
local state = {}
--[[
    state[""] = "menu" (in menus), "pause" (paused), or "gaming" (playing the game). 
    state["menu"] = the screen of the menu. e.g. "main"
]]--

local test = 0

function love.load() -- when game opens
    state[""] = "gaming"
    state["menu"] = "main" 
    love.window.setTitle( "okay now an actual 'game'" )
end

function love.update(dt) -- dt = time to update last frame (thus expected time for this frame)
    local s = state[""]
	if s == "menu" then
        updatemenu(dt, state)
    elseif s == "pause" then
        updatepause(dt,state)
    elseif s == "gaming" then
        updategaming(dt,state)
    else 
    -- damage control
    end
end

function love.draw(dt) -- rendering
    local s = state[""]
    love.graphics.setColor({1,0.6,0})
    love.graphics.print(test, w/4, 3*h/4)
    if s == "pause" then
        love.graphics.setColor(0,0,0,0.2)
        love.graphics.rectangle("fill",0,0,w,h)
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

function love.keypressed(k)
    local s = state[""]
    if s == "pause" then
        -- keybinds when paused
        if iskey(k,"pause") then state[""] = "gaming"
        test = test + 1 end
    elseif s == "menu" then
        -- keybinds when in menu
    elseif s == "gaming" then
        -- keybinds while in-game.
        if iskey(k,"pause") then state[""] = "pause" end
    end
end
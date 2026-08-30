-- main.lua
local settings = require("settings")
local gameloop = require("gameloop")
local menu = require("menu")
local Object = require("classic") -- https://github.com/rxi/classic/blob/master/classic.lua
local Button = require("ui/button")

local w, h = love.graphics.getDimensions()
local font = love.graphics.getFont()
local state = 'menu'

local test = 0

function love.load() -- when game opens
    state = 'gaming'
    love.window.setTitle( "if you need to take a break from the stress of clicking the rectangle you can now PAUSE the game." )
    b1 = Button(w/4,h/4,w/2,h/2,"text",function()
    test = test+1
    end,{1,0.7,0})
end

function love.update(dt) -- dt = time to update last frame (thus expected time for this frame)
	if state == 'menu' then
        updatemenu(dt)
    elseif state == 'pause' then
        updatepause(dt)
    elseif state == 'gaming' then
        b1:update()
        updategaming(dt)
    else 
    -- damage control
    end
end

function love.draw(dt) -- rendering
	b1:draw()
    love.graphics.setColor({255,255,255})
    love.graphics.print(test, w/4, 3*h/4)
    if state == 'pause' then
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

function love.keypressed(k) --
    if state == 'pause' then
        -- keybinds when paused
        if iskey(k,"pause") then state = 'gaming' end
    elseif state == 'menu' then
        -- keybinds when in menu
    elseif state == 'gaming' then
        -- keybinds while in-game.
        if iskey(k,"pause") then state = 'pause' end
    end
end
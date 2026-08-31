local font36 = love.graphics.newFont(36)
local font18 = love.graphics.newFont(18)
local w, h = love.graphics.getDimensions()

local menunames = require("data/menu/menunames")
local tree = require("data/menu/tree")
local entryfuncs = require("data/menu/entryfunc")
local locked = require("data/menu/locked")

function updatemenu(state)
    if (not tree[state["menu"]]) and state["menu"] ~= "dummy" then tree[state["menu"]] = {[1] = "dummy"} end
    if not tree[state["menu"]][state["cursor"]] then
        state["cursor"] = 1
    end
    if state["menuentryflag"] then
        state["menuentryflag"] = false
        if entryfuncs[state["menu"]] then
            entryfuncs[state["menu"]](state)
        end
    end
end

function drawmenu(state)
    love.graphics.setColor({1,1,1})
    love.graphics.setFont(font36)
    love.graphics.print(menunames[state["menu"]] or state["menu"],0,0)
    love.graphics.setFont(font18)
    i = 1
    while tree[state["menu"]] and tree[state["menu"]][i] do
        menuid = tree[state["menu"]][i]
        if not locked.unlocked(menuid) then
            love.graphics.setColor({0.6,0.1,0.1})
            if i == state["cursor"] then
            love.graphics.print(">",0,72+i*36)
            end
            love.graphics.print((menunames[menuid] or menuid) .. " (LOCKED)",36,72+i*36)
        elseif i == state["cursor"] then
            love.graphics.setColor({1,1,1})
            love.graphics.print(">",0,72+i*36)
            love.graphics.print(menunames[menuid] or menuid,36,72+i*36)
        else
            love.graphics.setColor({0.7,0.7,0.7})
            love.graphics.print(menunames[menuid] or menuid,36,72+i*36)
        end
        i = i+1
    end

    -- special cases
end
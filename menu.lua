font36 = love.graphics.newFont(36)
font18 = love.graphics.newFont(18)

local menunames = require("data/menu/menunames")
local tree = require("data/menu/tree")
local entryfuncs = require("data/menu/entryfunc")

function updatemenu(dt, state)
    if (not tree[state["menu"]]) and state["menu"] != "dummy" then tree[state["menu"]] = {[1] = "dummy"} end
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

function drawmenu(dt, state)
    love.graphics.setColor({1,1,1})
    love.graphics.setFont(font36)
    love.graphics.print(menunames[state["menu"]] or state["menu"],0,0)
    love.graphics.setFont(font18)
    i = 1
    while tree[state["menu"]][i] do
        menuid = tree[state["menu"]][i]
        if i == state["cursor"] then
            love.graphics.setColor({1,1,1})
            love.graphics.print(">",0,72+i*36)
            love.graphics.print(menunames[menuid] or menuid,36,72+i*36)
        else
            love.graphics.setColor({0.7,0.7,0.7})
            love.graphics.print(menunames[menuid] or menuid,36,72+i*36)
        end
        i = i+1
    end
end
local load_level = require("data/load_level_from_disk")

local sl = require("save_load")

funcs = {
    quityes = function(state)
        sl.save_player_data(state.profile,state)
        love.event.quit()
    end,
    quitnosave = function(state)
        love.event.quit()
    end
}

for i = 1,3 do
    for j = 1,5 do
        for k = 1,10 do
            local lname = "c" .. i .. "w" .. j .. "l" .. k
            funcs[lname] = function(state)
                state["level"] = lname
                state[""] = "gaming"
                load_level(state["leveldata"],lname)
            end
        end
    end
end

return funcs
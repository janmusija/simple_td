local json = require("json")

local sl = {}

function sl.save_player_data(filename,state)
    local savestring = json.encode(state["playerdata"])
    local f = assert(io.open("save/" .. filename .. ".json", "w"))
    f:write(savestring)
    f:close()
end

function sl.load_player_data(filename,state)
    local f = assert(io.open("save/" .. filename .. ".json", "r"))
    local savestring = f:read("*all")
    f:close()
    state["playerdata"] = json.decode(savestring)
end

return sl
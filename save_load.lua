local json = require("json")

function save_player_data(filename,state)
    local savestring = json.encode(state["playerdata"])
    local f = assert(io.open("save/" .. filename .. ".json", "w"))
    f:write(savestring)
end

function load_player_data(filename,state)
    local f = assert(io.open("save/" .. filename .. ".json", "r"))
    local savestring = f:read("*all")
    state["playerdata"] = json.decode(savestring)
end

return save_player_data, load_player_data
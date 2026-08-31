local function isnumber(str)
    local n = tonumber(str)
    if n then return true else return false end
end

local function locate_level_file(id)
    if string.len(id) > 5 and string.sub(id,1,1) == "c" then 
        local i = 2
        local j = 2
        local camp = 0
        local worl = 0
        local lev = 0
        while (isnumber(string.sub(id,i,j+1)) and j < string.len(id)) do j = j+1 end
        camp = tonumber(string.sub(id,i,j))
        if (j+4 > string.len(id) or string.sub(id,j+1,j+1) != "w") then return id end
        i = j+2
        j = i
        while (isnumber(string.sub(id,i,j+1)) and j < string.len(id)) do j = j+1 end
        worl = tonumber(string.sub(id,i,j))
        if (j+2 > string.len(id) or string.sub(id,j+1,j+1) != "l") then return id end
        i = j+2
        j = i
        while (isnumber(string.sub(id,i,j+1)) and j < string.len(id)) do j = j+1 end
        lev = tonumber(string.sub(id,i,j))
        if (j!= string.len(id)) then return id 
        else 
            local path = "c" .. camp .. "/w" .. worl .. "/l" .. lev
            return path
        end
    end
    return id
end

local sl = require("save_load")

local function initialize_level (LEVEL_DATA_CONTAINER,id,state)
    state.leveldata = nil -- destroy any potentially existing data about other levels.
    local location = locate_level_file(id)
    sl.read_level_data(location,state)
    state.leveldata.phase = "select"
    if state.leveldata.enemies == nil then
        print ("Error: no enemies in this level!")
        state.leveldata.enemies = {cube = true}
    end
    if state.leveldata.enemy_weights == nil then state.leveldata.enemy_weights = {}
    if state.leveldata.enemy_wavepoints == nil then state.leveldata.enemy_wavepoints = {}
    if state.leveldata.enemy_modifiers == nil then state.leveldata.enemy_modifiers = {}
    for k, v in pairs(leveldata.enemy)
        if state.leveldata.enemy_weights[k] == nil then
            state.leveldata.enemy_weights[k] = 1 -- TODO: set these to default weights
        end
        if state.leveldata.enemy_wavepoints[k] == nil then
            state.leveldata.enemy_wavepoints[k] = 1 -- TODO: set these to default wavepoints
        end
    end

    -- other level initialization details. define sensible defaults here for wave scaling etc
end

return initialize_level
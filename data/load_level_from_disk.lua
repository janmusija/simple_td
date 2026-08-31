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
        if (j+4 > string.len(id) or string.sub(id,j+1,j+1) ~= "w") then return id end
        i = j+2
        j = i
        while (isnumber(string.sub(id,i,j+1)) and j < string.len(id)) do j = j+1 end
        worl = tonumber(string.sub(id,i,j))
        if (j+2 > string.len(id) or string.sub(id,j+1,j+1) ~= "l") then return id end
        i = j+2
        j = i
        while (isnumber(string.sub(id,i,j+1)) and j < string.len(id)) do j = j+1 end
        lev = tonumber(string.sub(id,i,j))
        if (j~= string.len(id)) then return id 
        else 
            local path = "c" .. camp .. "/w" .. worl .. "/l" .. lev
            return path
        end
    end
    return id
end

local sl = require("save_load")
local e_c_t = require("data/enemy/enemy_class_table")

local function initialize_level (state,id)
    state.leveldata = nil -- destroy any potentially existing data about other levels.
    local location = locate_level_file(id)
    sl.read_level_data(location,state)
    state.leveldata.phase = "select"
    if state.leveldata.enemies == nil then
        print ("Error: no enemies in this level!")
        state.leveldata.enemies = {cube = true}
    end
    if state.leveldata.enemy_weights == nil then state.leveldata.enemy_weights = {} end
    if state.leveldata.enemy_wavepoints == nil then state.leveldata.enemy_wavepoints = {} end
    if state.leveldata.enemy_modifiers == nil then state.leveldata.enemy_modifiers = {} end
    for k, v in pairs(state.leveldata.enemies) do
        if state.leveldata.enemy_weights[k] == nil then
            if (e_c_t[k] ~= nil) and (e_c_t[k].weight ~= nil) then
                state.leveldata.enemy_weights[k] = e_c_t[k].weight
            else
            state.leveldata.enemy_weights[k] = 1
            end
        end
        if state.leveldata.enemy_wavepoints[k] == nil then
            if (e_c_t[k] ~= nil) and (e_c_t[k].wavepoints ~= nil) then
                state.leveldata.enemy_wavepoints[k] = e_c_t[k].wavepoints
            else
            state.leveldata.enemy_wavepoints[k] = 200
            end
        end
    end
    if state.leveldata.length == nil then state.leveldata.length = 9 end
    if state.leveldata.breadth == nil then state.leveldata.length = 5 end
end

return initialize_level
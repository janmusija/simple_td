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

local function int_from_string_bad(str)
    local out = 0
    for i = 1,string.len(str) do
        out = out ~ bit.ror(string.byte(str,i),3*i)
        --print(string.byte(str,i), out)
    end
    return out
end

local array = require("array")

local function initialize_level (state,id)
    state.leveldata = nil -- destroy any potentially existing data about other levels.
    local location = locate_level_file(id)
    sl.read_level_data(location,state)
    if state.leveldata.enemies == nil then
        print ("Error: no enemies in this level!")
        state.leveldata.enemies = {cube = true}
    end
    if state.leveldata.enemy_weights == nil then state.leveldata.enemy_weights = {} end
    if state.leveldata.enemy_wavepoints == nil then state.leveldata.enemy_wavepoints = {} end
    for k, v in pairs(state.leveldata.enemies) do
        if state.leveldata.enemy_weights[k] == nil then
            if (e_c_t.get(k).weight ~= nil) then
                state.leveldata.enemy_weights[k] = e_c_t.get(k).weight
            else
            state.leveldata.enemy_weights[k] = 1
            end
        end
        if state.leveldata.enemy_wavepoints[k] == nil then
            if (e_c_t.get(k).wavepoints ~= nil) then
                state.leveldata.enemy_wavepoints[k] = e_c_t.get(k).wavepoints
            else
            state.leveldata.enemy_wavepoints[k] = 200
            end
        end
        if state.leveldata.__minwp == nil or state.leveldata.enemy_wavepoints[k] < state.leveldata.__minwp then
            state.leveldata.__minwp = state.leveldata.enemy_wavepoints[k]
        end
    end
    if state.leveldata.length == nil then state.leveldata.length = 9 end
    if state.leveldata.breadth == nil then state.leveldata.length = 5 end

    -- initialize level data
    state.leveldata.phase = "select"
    state.leveldata.wave = 0
    state.leveldata.wavetimer = 0
    state.leveldata.budget = 0
    state.leveldata.timer = 0


    state.leveldata.CHOSEN_TOWERS = array.new()
    state.leveldata.ENEMY_ARRAY = array.new()
    state.leveldata.TOWER_ARRAY = array.new()
    state.leveldata.PROJECTILE_ARRAY = array.new()

    --state.leveldata.camerax = -0.5
    state.leveldata.camerax = state.leveldata.length
    state.leveldata.cameray = -1.5
    state.leveldata.camerazoom = 1
    state.leveldata.camera_locked = true
    state.leveldata.camera_pan_velocity = 0.1

    state.leveldata.board_cursor_x = 1
    state.leveldata.selection_cursor_x = 1
    state.leveldata.board_cursor_y = 1
    state.leveldata.selection_cursor_y = 1
    state.leveldata.slots_cursor_x = 1
    state.leveldata.show_selection = true
    state.slotstoggle = false -- is the cursor on slots?

    -- initialize level rng (seeded by game seed, levelid, and player yen)
    local seed = state.playerdata.seed
    seed = seed ~ state.playerdata.yen
    seed = seed ~ int_from_string_bad(id)
    --print(seed)
    math.randomseed(seed)
end

return initialize_level
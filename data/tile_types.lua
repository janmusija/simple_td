-- types of different tiles and their encodings in level json "grid"s

--[[
    normal -> self explanatory

]]

local tile_type_map = {
    ["."] = "normal",
    ["'"] = "air",
    ["~"] = "water",
    ["_"] = "void",
}

return tile_type_map
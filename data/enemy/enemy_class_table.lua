local Cube = require("data/enemy/enemies/cube")
local Matryoshka = require("data/enemy/enemies/matryoshka")

return {
    cube = Cube,
    matryoshka = Matryoshka,


    -- duplicates-- which can therefore have alternate modifiers, weights, etc...
    also_cube = Cube,
    third_cube = Cube,
    also_matryoshka = Matryoshka,
    third_matroshka = Matryoshka
}
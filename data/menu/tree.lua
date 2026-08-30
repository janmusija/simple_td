-- menu navigation tree
-- note: menus without an entry here will immediately crash the game when entered. notably, "dummy"

return {
    main = {
        [1] = "worlds",
        [2] = "shop",
        [3] = "quit"
    },
    worlds = {
        [1] = "world1",
        [2] = "world2",
        [3] = "world3",
        [4] = "world4",
        [5] = "world5",
        [6] = "main"
    },
    shop = {
        [1] = "main"
    },
    world1 = {
        [1] = "worlds"
    },
    world2 = {
        [1] = "worlds"
    },
    world3 = {
        [1] = "worlds"
    },
    world4 = {
        [1] = "worlds"
    },
    world5 = {
        [1] = "worlds"
    },
    quit = {
        [2] = "quityes",
        [1] = "main"
    },
    quityes = {
        [1] = "dummy"
    }
}
-- menu navigation tree
-- note: non-"dummy" menus without an entry here will have a failsafe case which is to link to "dummy". "dummy" in turn immediately crashes the game if you enter it

tree = {
    main = {
        [1] = "campaigns",
        [2] = "shop",
        [3] = "quit"
    },
    shop = {
        [1] = "main"
    },
    quit = {
        [2] = "quityes",
        [1] = "main"
    },
    campaigns = {
        [1] = "campaign1", -- new game
        [2] = "campaign2", -- ng+
        [3] = "campaign3", -- ng++
        [4] = "main"
    }
}

local function add_many_children(parentnode,childname,count,backname)
    if not tree[parentnode] then
        tree[parentnode] = {}
    end
    local num = 1
    local i = 1
    while num < count+1 do
        if (not tree[parentnode][i]) then
            tree[parentnode][i] = childname .. num 
            num = num + 1
        end
        i = i+1
    end
    if backname then
        while tree[parentnode][i] do i = i+1 end
        tree[parentnode][i] = backname
    end
end

-- worlds of campaigns
add_many_children("campaign1","c1world",5,"campaigns")
add_many_children("campaign2","c2world",5,"campaigns")
add_many_children("campaign3","c3world",5,"campaigns")

-- levels of worlds
for i = 1,3 do
    for j = 1,5 do
        add_many_children("c" .. i .. "world" .. j, "c" .. i .. "w" .. j .. "l",10,"campaign" .. i)
    end
end

return tree
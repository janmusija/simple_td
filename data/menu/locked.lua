-- conditions for locking / unlocking menu items

local locked = {
    locks = {},
}

locked.register_lock = function(menu_id,unlock_condition)
    locked.locks[menu_id] = unlock_condition
end

locked.LOCK_BY_LEVEL = function (menu_id,unlock_level,state)
    locked.register_lock(menu_id, function()
        return state.playerdata.completed_levels[unlock_level] == true
    end
    )
end

locked.PERMALOCK = function(menu_id,unlock_level)
    locked.register_lock(menu_id, function() return false end)
end

-- gate levels, worlds, etc
locked.runThisInMainToAccessRelevantParameters_ThereIsProbablyABetterWayToDoThis = function (state)
    for i = 1,4 do
        for j = 1,5 do
            for k = 1,9 do
                locked.LOCK_BY_LEVEL("c" .. i .. "w" .. j .. "l" .. (k+1),"c" .. i .. "w" .. j .. "l" .. k,state)
            end
        end
        for j = 1,4 do
            locked.LOCK_BY_LEVEL("c" .. i .. "world" .. (j+1), "c" .. i .. "w" .. j .. "l" .. 10,state)
        end
    end
    locked.LOCK_BY_LEVEL("campaign2", "c1w5l10",state)
    locked.LOCK_BY_LEVEL("campaign3", "c2w5l10",state)
    locked.LOCK_BY_LEVEL("campaign4", "c2w5l10",state) -- yes, 2.
end


return locked
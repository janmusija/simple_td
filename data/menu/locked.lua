-- conditions for locking / unlocking menu items

local locked = {
    locks = {}, -- locked = true, unlocked = nil
}

locked.unlocked = function (id)
    if locked.locks[id] == nil or locked.locks[id] == false then return true
    elseif locked.locks[id] == true then return false
    end
end

locked.LOCK_BY_LEVEL = function (menu_id,unlock_level,state)
    if state.playerdata.completed_levels[unlock_level] then
        locked.locks[menu_id] = nil
    else 
        locked.locks[menu_id] = true
    end
end

locked.PERMALOCK = function(menu_id)
    locked.locks[menu_id] = true
end

locked.ALWAYS_UNLOCKED = function(menu_id) -- sure, you could also just not initialize it to begin with.
    locked.locks[menu_id] = nil
end

-- update whether levels, worlds, etc are locked. previously I had some insane system that stored individual functions that would check these things individually every time you rendered a menu.
locked.updateLocks = function (state)
    -- levels
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
    locked.LOCK_BY_LEVEL("campaign4", "c2w5l10",state) -- (yes, 2.)

    -- towers
    locked.ALWAYS_UNLOCKED("tower_shooter")
    locked.LOCK_BY_LEVEL("tower_mana_orb", "c1w1l1", state)
    locked.LOCK_BY_LEVEL("tower_brick", "c1w1l2", state)
end


return locked
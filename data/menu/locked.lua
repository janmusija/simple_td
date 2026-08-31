-- conditions for locking / unlocking menu items

local locked = {
    locks = {},
    register_lock = function(menu_id,unlock_condition)
        locked.locks[menu_id] = unlock_condition
    end
}

return locked
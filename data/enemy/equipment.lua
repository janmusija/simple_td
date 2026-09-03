function Equipment:new(state,mods)
    -- common equipment
    if mods == nil then mods = {} end
    self.sprite = mods.sprite or nil
    self.hp = mods.hp or 20
    self.name = mods.name
end
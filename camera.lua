-- TK -- unified camera conversion constants
local w, h = love.graphics.getDimensions()
local cam = {}

cam.SCALE_FACTOR = w/11

cam.get_canvas_position = function(cx,cy,cz,x,y)
    return (-cx + x - 1)*cam.SCALE_FACTOR*cz, (-cy + y -1)*cam.SCALE_FACTOR*cz
end

cam.ZOOM_SF_ENTITY = function(cz)
    return cam.SCALE_FACTOR*cz/128
end

cam.ZOOMED_SCALE_FACTOR = function(cz)
    return cam.SCALE_FACTOR*cz
end

return cam
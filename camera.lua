-- TK -- unified camera conversion constants
local w, h = love.graphics.getDimensions()
local cam = {}

cam.SCALE_FACTOR = w/11

cam.SF_ENTITY = cam.SCALE_FACTOR/128

cam.get_canvas_position = function(cx,cy,cz,x,y)
    return (-cx + x - 1)*cam.SCALE_FACTOR*cz, (-cy + y -1)*cam.SCALE_FACTOR*cz
end

cam.get_abs_position = function(cx,cy,cz,x,y)
    return (x + cx + 1)/(cam.SCALE_FACTOR*cz), (y+ cy + 1)/(cam.SCALE_FACTOR*cz)
end

return cam
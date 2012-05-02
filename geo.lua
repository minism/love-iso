-- Geometric functions

geo = {}

function geo.rotate(x, y, theta)
    local rx = x * math.cos(theta) - y * math.sin(theta)
    local ry = x * math.sin(theta) + y * math.cos(theta)
    return rx, ry
end

function geo.toOrtho(x, y)
    local x = x / config.isoScale[1]
    local y = y / config.isoScale[2]
    x, y = geo.rotate(x, y, -config.isoAngle)
    return x, y
end

function geo.toIso(x, y)
    local x, y = geo.rotate(x, y, config.isoAngle)
    local x = x * config.isoScale[1]
    local y = y * config.isoScale[2]
end

function geo.contains(left, top, right, bottom, x, y)
    if  x >= left and
        x <= right and
        y >= top and
        y <= bottom then 
            return true     
    end
    return false
end

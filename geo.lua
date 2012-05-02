-- Geometric functions

geo = {}

function geo.rotate(x, y, theta)
    local rx = x * math.cos(theta) - y * math.sin(theta)
    local ry = x * math.sin(theta) + y * math.cos(theta)
    return rx, ry
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

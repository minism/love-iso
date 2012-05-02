require 'geo'

iso = {
    angle = math.atan2(1, 1),
    scale = {
        x = 1, 
        y = 0.5,
    }
}

function iso.toOrtho(x, y)
    local x = x / iso.scale.x
    local y = y / iso.scale.y
    x, y = geo.rotate(x, y, -iso.angle)
    return x, y
end

function iso.toIso(x, y)
    local x, y = geo.rotate(x, y, iso.angle)
    x = x * iso.scale.x
    y = y * iso.scale.y
    return x, y
end

function iso.applyMatrix()
    love.graphics.scale(iso.scale.x, iso.scale.y)
    love.graphics.rotate(iso.angle)
end

function iso.undoMatrix()
    love.graphics.rotate(-iso.angle)
    love.graphics.scale(1 / iso.scale.x, 1 / iso.scale.y)
end

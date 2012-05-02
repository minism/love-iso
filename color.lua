color = {
    white = {255, 255, 255}
}

for k, v in pairs(color) do
    color[k] = function(alpha)
        local r, g, b = unpack(v)
        love.graphics.setColor(r, g, b, alpha or 255)
    end
end

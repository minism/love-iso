local assets = {}

function assets.load(finished)
    -- Enable console during loading
    app:swapContext(console)

    -- Load images
    assets.gfx = fs.loadImages('gfx', assets.print)
    for name, image in pairs(assets.gfx) do
        image:setFilter('nearest', 'nearest')
    end

    -- Load pixel shaders
    assets.shaders = fs.loadShaders('shaders')

    finished()
end

function assets.print(alpha, path)
    console:write("Loading " .. path)
end

return assets

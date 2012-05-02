local assets = {}

function assets.load(finished)
    -- Enable console during loading
    app:swapContext(console)

    -- Load images
    assets.gfx = leaf.fs.loadImages('gfx', assets.print)

    finished()
end

function assets.print(alpha, path)
    console:write("Loading " .. path)
end

return assets

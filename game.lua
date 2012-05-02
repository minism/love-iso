require 'entity'
require 'area'
require 'iso'

local game = Context()

function game:init()
    -- Setup camera
    game.camera = Camera {
        scale = config.cameraScale
    }

    -- Create a test area
    game.area = Area()

    -- Done loading
    console:write('Game initialized')
    game:printKeys()
end

function game:parseInput(dt)
    -- Move camera
    local kd = love.keyboard.isDown
    if kd('d') or kd('right') then game.camera.x = game.camera.x + dt * config.cameraSpeed end
    if kd('a') or kd('left')  then game.camera.x = game.camera.x - dt * config.cameraSpeed end
    if kd('w') or kd('up')    then game.camera.y = game.camera.y - dt * config.cameraSpeed end
    if kd('s') or kd('down')  then game.camera.y = game.camera.y + dt * config.cameraSpeed end
end

function game:update(dt)
    -- Update globals
    tween.update(dt)

    -- Input
    game:parseInput(dt)

    -- Update area
    game.area:update(dt)

    -- Get world position of mouse and query area
    local wx, wy = game.camera:toWorld(love.mouse.getX(), love.mouse.getY())
    game.area:hover(wx, wy)
end

function game:draw()
    -- Draw in camera
    love.graphics.push()
        game.camera:applyMatrix()

        -- Draw in isometric view
        love.graphics.push()
            if config.iso then iso.applyMatrix() end
            game.area:draw()
        love.graphics.pop()

    love.graphics.pop()
        
    if config.debug then
        console:draw()
        color.white()
        love.graphics.print("FPS: " .. love.timer.getFPS(), love.graphics.getWidth() - 75, 5)
    end
end


-- Key bindings

game.keys = {
    -- ['`'] = function()
    --     if not console.active then
    --         console.active = true
    --         app:pushContext(console)
    --     else
    --         console.active = false
    --         app:popContext()
    --     end
    -- end,

    f1 = { "Toggle debug mode", function()
        config.debug = not config.debug
    end },

    f2 = { "Toggle isometric mode", function() 
        config.iso = not config.iso
    end },

    t = { "Randomize tile heights", function ()
        console:write('Randomizing tile heights...')
        local range = math.random(15, 30)
        map2d(game.area.tiles, function(tile)
            tile.z = 0
            tween.stop(tile.tween)
            tile.tween = tween(1, tile, { z = math.random(-range, range)}, 'inOutQuad')
        end)
    end },

    escape = { "Quit", function()
        require 'os'
        os.exit()
    end },
}

function game:printKeys()
    console:write('Key bindings...')
    for k, v in pairs(game.keys) do
        console:write(k:upper() .. ": " .. v[1])
    end
end

function game:keypressed(key, unicode)
    if game.keys[key] then
        game.keys[key][2]()
        return true
    end
end

return game


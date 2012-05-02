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
            iso.applyMatrix()
            game.area:draw()
        love.graphics.pop()

    love.graphics.pop()
        
    if config.debug then
        console:draw()
        love.graphics.setColor(255, 255, 0)
        love.graphics.print("FPS: " .. love.timer.getFPS(), love.graphics.getWidth() - 75, 5)
    end
end


-- Key bindings

local gameKeys = {
    -- ['`'] = function()
    --     if not console.active then
    --         console.active = true
    --         app:pushContext(console)
    --     else
    --         console.active = false
    --         app:popContext()
    --     end
    -- end,

    f1 = function()
        config.debug = not config.debug
    end,

    t = function ()
        map2d(game.area.tiles, function(tile)
            tile.z = 0
            tween.stop(tile.tween)
            tile.tween = tween(1, tile, { z = math.random(-35, 35)}, 'inOutQuad')
        end)
    end,

    escape = function()
        require 'os'
        os.exit()
    end,
}

function game:keypressed(key, unicode)
    if gameKeys[key] then
        gameKeys[key]()
        return true
    end
end

return game


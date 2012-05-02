require 'entity'
require 'area'
require 'iso'

local game = Context()

function game:init()
    -- Setup camera
    game.camera = Camera {
        scale = config.cameraScale
    }

    -- Setup cursor
    game.cursor = {
        tile = nil,
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

    -- Move cursor
    local wx, wy = game.camera:toWorld(love.mouse.getX(), love.mouse.getY())
    local query = game.area:tileAt(iso.toOrtho(wx, wy))
    if query then
        game.cursor.tile = query
    else
        game.cursor.tile = nil
    end

    if love.mouse.isDown('r') then
        if game.cursor.tile then
            game.area:createVilliager(game.cursor.tile)
        end
    end
    if love.mouse.isDown('l') then
        if game.cursor.tile then
            game.area:createWater(game.cursor.tile)
        end
    end
end

function game:update(dt)
    -- Update globals
    tween.update(dt)

    -- Input
    game:parseInput(dt)

    -- Update area
    game.area:update(dt)
end

function game:draw()
    -- Draw in camera
    love.graphics.push()
        game.camera:applyMatrix()

        -- Draw in isometric view
        love.graphics.push()
            if config.iso then iso.applyMatrix() end

            -- Draw area (tiles, )
            game.area:draw()

            -- Draw cursor
            if game.cursor.tile then
                color.white(50)
                love.graphics.rectangle('fill', game.cursor.tile:getRect())
            end
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

    f3 = { "Cycle camera zoom", function()
        config.cameraScale = (config.cameraScale % 3) + 1
        game.camera.scale = config.cameraScale
        console:write("Camera zoom level " .. config.cameraScale)
    end },

    f10 = { "Flush animation timers", function() 
        console:write("Animation timers reset")
        tween.resetAll()
    end },

    t = { "Randomize tile heights", function ()
        console:write('Randomizing tile heights...')
        local range = math.random(8, 16)
        map2d(game.area.tiles, function(tile)
            tile.z = 0
            tween.stop(tile.tween)
            tile.tween = tween(1, tile, { z = math.random(-range, range)}, 'inOutQuad')
        end)
    end },

    r = { "Reset tile heights", function() 
        console:write('Tile heights set to zero')
        map2d(game.area.tiles, function(tile) 
            tween.stop(tile.tween)
            tile.z = 0 
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


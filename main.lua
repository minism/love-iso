require 'math'
require 'os'
require 'leaf'
inspect = require 'inspect'
under = require 'underscore'

-- Import leaf
for k, v in pairs(leaf) do
    _G[k] = v
end

-- Override console
require 'console'

function love.load()
    math.randomseed(os.time()); math.random()

    -- Global objects
    console = Console()
    console.active = false
    time = Time()

    -- Toplevel app
    app = App()
    app:bind()

    -- Load assets
    local assets = require 'assets'
    assets.load(function()
        -- Boot game
        local game = require 'game'
        game.init()
        app:swapContext(game)
    end)
end


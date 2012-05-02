require 'math'
require 'os'
require 'leaf'
inspect = require 'inspect'
under = require 'underscore'


-- Import leaf
for k, v in pairs(leaf) do
    _G[k] = v
end

function love.load()
    math.randomseed(os.time()); math.random()

    -- Global objects
    console = Console()
    console.active = false
    time = Time()

    -- Boot game
    app = App()
    local game = require 'game'
    app:bind()
    app:pushContext(game)
    game.init()
end


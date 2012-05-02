require 'math'

function love.conf(t)
    -- Custom settings
    NAME    = 'iso'
    VERSION = '0.1'

	-- Love settings
	t.title = NAME
	t.author = "joshbothun@gmail.com"
	t.identity = nil
	t.console = true
	t.screen.width = 800
	t.screen.height = 600
	t.screen.fullscreen = false
	t.screen.vsync = false
	t.screen.fsaa = 0
	
	-- Modules
	t.modules.joystick = true
	t.modules.audio = true
	t.modules.keyboard = true
	t.modules.event = true
	t.modules.image = true
	t.modules.graphics = true
	t.modules.timer = true
	t.modules.mouse = true
	t.modules.sound = true   
	t.modules.physics = false
end

config = {
	debug = true,
	iso = true,
	cameraSpeed = 200,
	cameraScale = 2,
}

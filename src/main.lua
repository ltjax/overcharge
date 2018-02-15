local class = require "middleclass"
local Gamestate = require "gamestate"

function clamp(low, n, high)
    return math.min(math.max(low, n), high)
end

debuggingEnabled = false

function love.load(arg)

    -- Enable debugging
    if arg[#arg] == "-debug" then
        require("mobdebug").start()
        debuggingEnabled = true
    else
        math.randomseed(os.time())
    end

    love.window.setTitle("Overcharge")
    
    -- Start the gamestate manager and move to the logo state
    local events = {'draw', 'errhand', 'focus', 'keypressed', 'keyreleased', 'mousefocus',
        'mousepressed', 'mousereleased', 'mousemoved', 'wheelmoved', 'quit', 'resize', 'textinput',
        'threaderror', 'update', 'visible', 'gamepadaxis', 'gamepadpressed',
        'gamepadreleased', 'joystickadded', 'joystickaxis', 'joystickhat',
        'joystickpressed', 'joystickreleased', 'joystickremoved' }

    Gamestate.registerEvents(events)
    Gamestate.switch(require "ingamestate")
end

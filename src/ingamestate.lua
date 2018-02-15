
local Gamestate = require 'gamestate'

local InGameState = {}

function InGameState:enter()
end

function InGameState:leave()
end


function InGameState:draw()
end

function InGameState:update(dt)
end

function InGameState:mousepressed(x, y, button)
end

function InGameState:mousemoved()
end

function InGameState:mousereleased()
end

function InGameState:keypressed(key)
    if key == 'f1' then
        love.window.setFullscreen(not love.window.getFullscreen( ), "desktop")
    end
end

function InGameState:keyreleased(key)
end

function InGameState:wheelmoved(x, y)
end

return InGameState

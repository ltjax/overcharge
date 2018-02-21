local Gamestate = require 'gamestate'
local State = require 'State'
local Transform = require 'Transform'

local InGameState = {}

function InGameState:enter()
  self.state = State:new()
  
  local camera = self.state.camera
  local s = Transform:scale(love.graphics.getWidth(), love.graphics.getHeight())
  local flip = Transform:new(1, -1, 0, 1)
  local center = Transform:translate(
    0.5,
    0.5)
  
  self.projection = Transform:sequence(s, flip, center) 
end

function InGameState:leave()
end

function InGameState:applyCamera()
  local camera = self.state.camera
  local transform = self.projection:multiply(camera.view)
  love.graphics.translate(transform.dx, transform.dy)
  love.graphics.scale(transform.sx, transform.sy)
  --love.graphics.scale(800/100, 600/100)
end


function InGameState:draw()
  self:applyCamera()
  
  for _, node in ipairs(self.state.nodes) do
    love.graphics.circle('line', node.position.x, node.position.y, 2.0, 32)
  end
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

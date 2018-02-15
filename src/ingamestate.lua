local Gamestate = require 'gamestate'
local State = require 'State'
local Transform = require 'Transform'

local InGameState = {}

function InGameState:enter()
  self.state = State:new()
  
  local camera = self.state.camera
  local s = Transform:scale(5.0, -5.0)
  local t = Transform:translate(
    love.graphics.getWidth() / 2,
    love.graphics.getHeight() / 2)
  
  camera.projection = t:multiply(s)  
end

function InGameState:leave()
end

function InGameState:applyCamera()
  local camera = self.state.camera
  local transform = camera.projection:multiply(camera.view)
  love.graphics.translate(transform.dx, transform.dy)
  love.graphics.scale(transform.sx, transform.sy)
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

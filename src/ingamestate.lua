local Gamestate = require 'gamestate'
local State = require 'State'
local Transform = require 'Transform'

local InGameState = {}

function InGameState:enter()
  self.state = State:new()
  
  local camera = self.state.camera
  local aspectRatio = love.graphics.getWidth() / love.graphics.getHeight()
  local s = Transform:scale(love.graphics.getWidth(), love.graphics.getHeight())
  local flip = Transform:new(1, -1, 0, 1)
  local center = Transform:translate(
    0.5,
    0.5)
  
  self.projection = Transform:sequence(s, flip, center, Transform:scale(1/aspectRatio, 1)) 
end

function InGameState:leave()
end

function InGameState:stateToLove()  
  local camera = self.state.camera
  local transform = self.projection:multiply(camera.view)
  return transform
end

function InGameState:applyCamera()
  local transform = self:stateToLove()
  love.graphics.translate(transform.dx, transform.dy)
  love.graphics.scale(transform.sx, transform.sy)
end

function InGameState:draw()
  self:applyCamera()
  
  for _, node in ipairs(self.state.nodes) do
    love.graphics.circle('line', node.position.x, node.position.y, node.radius, 32)
  end
  
  if self.markedNode ~= nil then
    local n = self.markedNode
    for _, other in ipairs(n.neighbors) do
      love.graphics.line(n.position.x, n.position.y, other.position.x, other.position.y)
    end
  end
  
end

function InGameState:update(dt)
end

function InGameState:mousepressed(x, y, button)
end

function InGameState:mousemoved()
  local mousex, mousey = love.mouse.getPosition()
  local x, y = self:stateToLove():invert():transform(mousex, mousey)
  self.markedNode = self.state:getNodeAt(x, y)
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

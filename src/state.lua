local State = class 'State'
local Node = require 'Node'
local Transform = require 'Transform'

function State:initialize()
  self.nodes = {}
  
  local a = self:addNode(Node:new({x = 0.0, y = 0.0 }))
  local b = self:addNode(Node:new({x = 0.0, y = 10.0 }))
  local c = self:addNode(Node:new({x = 10.0, y = 0.0 }))
  a:connect(b)
  a:connect(c)
  
  self.camera = {
    view = Transform:scale(0.01)
  }
end

function State:addNode(node)
  table.insert(self.nodes, node)
  return node
end

return State
local State = class 'State'
local Node = require 'Node'
local Transform = require 'Transform'
local NodeGenerator = require 'NodeGenerator'
local Set = require 'set'

function State:initialize()
  
--  local a = self:addNode(Node:new({x = 0.0, y = 0.0 }))
--  local b = self:addNode(Node:new({x = 0.0, y = 100.0 }))
--  local c = self:addNode(Node:new({x = 100.0, y = 0.0 }))
--  a:connect(b)
--  a:connect(c
  local w = 100
  self.generator = NodeGenerator:new(-w, -w, 2*w, 2*w, 20)
  
  self.generator:separate()

  
  self:createNodes(self.generator)
  
  self.camera = {
    view = Transform:identity()
  }
end

function State:createNodes(generator)
  self.nodes = {}
  local lookup = {}
  local sourceNodes = generator:getNodes()
  for _, position in ipairs(sourceNodes) do
    lookup[position] = self:addNode(Node:new(position))
  end
  local done = Set:new()
  for _, position in ipairs(sourceNodes) do
    local n = lookup[position]
    generator:forEachNeighbor(position, 100, function(other)
      if not done:contains(other) then
        lookup[other]:connect(n)
      end
    end)
    done:insert(position)
  end
end

function State:flock()
  self.generator:separate()
  self:createNodes(self.generator)
end

function State:unique()
  self.generator:unique(20)
  self:createNodes(self.generator)
end

function State:getNodeAt(x, y)
  for _, node in ipairs(self.nodes) do
    local sqrRadius = node.radius * node.radius
    local dx = x - node.position.x
    local dy = y - node.position.y
    local sqrDistance = dx*dx + dy*dy
    if sqrDistance < sqrRadius then
      return node
    end
  end
  return nil
end

function State:addNode(node)
  table.insert(self.nodes, node)
  return node
end

return State
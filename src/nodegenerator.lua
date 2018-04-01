local NodeGenerator = class 'NodeGenerator'
local Grid = require 'grid'
local v2 = require 'v2'
local Set = require 'set'

local COHESION_DISTANCE = 200
local SEPARATION_DISTANCE = 60
local SQR_SEPARATION_DISTANCE = SEPARATION_DISTANCE * SEPARATION_DISTANCE


local function squareDistance(a, b)
  local dx, dy = a.x - b.x, a.y - b.y
  return dx*dx + dy*dy
end

function NodeGenerator:initialize(x, y, w, h, count)
  self.nodes = {}
  
  for i=1,count do
    table.insert(self.nodes, v2:new(love.math.random()*w+x, love.math.random()*h+y))
  end
end

function NodeGenerator:getNodes()
  return self.nodes
end

function NodeGenerator:flock(scale)
  scale = scale or 1
  local newNodes = {}
  local separatedCount = 0
  for _, node in ipairs(self.nodes) do
    local separationSum = v2:new()
    local separationCount = 0
    self:forEachNeighbor(node, SEPARATION_DISTANCE, function(other)
      separationSum:add(other)
      separationCount = separationCount + 1
    end)
  
    local newNode = node:clone()
    if separationCount > 0 then
      separationSum:scale(1 / separationCount)
      separationSum:subtract(node)
      separationSum:normalize()
      separationSum:scale(-scale)
      newNode:add(separationSum)
      separatedCount = separatedCount + 1
    end
    table.insert(newNodes, newNode)
  end
  self.nodes = newNodes
  return separatedCount
end

function NodeGenerator:unique(radius)
  radius = radius or SEPARATION_DISTANCE
  
  local newNodes = {}
  local skip = Set:new()
  for _, node in ipairs(self.nodes) do
    if not skip:contains(node) then
      self:forEachNeighbor(node, radius, function(other)
        skip:insert(other)
      end)
      table.insert(newNodes, node)
    end
  end
  self.nodes = newNodes
end


function NodeGenerator:separate()
  while self:flock(10) ~= 0 do
  end
end

function NodeGenerator:forEachNeighbor(current, radius, fn)
  local sqrRadius = radius*radius
  for _, node in ipairs(self.nodes) do
    if node ~= current then
      local sqrDistance = squareDistance(current, node)
      if sqrDistance < sqrRadius then
        fn(node, sqrDistance)
      end
    end
  end
end

return NodeGenerator
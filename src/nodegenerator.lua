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

function NodeGenerator:flock()
  local newNodes = {}
  for _, node in ipairs(self.nodes) do
    local cohesionSum = v2:new()
    local cohesionCount = 0
    local separationSum = v2:new()
    local separationCount = 0
    self:forEachNeighbor(node, COHESION_DISTANCE, function(other, sqrDistance)
      cohesionSum:add(other)
      cohesionCount = cohesionCount + 1
      if sqrDistance < SQR_SEPARATION_DISTANCE then
        separationSum:add(other)
        separationCount = separationCount + 1
      end
    end)
  
  
    local newNode = node:clone()
    if cohesionCount > 0 then
      cohesionSum:scale(1 / cohesionCount)
      cohesionSum:subtract(node)
      cohesionSum:normalize()
      newNode:add(cohesionSum)
    end
    if separationCount > 0 then
      separationSum:scale(1 / separationCount)
      separationSum:subtract(node)
      separationSum:normalize()
      separationSum:scale(-3)
      newNode:add(separationSum)
    end
    table.insert(newNodes, newNode)
  end
  self.nodes = newNodes
end

function NodeGenerator:eliminateDuplicates(radius)
  
end


function NodeGenerator:iterateFlocking(count)
  for i=1, count do 
    self:flock()
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
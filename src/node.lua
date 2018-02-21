local Node = class 'Node'

function Node:initialize(position)
  self.position = position
  self.neighbors = {}
  self.radius = 2.0
  self.charge = {}
end

function Node:connect(node)
  assert(node ~= self, "Cannot connect to self")
  table.insert(self.neighbors, node)
  table.insert(node.neighbors, self)
end

return Node

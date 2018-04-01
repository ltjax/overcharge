
local v2 = class 'v2'

function v2:initialize(a, b)
  if a ~= nil then
    if b ~= nil then
      self.x, self.y = a, b
    else
      self.x, self.y = a, a
    end
  else
    self.x, self.y = 0, 0
  end
end

function v2:clone()
  return v2:new(self.x, self.y)
end

function v2:squareDistance(rhs)
  local dx, dy = self.x - rhs.x, self.y - rhs.y
  return dx*dx + dy*dy
end

function v2:squareLength()
  return self.x*self.x + self.y*self.y
end

function v2:length()
  return math.sqrt(self:squareLength())
end

function v2:subtract(other)
  self.x = self.x - other.x
  self.y = self.y - other.y
end

function v2:scale(rhs)
  self.x = self.x * rhs
  self.y = self.y * rhs
end

function v2:normalize()
  if self.x ~= 0 or self.y ~= 0 then
    self:scale(1 / self:length())
  end
end

function v2:add(other)
  self.x = self.x + other.x
  self.y = self.y + other.y
end

return v2

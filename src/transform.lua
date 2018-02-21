local class = require 'middleclass'
local Transform = class 'Transform'

function Transform:initialize(sx, sy, dx, dy)
  self.sx = sx
  self.sy = sy
  self.dx = dx
  self.dy = dy
end

function Transform.static:identity()
  return Transform:new(1.0, 1.0, 0, 0)
end

function Transform.static:scale(sx, sy)
  if sy == nil then
    sy = sx
  end
  
  return Transform:new(sx, sy, 0, 0)
end

function Transform.static:translate(x, y)
  return Transform:new(1, 1, x, y)
end

function Transform:invert()
  return Transform:new(1 / self.sx,
    1 / self.sy,
    -self.dx / self.sx,
    -self.dy / self.sy)
end

function Transform:transform(x, y)
  local tx = self.sx * x + self.dx
  local ty = self.sy * y + self.dy
  return tx, ty
end

function Transform:multiply(transform)
  return Transform:new(self.sx * transform.sx,
    self.sy * transform.sy,
    self.sx * transform.dx + self.dx,
    self.sy * transform.dy + self.dy)
end

function Transform.static:sequence(...)
  local arg = {...}
  local result = Transform:identity()
  for _, rhs in ipairs(arg) do
    result = result:multiply(rhs)
  end
  return result
end


return Transform
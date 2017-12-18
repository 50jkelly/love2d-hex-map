local PI = 3.14159265359
local this = {}
local size

-- Hex dimensions

function this.set_size(_size)
  size = _size
end

function this.get_size()
  return size
end

function this.get_width()
  return size * 2
end

function this.get_height()
  return math.sqrt(3)/2 * width
end

-- Hex corner

function this.get_corner(center, i)
  local angle_degrees = 60 * i
  local angle_radians = PI / 180 * angle_degrees
  local point = {}
  point.x = center.x + size * math.cos(angle_radians)
  point.y = center.y + size * math.sin(angle_radians)
  return point
end

return this
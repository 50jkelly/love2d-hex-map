local this = {}

-- Conversion between coordinate systems

function this.cube_to_axial(cube)
  local hex = {}
  hex.q = cube.x
  hex.r = cube.z
  return hex
end

function this.axial_to_cube(hex)
  local cube = {}
  cube.x = hex.q
  cube.z = hex.r
  cube.y = -cube.x-cube.z
  return cube
end

-- Get coordinates of neighbouring hex

function this.cube_neighbour(cube, direction)
  local directions = {}
  directions.north = {}
  directions.north.x = 0
  directions.north.y = 1
  directions.north.z = -1
  
  directions.north_east = {}
  directions.north_east.x = 1
  directions.north_east.y = 0
  directions.north_east.z = -1
  
  directions.south_east = {}
  directions.south_east.x = 1
  directions.south_east.y = -1
  directions.south_east.z = 0
  
  directions.south = {}
  directions.south.x = 0
  directions.south.y = -1
  directions.south.z = 1
  
  directions.south_west = {}
  directions.south_west.x = -1
  directions.south_west.y = 0
  directions.south_west.z = 1
  
  directions.north_west = {}
  directions.north_west.x = -1
  directions.north_west.y = 1
  directions.north_west.z = 0
  
  local result = {}
  result.x = cube.x + directions[direction].x
  result.y = cube.x + directions[direction].y
  result.z = cube.x + directions[direction].z
  return result
end

function this.axial_neighbour(hex, direction)
  local directions = {}
  directions.north = {}
  directions.north.q = 0
  directions.north.r = -1
  
  directions.north_east = {}
  directions.north_east.q = 1
  directions.north_east.r = -1
  
  directions.south_east = {}
  directions.south_east.q = 1
  directions.south_east.r = 0
  
  directions.south = {}
  directions.south.q = 0
  directions.south.r = 1
  
  directions.south_west = {}
  directions.south_west.q = -1
  directions.south_west.r = 1
  
  directions.north_west = {}
  directions.north_west.q = -1
  directions.north_west.r = 0
  
  local result = {}
  result.q = hex.q + directions[direction].q
  result.r = hex.r + directions[direction].r
  return result
end

-- Get distance between hexes

function this.cube_distance(a, b)
  return (
    math.abs(a.x - b.x) +
    math.abs(a.y - b.y) +
    math.abs(a.z - b.z)) / 2
end

function this.axial_distance(a, b)
  local cube_a = this.axial_to_cube(a)
  local cube_b = this.axial_to_cube(b)
  return this.cube_distance(cube_a, cube_b)
end
  
-- Return all hexes in a line between two hexes

function this.cube_line(a, b)
  local function linear_interpolation(a, b, t)
    return a + (b - a) * t
  end
  
  local function cube_linear_interpolation(a, b, t)
    local cube = {}
    cube.x = linear_interpolation(a.x, b.x, t)
    cube.y = linear_interpolation(a.y, b.y, t)
    cube.z = linear_interpolation(a.z, b.z, t)
    return cube
  end
  
  local function round(n)
    return math.floor(n + 0.5)
  end
  
  local function cube_round(cube)
    local rx = round(cube.x)
    local ry = round(cube.y)
    local rz = round(cube.z)
    
    local x_diff = math.abs(rx - cube.x)
    local y_diff = math.abs(ry - cube.y)
    local z_diff = math.abs(rz - cube.z)
    
    if (x_diff > y_diff and x_diff > z_diff) then
      rx = -ry - rz
    elseif (y_diff > z_diff) then
      ry = -rx - rz
    else
      rz = -rx - ry
    end
    
    local out = {}
    out.x = rx
    out.y = ry
    out.z = rz
    
    return out
  end
  
  local N = this.cube_distance(a, b)
  local results = {}
  for i=0,N do
    table.insert(results, cube_round(cube_linear_interpolation(a, b, 1.0/N * i)))
  end
  
  return results
end

function this.axial_line(a, b)
  local cube_a = this.axial_to_cube(a)
  local cube_b = this.axial_to_cube(b)
  local cube_results = this.cube_line(cube_a, cube_b)
  
  local results = {}
  for i,cube in ipairs(cube_results) do
    table.insert(results, cube_to_axial(cube))
  end
  
  return results
end

return this
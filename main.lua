local hex = require 'hex'
local grid = require 'grid'

function love.draw()
  local text_y = 200
  
  local a = {}
  a.x = 0
  a.y = 0
  a.z = 0
  
  local b = {}
  b.x = -2
  b.y = 3
  b.z = -1
  
  for i,cube in ipairs(grid.cube_line(a, b)) do
    love.graphics.print(
      cube.x .. ',' .. cube.y .. ',' .. cube.z,
      400,
      text_y)
    
    text_y = text_y + 20
  end
end


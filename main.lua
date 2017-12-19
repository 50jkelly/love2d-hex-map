local grid = require 'grid'

local hex_image

function love.load()
  hex_image = love.graphics.newImage('HK-Fantasyland/HK - Blank/HK_blank_003.png')
  love.window.setMode(800, 600, { resizable=true })
  love.window.maximize()
end

function love.draw()
  local h = {}
  
  for i = 1, 5 do
    for j = 1, 5 do
      local offset = {}
      offset.row = i
      offset.col = j
      
      local new_cube = grid.offset_to_cube(offset)
      table.insert(h, grid.cube_to_axial(new_cube))
    end
  end
    
  grid.set_size(95)
  
  local mouse_x, mouse_y = love.mouse.getPosition()
  local mouse_hex = grid.pixel_to_axial(mouse_x, mouse_y)
  
  for i, e in ipairs(h) do
    local position = grid.axial_to_pixel(e)
    
    if (e.q == mouse_hex.q and e.r == mouse_hex.r) then
      love.graphics.setColor(0,0,255)
    else
      love.graphics.setColor(255,255,255)
    end
  
    love.graphics.draw(hex_image, position.x - grid.get_size(), position.y - grid.get_size())
  end
  
  love.graphics.setColor(255,0,0)
  love.graphics.circle('fill', mouse_x, mouse_y, 3)
  love.graphics.print(mouse_hex.q .. ',' .. mouse_hex.r, 400, 20)
end


local fluent = require 'fluent'

local hex_image

function love.load()
	hex_image = love.graphics.newImage('HK-Fantasyland/HK - Blank/HK_blank_003.png')
	fluent.set_size(95)
	love.window.setMode(800, 600, { resizable=true })
	love.window.maximize()
end

function love.draw()
	-- Create a table of hexes in the given coordinate range
  
	local grid = fluent.instance().from(1, 1).to(5, 5)

	-- Obtain the mouse position and find the currently hovered hex

	local mouse_x, mouse_y = love.mouse.getPosition()
	local mouse_hex = fluent.instance().at_mouse(mouse_x, mouse_y).first().as('axial')

	-- Draw the hexes

	grid.for_each(function()
		if (grid.equals(mouse_hex)) then
			love.graphics.setColor(0,0,255)
		else
			love.graphics.setColor(255,255,255)
		end

		love.graphics.draw(hex_image, grid.draw_position())
	end)

	love.graphics.setColor(255,0,0)
	love.graphics.circle('fill', mouse_x, mouse_y, 3)
	love.graphics.print(mouse_hex.get().q .. ',' .. mouse_hex.get().r, 400, 20)
end


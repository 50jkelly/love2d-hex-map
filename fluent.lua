local grid = require 'grid'
local this = {}

-- Helper functions

function this.set_size(size)
	grid.set_size(size)
end

function this.get_size()
	return grid.get_size()
end

function this.instance()
	local instance = {}
	
	-- Chaining functions

	function instance.from(startX, startY)
		instance.startX = startX
		instance.startY = startY
		return instance
	end

	function instance.to(endX, endY)
		instance.endX = endX
		instance.endY = endY
				
		instance.reset()
		
		for x = instance.startX, instance.endX do
			for y = instance.startY, instance.endY do
				local offset = {}
				offset.row = x
				offset.col = y
				
				local cube = grid.offset_to_cube(offset)
				
				table.insert(instance.h.cube, cube)
				table.insert(instance.h.axial, grid.cube_to_axial(cube))
				table.insert(instance.h.pixel, grid.cube_to_pixel(cube))
			end
		end
		
		return instance
	end

	function instance.at_mouse(x, y)
		local axial = grid.pixel_to_axial(x, y)
		
		instance.reset()
		
		table.insert(instance.h.axial, axial)
		table.insert(instance.h.cube, grid.axial_to_cube(axial))
		table.insert(instance.h.pixel, grid.axial_to_pixel(axial))
		
		return instance
	end

	-- Terminal functions

	function instance.get(as)
		return instance.h[as]
	end

	function instance.first(as)
		return instance.h[as][1]
	end

	function instance.at(as, i)
		return instance.h[as][i]
	end

	function instance.reset()
		instance.h = {}
		instance.h.axial = {}
		instance.h.pixel = {}
		instance.h.cube = {}
	end
		
	return instance
end

return this
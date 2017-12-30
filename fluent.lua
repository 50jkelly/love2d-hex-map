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
	local current = 'axial'
	local index = -1
	local h = {}
	
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
				
				table.insert(h.cube, cube)
				table.insert(h.axial, grid.cube_to_axial(cube))
				table.insert(h.pixel, grid.cube_to_pixel(cube))
			end
		end
		
		return instance
	end

	function instance.at_mouse(x, y)
		local axial = grid.pixel_to_axial(x, y)
		
		instance.reset()
		
		table.insert(h.axial, axial)
		table.insert(h.cube, grid.axial_to_cube(axial))
		table.insert(h.pixel, grid.axial_to_pixel(axial))
		
		return instance
	end

	function instance.as(as)
		current = as
		return instance
	end

	function instance.first()
		index = 1
		return instance
	end

	function instance.nth(i)
		index = i
		return instance
	end
	
	function instance.for_each(callback)
		for i, _ in ipairs(instance.get()) do
			instance.nth(i)
			callback()
		end
		return instance
	end
	
	-- Terminal functions

	function instance.get()
		if index == -1 then
			return h[current]
		else
			return h[current][index]
		end
	end
	
	function instance.equals(other)
		local old_a = instance.get_as()
		local old_b = other.get_as()
		
		local a = instance.as('cube').get()
		local b = other.as('cube').get()
		
		local result =
			a.x == b.x and
			a.y == b.y and
			a.z == b.z
			
		instance.as(old_a)
		other.as(old_b)
		
		return result
	end

	function instance.reset()
		h = {}
		h.axial = {}
		h.pixel = {}
		h.cube = {}
	end
	
	function instance.draw_position()
		local old_as = instance.get_as()
		
		local x, y =
			instance.as('pixel').get().x - this.get_size(),
			instance.get().y - this.get_size()
			
		instance.as(old_as)
			
		return x, y
	end
	
	function instance.get_as()
		return current
	end
		
	return instance
end

return this
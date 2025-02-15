local Shape = {}
Shape.__index = Shape

local newPoint = require("class.point")

function Shape.new(settings)
	local instance    = setmetatable({}, Shape)
	instance.x        = settings.x or 0
	instance.y        = settings.y or 0
	instance.w        = settings.w or 100
	instance.h        = settings.h or 50
	instance.image    = settings.image
	instance.rotation = settings.rotation
	instance.offsetX  = settings.offsetX
	instance.offsetY  = settings.offsetY
	instance.points   = {}
	for i = 1, #settings.points do
		instance.points[i] = newPoint({ x = settings.x, y = settings.y })
	end

	return instance
end

function Shape:sync(x, y)
	self.x = x
	self.y = y
	for _, point in ipairs(self.points) do
		point:sync(x, y)
	end
end

function Shape:draw()
	love.graphics.draw(self.image, self.x, self.y, self.rotation)
end

return Shape

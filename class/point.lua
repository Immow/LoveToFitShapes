local Point = {}
Point.__index = Point

function Point.new(settings)
	local instance   = setmetatable({}, Point)
	instance.x       = settings.x or 0
	instance.y       = settings.y or 0
	instance.offsetX = settings.offsetX
	instance.offsetY = settings.offsetY
	instance.r       = settings.r or 5
	return instance
end

function Point:sync(x, y)
	self.x = x + self.offsetX
	self.y = y + self.offsetY
end

function Point:draw()
	love.graphics.circle("fill", self.x, self.y, self.r)
end

return Point

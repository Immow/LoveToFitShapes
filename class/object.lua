local Object = {}
Object.__index = Object

---@class Object
function Object.new(settings)
	local instance         = setmetatable({}, Object)
	instance.x             = settings.x or 0
	instance.y             = settings.y or 0
	instance.rotationIndex = settings.rotationIndex or 0
	instance.image         = settings.image
	instance.anchorPoints  = settings.anchorPoints or error("no anchorPoints")
	instance.cellsize      = settings.cellsize or 50

	return instance
end

local function getCentroid(cells)
	local largestX = 0
	local largestY = 0
	for _, value in ipairs(cells) do
		if value.x > largestX then largestX = value.x end
		if value.y > largestY then largestY = value.y end
	end

	return { x = (largestX) * 50 / 2, y = (largestY) * 50 / 2 }
end

function Object:wheelmoved(x, y)
	-- if y > 0 then
	-- 	self.angle = self.angle + (math.pi / 2) -- Rotate 90 degrees clockwise
	-- elseif y < 0 then
	-- 	self.angle = self.angle - (math.pi / 2) -- Rotate 90 degrees counterclockwise
	-- end
end

function Object:mousepressed(x, y, button, isTouch)
	local ox, oy = self.image:getWidth() / 2, self.image:getHeight() / 2
	print(ox, oy)
end

function Object:mousereleased(x, y, button, isTouch)

end

function Object:update(dt)

end

function Object:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(self.rotationIndex)

	local ox, oy = self.image:getWidth() / 2, self.image:getHeight() / 2

	love.graphics.push()
	love.graphics.translate(self.x + ox, self.y + oy)
	self.rotation = -self.rotationIndex * (math.pi / 2)
	love.graphics.rotate(self.rotation)
	love.graphics.translate(-ox, -oy)
	love.graphics.draw(self.image, 0, 0)

	love.graphics.setColor(0, 0, 1, 1)
	love.graphics.circle("fill", ox, oy, 5)

	love.graphics.pop()
	love.graphics.setColor(1, 0, 0, 1)
	local offsetX = 0
	local offsetY = 0

	for _, anchor in ipairs(self.anchorPoints[self.rotationIndex + 1]) do
		local shapeCenter = getCentroid(self.anchorPoints[self.rotationIndex + 1])
		offsetX = ox - shapeCenter.x
		offsetY = oy - shapeCenter.y

		love.graphics.circle("fill", (anchor.x - 1) * self.cellsize + self.x + offsetX + 25,
			(anchor.y - 1) * self.cellsize + self.y + offsetY + 25, 5)
	end

	love.graphics.setColor(1, 1, 0, 1)
	love.graphics.circle("fill", self.x, self.y, 5) -- draw origin of image
end

return Object

local Shape = {}
Shape.__index = Shape

---@class Object
function Shape.new(settings)
	local instance = setmetatable({}, Shape)
	instance.x = settings.x or 0
	instance.y = settings.y or 0
	instance.w = settings.w or error("no width")
	instance.h = settings.h or error("no height")
	instance.rotationIndex = settings.rotationIndex or 0
	instance.image = settings.image
	instance.anchorPoints = settings.anchorPoints or error("no anchorPoints")
	instance.id = settings.id or 0
	instance.active = false
	instance.state = 1
	instance.states = settings.states

	instance.centroids = {}
	instance.anchorPointsInPixels = {}
	for i = 1, #instance.anchorPoints do
		instance.centroids[i] = Shape.computeCentroid(instance.anchorPoints[i])
		instance.anchorPointsInPixels[i] = {}

		for j = 1, #instance.anchorPoints[i] do
			instance.anchorPointsInPixels[i][j] = { x = 0, y = 0 }
		end
	end

	return instance
end

function Shape:sync()
	local ox, oy = self.w / 2, self.h / 2
	for i, anchor in ipairs(self.anchorPoints[self.rotationIndex + 1]) do
		local shapeCenter = self.centroids[self.rotationIndex + 1]
		local offsetX = ox - shapeCenter.x
		local offsetY = oy - shapeCenter.y
		self.anchorPointsInPixels[self.rotationIndex + 1][i].x = (anchor.x - 1) * CELLSIZE + self.x + offsetX +
			CELLSIZE / 2
		self.anchorPointsInPixels[self.rotationIndex + 1][i].y = (anchor.y - 1) * CELLSIZE + self.y + offsetY +
			CELLSIZE / 2
	end
end

function Shape.computeCentroid(cells)
	local largestX = 0
	local largestY = 0
	for _, value in ipairs(cells) do
		if value.x > largestX then largestX = value.x end
		if value.y > largestY then largestY = value.y end
	end
	return { x = (largestX) * CELLSIZE / 2, y = (largestY) * CELLSIZE / 2 }
end

function Shape:wheelmoved(x, y)

end

function Shape:mousepressed(x, y, button, isTouch)

end

function Shape:mousereleased(x, y, button, isTouch)

end

function Shape:update(dt)
	self.states[self.state]:update(dt)
end

function Shape:draw()
	-- draw image
	love.graphics.setColor(1, 1, 1, 1)
	local ox, oy = self.w / 2, self.h / 2

	love.graphics.push()
	love.graphics.translate(self.x + ox, self.y + oy)
	self.rotation = -self.rotationIndex * (math.pi / 2)
	love.graphics.rotate(self.rotation)
	love.graphics.translate(-ox, -oy)
	-- love.graphics.draw(self.image, 0, 0)
	self.states[self.state]:draw(self.image)

	-- draw centroid of shape
	-- love.graphics.setColor(0, 0, 1, 1)
	-- love.graphics.circle("fill", ox, oy, 5)

	love.graphics.pop()
	-- love.graphics.setColor(1, 0, 0, 1)
	-- draw anchorPoints
	-- for _, anchor in ipairs(self.anchorPointsInPixels[self.rotationIndex + 1]) do
	-- 	love.graphics.circle("fill", anchor.x, anchor.y, 3)
	-- end

	-- draw origin of shape
	-- love.graphics.setColor(1, 1, 0, 1)
	-- love.graphics.circle("fill", self.x, self.y, 5)
end

return Shape

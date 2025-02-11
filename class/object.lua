local Object = {}
Object.__index = Object

---@class Object
function Object.new(settings)
	local instance = setmetatable({}, Object)
	instance.x = settings.x or 0
	instance.y = settings.y or 0
	instance.rotationIndex = settings.rotationIndex or 0
	instance.image = settings.image
	instance.anchorPoints = settings.anchorPoints or error("no anchorPoints")
	instance.id = settings.id or 0
	instance.active = false

	instance.centroids = {}
	for i = 1, #instance.anchorPoints do
		instance.centroids[i] = Object.computeCentroid(instance.anchorPoints[i])
	end

	return instance
end

function Object:getAnchorPointsInPixels(rotationIndex)
	local points = {}
	local shapeCenter = self.centroids[rotationIndex + 1] -- Use precomputed centroid
	local ox, oy = self.image:getWidth() / 2, self.image:getHeight() / 2
	local offsetX = ox - shapeCenter.x
	local offsetY = oy - shapeCenter.y

	for i, anchor in ipairs(self.anchorPoints[rotationIndex + 1]) do
		local x = (anchor.x - 1) * CELLSIZE + self.x + offsetX + CELLSIZE / 2
		local y = (anchor.y - 1) * CELLSIZE + self.y + offsetY + CELLSIZE / 2
		table.insert(points, { x = x, y = y })
	end

	return points
end

function Object:AABB(mouse, points)
	for _, point in ipairs(points) do
		local xRegion = point.x - CELLSIZE / 2 <= mouse.x and point.x + CELLSIZE / 2 >= mouse.x
		local yRegion = point.y - CELLSIZE / 2 <= mouse.y and point.y + CELLSIZE / 2 >= mouse.y
		if xRegion and yRegion then return true end
	end

	return false
end

function Object.computeCentroid(cells)
	local largestX = 0
	local largestY = 0
	for _, value in ipairs(cells) do
		if value.x > largestX then largestX = value.x end
		if value.y > largestY then largestY = value.y end
	end
	return { x = (largestX) * CELLSIZE / 2, y = (largestY) * CELLSIZE / 2 }
end

function Object:wheelmoved(x, y)

end

function Object:mousepressed(x, y, button, isTouch)
	-- local anchorPointsPixels = self:getAnchorPointsInPixels(self.rotationIndex) -- Get pixel positions
	-- if self:AABB({ x = x, y = y }, anchorPointsPixels) then

	-- end
end

function Object:mousereleased(x, y, button, isTouch)

end

function Object:update(dt)

end

function Object:draw()
	love.graphics.setColor(1, 1, 1, 1)
	-- DEBUG.add({ x = self.x, y = self.y })
	-- DEBUG.add({ rotationIndex = self.rotationIndex, id = self.id })
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

	for i, anchor in ipairs(self.anchorPoints[self.rotationIndex + 1]) do
		local shapeCenter = self.centroids[self.rotationIndex + 1]
		local offsetX = ox - shapeCenter.x
		local offsetY = oy - shapeCenter.y
		local x = (anchor.x - 1) * CELLSIZE + self.x + offsetX + CELLSIZE / 2
		local y = (anchor.y - 1) * CELLSIZE + self.y + offsetY + CELLSIZE / 2

		love.graphics.circle("fill", x, y, 5)
		-- DEBUG.add({ ["cell" .. i] = { x = x, y = y } })
	end

	love.graphics.setColor(1, 1, 0, 1)
	love.graphics.circle("fill", self.x, self.y, 5) -- draw origin of image
end

return Object

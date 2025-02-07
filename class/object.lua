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

function Object:getAnchorPoints()
	local anchorPositions = {}

	-- Get image center
	local ox, oy = self.image:getWidth() / 2, self.image:getHeight() / 2

	-- Precompute rotation values
	local cosR = math.cos(self.rotationIndex * (math.pi / 2))
	local sinR = math.sin(self.rotationIndex * (math.pi / 2))

	-- Iterate over each anchor point
	for _, anchor in ipairs(self.anchorPoints[1]) do
		-- Convert from grid to local space (relative to object's center)
		local localX = (anchor.x - 1) * self.cellsize - ox
		local localY = (anchor.y - 1) * self.cellsize - oy

		-- Apply rotation formula
		local rotatedX = localX * cosR - localY * sinR
		local rotatedY = localX * sinR + localY * cosR

		-- Convert back to world space
		local worldX = rotatedX + self.x + ox
		local worldY = rotatedY + self.y + oy

		-- Store result
		table.insert(anchorPositions, { x = worldX, y = worldY })
	end

	return anchorPositions
end

function Object:wheelmoved(x, y)
	-- if y > 0 then
	-- 	self.angle = self.angle + (math.pi / 2) -- Rotate 90 degrees clockwise
	-- elseif y < 0 then
	-- 	self.angle = self.angle - (math.pi / 2) -- Rotate 90 degrees counterclockwise
	-- end
end

function Object:mousepressed(x, y, button, isTouch)
	print(Tprint(self:getAnchorPoints()))
end

function Object:mousereleased(x, y, button, isTouch)

end

function Object:update(dt)

end

function Object:draw()
	love.graphics.print(self.rotationIndex)
	love.graphics.setColor(1, 1, 1, 1)
	local ox, oy = self.image:getWidth() / 2, self.image:getHeight() / 2

	love.graphics.push()
	love.graphics.translate(self.x + ox, self.y + oy)
	self.rotation = self.rotationIndex * (math.pi / 2)
	love.graphics.rotate(self.rotation)
	love.graphics.translate(-ox, -oy)
	love.graphics.draw(self.image, 0, 0)

	love.graphics.setColor(1, 0, 0, 1)
	for _, anchor in ipairs(self.anchorPoints[1]) do
		love.graphics.circle("fill", (anchor.x - 1) * self.cellsize + self.cellsize / 2,
			(anchor.y - 1) * self.cellsize + self.cellsize / 2, 5)
	end

	love.graphics.setColor(0, 0, 1, 1)
	love.graphics.circle("fill", ox, oy, 5)

	love.graphics.pop()
end

return Object

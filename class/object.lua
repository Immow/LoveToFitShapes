local Object = {}
Object.__index = Object

---@class Object
function Object.new(settings)
	local instance        = setmetatable({}, Object)
	instance.x            = settings.x or 0
	instance.y            = settings.y or 0
	instance.rotation     = settings.rotation or 1
	instance.image        = settings.image
	instance.anchorPoints = settings.anchorPoints or error("no anchorPoints")

	return instance
end

function Object:wheelmoved(x, y)
	-- if y > 0 then
	-- 	self.angle = self.angle + (math.pi / 2) -- Rotate 90 degrees clockwise
	-- elseif y < 0 then
	-- 	self.angle = self.angle - (math.pi / 2) -- Rotate 90 degrees counterclockwise
	-- end
end

function Object:mousepressed(x, y, button, isTouch)

end

function Object:mousereleased(x, y, button, isTouch)

end

function Object:update(dt)

end

local function calculateShapeSize(anchorPoints)
	local maxX, maxY = 0, 0

	for _, anchor in ipairs(anchorPoints) do
		maxX = math.max(maxX, anchor.x * 50)
		maxY = math.max(maxY, anchor.y * 50)
	end

	return maxX, maxY
end

function Object:draw()
	love.graphics.print(self.rotation)
	love.graphics.setColor(1, 1, 1, 1)
	local ox, oy = 0, 0

	if self.rotation > 1 and self.rotation < 4 then
		oy = self.image:getHeight()
	end

	if self.rotation == 2 or self.rotation == 4 then
		ox = self.image:getWidth()
	end

	love.graphics.draw(self.image, self.x, self.y, -(self.rotation - 1) * (math.pi / 2), 1, 1, ox, oy)

	love.graphics.setColor(1, 0, 0, 1)
	-- love.graphics.circle("fill", self.x + 10, self.y, 5)
	for _, anchor in ipairs(self.anchorPoints[self.rotation]) do
		love.graphics.circle("fill", self.x + ((anchor.x) * 50), self.y + ((anchor.y) * 50), 5)
		-- for _, coord in ipairs(anchor) do
		--     -- print(coord.x)
		-- end
	end
	love.graphics.setColor(0, 0, 1, 1)
	love.graphics.circle("fill", self.x, self.y, 5)
end

return Object

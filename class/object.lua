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
	local ox, oy = calculateShapeSize(self.anchorPoints[self.rotation])
	ox, oy = ox / 2, oy / 2

	love.graphics.translate(self.x + ox, self.y + oy)
	-- self.rotation = self.rotationIndex * (math.pi / 2)
	love.graphics.rotate(-(self.rotation - 1) * (math.pi / 2))
	love.graphics.translate(-ox, -oy)

	love.graphics.draw(self.image)

	love.graphics.origin()
	love.graphics.translate(self.x, self.y)

	love.graphics.rectangle("line", 0, 0, ox * 2, oy * 2)

	love.graphics.setColor(1, 0, 0, 1)
	-- love.graphics.circle("fill", self.x + 10, self.y, 5)
	for _, anchor in ipairs(self.anchorPoints[self.rotation]) do
		love.graphics.circle("fill", 50 / 2 + ((anchor.x - 1) * 50), 50 / 2 + ((anchor.y - 1) * 50), 5)
		-- for _, coord in ipairs(anchor) do
		-- 	-- print(coord.x)
		-- end
	end
	love.graphics.setColor(0, 0, 1, 1)
	love.graphics.circle("fill", 0, 0, 5)
end

return Object

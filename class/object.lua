local Object = {}
Object.__index = Object

---@class Object
function Object.new(settings)
	local instance        = setmetatable({}, Object)
	instance.x            = settings.x or 0
	instance.y            = settings.y or 0
	instance.image        = settings.image
	instance.anchorPoints = settings.anchorPoints or error("no anchorPoints")
	return instance
end

function Object:mousepressed(x, y, button, isTouch)

end

function Object:mousereleased(x, y, button, isTouch)

end

function Object:update(dt)

end

function Object:draw()
	love.graphics.draw(self.image, self.x, self.y)
	-- for _, point in ipairs(self.anchorPoints) do
	-- 	love.graphics.circle("fill", point.x + self.x, point.y + self.y, 5)
	-- end
end

return Object

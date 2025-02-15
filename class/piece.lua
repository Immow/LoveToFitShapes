local shapeTypes = require("shapeTypes")

local Object = {}
Object.__index = Object

---@class Object
function Object.new(initials)
	local instance = setmetatable({}, Object)
	instance.id = initials.id or 0
	instance.active = false

	instance.shapeTypeId = initials.shapeTypeId or 1

	instance.x = initials.x or 0
	instance.y = initials.y or 0
	instance.rotation = initials.rotation or 1

	instance.imageAsset = ''
	instance.imageX = 0
	instance.imageY = 0
	instance.anchorpoints = {}

	print(instance.shapeTypeId)

	instance.shapeType = shapeTypes[instance.shapeTypeId]

	print(Tprint(instance.shapeType))

	return instance
end

function Object:updateState()
	print(self.x)

	self.imageAsset = self.shapeType.imageAsset
	self.imageOffsetX = self.shapeType.rotations[self.rotation].imageOffset.x + self.x
	self.imageOffsetY = self.shapeType.rotations[self.rotation].imageOffset.y + self.y

	local apts = self.shapeType.rotations[self.rotation].anchorpoints
	for i = 1, #self.shapeType.rotations[self.rotation].anchorpoints do
		self.anchorpoints[i] = {}
		print(apts[i].x)
		print("cow")
		print(self.x)
		self.anchorpoints[i].x = apts[i].x + self.x
		self.anchorpoints[i].y = apts[i].y + self.y
	end
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
	-- draw the image
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(self.imageAsset, self.imageX, self.imageY)

	-- draw center
	love.graphics.setColor(0, 0, 1, 1)
	love.graphics.circle("fill", self.x, self.y, 5)

	-- draw imagepost
	love.graphics.setColor(1, 1, 0, 1)
	love.graphics.circle("fill", self.imageX, self.imageY, 5)

	-- draw anchorpoints
	for i = 1, #self.anchorpoints do
		love.graphics.circle("fill", self.anchorpoints[i].x, self.anchorpoints[i].y, 5)
	end 

	-- reset color
	love.graphics.setColor(1, 1, 1, 1)
end

return Object

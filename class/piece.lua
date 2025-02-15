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
	instance.radians = 0

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

	self.imageAsset = Assets[self.shapeType.imageAsset]
	self.imageX = self.shapeType.rotations[self.rotation].imageOffset.x + self.x
	self.imageY = self.shapeType.rotations[self.rotation].imageOffset.y + self.y
	self.radians = -(self.rotation -1) * (math.pi / 2)

	local apts = self.shapeType.rotations[self.rotation].anchorpoints
	for i = 1, #apts do
		self.anchorpoints[i] = {}
		self.anchorpoints[i].x = apts[i].offsetX + self.x
		self.anchorpoints[i].y = apts[i].offsetY + self.y
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
	love.graphics.draw(self.imageAsset, self.imageX, self.imageY, self.radians)

	-- draw center
	love.graphics.setColor(0, 0, 1, 1)
	love.graphics.circle("fill", self.x, self.y, 5)

	-- draw imagepost
	love.graphics.setColor(1, 1, 0, 1)
	love.graphics.circle("fill", self.imageX, self.imageY, 5)

	-- draw anchorpoints
	love.graphics.setColor(1, 0, 0, 1)
	for i = 1, #self.anchorpoints do
		love.graphics.circle("fill", self.anchorpoints[i].x, self.anchorpoints[i].y, 5)
	end 

	-- reset color
	love.graphics.setColor(1, 1, 1, 1)
end

return Object

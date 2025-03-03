local Button = {}
Button.__index = Button

local buttons = {}
function Button.new(settings)
	local instance = setmetatable({}, Button)
	instance.x     = settings.x or 0
	instance.y     = settings.y or 0
	instance.w     = settings.w or 200
	instance.h     = settings.h or 75
	instance.text  = settings.text or "myButton"
	instance.hover = false
	instance.color = settings.color or { hover = { 1, 0, 0, 1 }, idle = { 1, 1, 1, 1 } }
	instance.state = settings.state
	instance.fn    = settings.fn or function() print(instance.text) end

	if not buttons[instance.state] then
		buttons[instance.state] = {}
	end

	table.insert(buttons[instance.state], instance)

	return instance
end

function Button:isMouseOnButton(mx, my)
	local xRegion = self.x <= mx and self.x + self.w >= mx
	local yRegion = self.y <= my and self.y + self.h >= my
	return xRegion and yRegion
end

function Button:mousepressed(mx, my, mouseButton)
	if mouseButton ~= 1 then return end

	local stateButtons = buttons[StateManager:getState()]
	if not stateButtons then return end

	for _, button in ipairs(stateButtons) do
		if button:isMouseOnButton(mx, my) then
			button.fn()
			break
		end
	end
end

function Button:draw()
	local stateButtons = buttons[StateManager:getState()]
	if not stateButtons then return end

	for _, button in ipairs(stateButtons) do
		love.graphics.setColor(button.hover and button.color.hover or button.color.idle)
		love.graphics.rectangle("line", button.x, button.y, button.w, button.h)
		love.graphics.print(button.text, button.x, button.y)
	end

	love.graphics.setColor(1, 1, 1)
end

function Button:update(dt)
	local mx, my = love.mouse.getPosition()
	local stateButtons = buttons[StateManager:getState()]
	if not stateButtons then return end

	for _, button in ipairs(stateButtons) do
		button.hover = button:isMouseOnButton(mx, my)
	end
end

return Button

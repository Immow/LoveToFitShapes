local Lovemeasure = {}
local font = love.graphics.getFont()
local baseline = font:getBaseline()

function Lovemeasure:draw()
	local mx, my = love.mouse.getPosition()
	love.graphics.setColor(0, 0, 0, 1)
	local width = font:getWidth(mx) + font:getWidth(my) + font:getWidth("x:  y: ") + 5
	local height = font:getHeight() + math.abs(baseline)
	love.graphics.rectangle("fill", mx + 10, my - 5, width + 20, height)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print("x: " .. mx .. " y: " .. my, mx + 20, my)
end

return Lovemeasure

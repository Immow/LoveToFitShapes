local DebugDraw = {}

DebugDraw.data = {}

function DebugDraw.add(tbl)
	table.insert(DebugDraw.data, tbl)
end

function DebugDraw.drawTable(tbl, x, y, indent)
	indent = indent or 0
	local spacing = 15
	local startX = x + (indent * 20)

	for key, value in pairs(tbl) do
		local displayString = ""
		if type(key) == "number" then
			displayString = "" -- Skip numbering
		else
			displayString = tostring(key) .. " = "
		end

		if type(value) == "table" then
			love.graphics.print(displayString, startX, y)
			y = DebugDraw.drawTable(value, x, y + spacing, indent + 1) -- Recursive call
		else
			love.graphics.print(displayString .. tostring(value), startX, y)
			y = y + spacing
		end
	end

	return y
end

function DebugDraw.draw(x, y)
	love.graphics.setColor(1, 1, 1, 1)
	local startY = y or 10
	for _, tbl in ipairs(DebugDraw.data) do
		startY = DebugDraw.drawTable(tbl, x or 10, startY)
	end
	love.graphics.setColor(1, 1, 1, 1)
	DebugDraw.data = {}
end

return DebugDraw

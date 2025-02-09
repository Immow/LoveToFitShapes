local DebugDraw = {}

DebugDraw.data = {}

---Use this to add data you want to display
---@param tbl any
function DebugDraw.add(tbl)
	if type(tbl) ~= "table" then tbl = { tbl } end
	table.insert(DebugDraw.data, tbl)
end

function DebugDraw.drawTable(tbl, x, y, indent)
	indent = indent or 0
	local spacing = 15
	local startX = x + (indent * 20)

	for key, value in pairs(tbl) do
		local displayString = ""
		if type(key) == "number" then
			displayString = ""
		else
			displayString = tostring(key) .. " = "
		end

		if type(value) == "table" then
			love.graphics.print(displayString, startX, y)
			y = DebugDraw.drawTable(value, x, y + spacing, indent + 1)
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
	DebugDraw.data = {} -- Reset data so the lib can used in places where add get's called repeatedly
end

return DebugDraw

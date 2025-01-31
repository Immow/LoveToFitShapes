require("globals")
require("libs.tprint")
local Shapes = require("shapes")
local json = require("libs.json")
local newObject = require("class.object")
local Font = love.graphics.getFont()
local Game = {}
local WW, WH = love.graphics.getDimensions()
local cellSize = 50
local gridWidth, gridHeight = 7, 7
Grid = {}
Pieces = {}
local offsetX, offsetY = WW / 2 - (gridWidth * cellSize) / 2, WH / 2 - (gridHeight * cellSize) / 2

local function genGrid()
	for y = 1, gridHeight do
		Grid[y] = {}
		for x = 1, gridWidth do
			Grid[y][x] = 0
		end
	end
end

---Returns the cells around the specified x and y index (above, below, left  and right)
---@param grid any Target table
---@param x number index
---@param y number index
---@return table
local function getAdjacentCells(grid, x, y)
	local adjacent = {}

	local directions = {
		{ dx = 0,  dy = -1 }, -- Above
		{ dx = 0,  dy = 1 }, -- Below
		{ dx = -1, dy = 0 }, -- Left
		{ dx = 1,  dy = 0 }, -- Right
	}

	for _, dir in ipairs(directions) do
		local nx, ny = x + dir.dx, y + dir.dy
		if grid[ny] and grid[ny][nx] then
			table.insert(adjacent, { x = nx, y = ny, value = grid[ny][nx] })
		end
	end

	return adjacent
end

---Filter a table so returns a table of specied values
---@param cells table table we check against for specified value
---@param value number
---@return table
local function filterCells(cells, value)
	local filtered = {}
	for _, cell in ipairs(cells) do
		if cell.value == value then
			table.insert(filtered, cell)
		end
	end
	return filtered
end

local Object1 = newObject.new({
	x = 200,
	y = 220,
	anchorPoints = {
		{ x = cellSize / 2,            y = cellSize / 2 },
		{ x = cellSize / 2,            y = cellSize / 2 + cellSize },
		{ x = cellSize / 2 + cellSize, y = cellSize / 2 + cellSize },
	},
	image = Assets[1]
})

local function drawGrid()
	for y = 1, gridHeight do
		for x = 1, gridWidth do
			local xPos = offsetX + (cellSize * (x - 1))
			local yPos = offsetY + (cellSize * (y - 1))
			love.graphics.rectangle("line", xPos, yPos, cellSize, cellSize)
			local xPosFont = xPos + cellSize / 2 - Font:getWidth(Grid[y][x]) / 2
			local yPosFont = yPos + cellSize / 2 - Font:getHeight() / 2
			love.graphics.print(Grid[y][x], xPosFont, yPosFont)
		end
	end
end

local function getRotatedGridPiece(piece, angle)
	local rad = math.rad(angle)
	local cosA, sinA = math.cos(rad), math.sin(rad)

	-- Find bounding box
	local minX, minY = math.huge, math.huge
	local maxX, maxY = -math.huge, -math.huge

	for _, coord in ipairs(piece) do
		if coord.x < minX then minX = coord.x end
		if coord.y < minY then minY = coord.y end
		if coord.x > maxX then maxX = coord.x end
		if coord.y > maxY then maxY = coord.y end
	end

	-- Find center of bounding box
	local centerX = (minX + maxX) / 2
	local centerY = (minY + maxY) / 2

	-- Create new table for rotated piece
	local rotatedPiece = {}

	for _, coord in ipairs(piece) do
		local x, y = coord.x - centerX, coord.y - centerY -- Shift to origin
		local newX = x * cosA - y * sinA
		local newY = x * sinA + y * cosA

		-- Store new coordinates (rounded) in a new table
		table.insert(rotatedPiece, {
			x = math.floor(newX + centerX + 0.5),
			y = math.floor(newY + centerY + 0.5)
		})
	end

	return rotatedPiece
end

local function shiftCoordinates(grid)
	for _, piece in ipairs(grid) do
		local smallestX, smallestY = math.huge, math.huge
		for _, coord in ipairs(piece) do
			if coord.x < smallestX then
				smallestX = coord.x
			end

			if coord.y < smallestY then
				smallestY = coord.y
			end
		end

		for _, coord in ipairs(piece) do
			coord.x = coord.x - (smallestX - 1)
			coord.y = coord.y - (smallestY - 1)
		end
	end
end

local function checkForValue(grid, value)
	for y = 1, gridHeight do
		for x = 1, gridWidth do
			if grid[y][x] == value then
				return { x = x, y = y }
			end
		end
	end
end

local shapeId = 1
local function floodFill()
	local cellPieces = {}
	local currentIndex = checkForValue(Grid, 0)
	if currentIndex then
		Grid[currentIndex.y][currentIndex.x] = shapeId
		table.insert(cellPieces, { x = currentIndex.x, y = currentIndex.y })
		local steps = love.math.random(2, 4)
		for _ = 1, steps do
			local cell = cellPieces[love.math.random(1, #cellPieces)]
			local foundAdjacentCells = filterCells(getAdjacentCells(Grid, cell.x, cell.y), 0)
			if #foundAdjacentCells == 0 then break end
			local pickedCell = love.math.random(1, #foundAdjacentCells)
			Grid[foundAdjacentCells[pickedCell].y][foundAdjacentCells[pickedCell].x] = shapeId
			currentIndex = { x = foundAdjacentCells[pickedCell].x, y = foundAdjacentCells[pickedCell].y }
			table.insert(cellPieces, currentIndex)
		end
		Pieces[shapeId] = cellPieces
		shapeId = shapeId + 1
		floodFill()
	end
end

local function areShapesEqual(shape1, shape2)
	if #shape1 ~= #shape2 then
		return false
	end

	local shape1Lookup = {}
	for _, coord in ipairs(shape1) do
		shape1Lookup[coord.x .. "," .. coord.y] = true
	end

	for _, coord in ipairs(shape2) do
		if not shape1Lookup[coord.x .. "," .. coord.y] then
			return false
		end
	end

	return true
end

local function findMatchingShape(pieces, shapes)
	for _, piece in ipairs(pieces) do
		for key, shape in ipairs(shapes) do
			if areShapesEqual(piece, shape) then
				return shape, key
			end
		end
	end
	return nil
end

local foundShapes = {}

function Game:load()
	genGrid()
	floodFill()
	love.filesystem.write("unshifted pieces", json.encode(Pieces))
	shiftCoordinates(Pieces)
	love.filesystem.write("shifted pieces", json.encode(Pieces))

	for key, piece in ipairs(Pieces) do
		local matchedShape, matchedShape_key = findMatchingShape({ piece }, Shapes) -- Pass as a single element table
		if matchedShape then
			print("Match found for piece: " .. key)
			-- print(Tprint(piece))
			print("Matching shape:" .. matchedShape_key)
			-- print(Tprint(matchedShape))
		else
			-- print("No match found for piece:")
			-- print(Tprint(piece))
		end
	end
end

function Game:mousepressed(mx, my, mouseButton)

end

function Game:draw()
	drawGrid()
	-- Object1:draw()
end

function Game:update(dt)

end

return Game

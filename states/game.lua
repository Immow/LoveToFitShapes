-- require("globals")
require("libs.tprint")
local Shapes = require("shapes")
local json = require("libs.json")
local newObject = require("class.object")
local Font = love.graphics.getFont()
local Game = {}
local WW, WH = love.graphics.getDimensions()
local gridWidth, gridHeight = 7, 7
local shapeId = 1
Grid = {}
GeneratedShapeNumbers = {}
Pieces = {}
local activePiece = nil

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

local function drawGrid()
	local gridOffsetX, gridOffsetY = WW / 2 - (gridWidth * CELLSIZE) / 2, WH / 2 - (gridHeight * CELLSIZE) / 2
	for y = 1, gridHeight do
		for x = 1, gridWidth do
			local xPos = gridOffsetX + (CELLSIZE * (x - 1))
			local yPos = gridOffsetY + (CELLSIZE * (y - 1))
			love.graphics.rectangle("line", xPos, yPos, CELLSIZE, CELLSIZE)
			local xPosFont = xPos + CELLSIZE / 2 - Font:getWidth(Grid[y][x]) / 2
			local yPosFont = yPos + CELLSIZE / 2 - Font:getHeight() / 2
			love.graphics.print(Grid[y][x], xPosFont, yPosFont)
		end
	end
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
		GeneratedShapeNumbers[shapeId] = cellPieces
		shapeId = shapeId + 1
		floodFill()
	end
end

local function sortTableByXY(tbl)
	table.sort(tbl, function(a, b)
		if a.x == b.x then
			return a.y < b.y -- If x values are the same, sort by y
		end
		return a.x < b.x -- Otherwise, sort by x
	end)
end

function RotateOnce(shape, direction)
	local rotated = {}
	for i, cell in ipairs(shape) do
		if direction == "left" then
			rotated[i] = { x = cell.y, y = -cell.x } -- rotate left
		elseif direction == "right" then
			rotated[i] = { x = -cell.y, y = cell.x } -- rotate right
		end
	end
	return rotated
end

function ShiftShape(shape)
	-- Find the minimum x and y values
	local minX, minY = math.huge, math.huge
	for _, cell in ipairs(shape) do
		if cell.x < minX then minX = cell.x end
		if cell.y < minY then minY = cell.y end
	end

	-- Shift the shape so the smallest x and y are at least 1
	local adjustedShape = {}
	for i, cell in ipairs(shape) do
		adjustedShape[i] = { x = cell.x - minX + 1, y = cell.y - minY + 1 }
	end

	return adjustedShape
end

local function getCentroid(cells)
	local largestX = 0
	local largestY = 0
	for _, value in ipairs(cells) do
		if value.x > largestX then largestX = value.x end
		if value.y > largestY then largestY = value.y end
	end

	return { x = (largestX) * CELLSIZE / 2, y = (largestY) * CELLSIZE / 2 }
end

local function compareShapes(pieces, shapes)
	for i, piece in ipairs(pieces) do
		local lookup = ""
		for _, coord in ipairs(piece) do
			lookup = lookup .. "x" .. coord.x .. "y" .. coord.y
		end
		if shapes[lookup] then
			-- if i == 1 then
			-- lookup = "x1y1x1y2x2y2x3y1x3y2"
			-- print(Tprint(anchorRotations))

			local anchorRotations = { shapes[lookup].default }
			local image = Assets[shapes[lookup].id]
			for y = 2, 4 do
				local rotated = RotateOnce(anchorRotations[y - 1], "left")
				anchorRotations[y] = ShiftShape(rotated)
			end

			Pieces[i] = newObject.new({
				x = 200,
				y = 400,
				anchorPoints = anchorRotations,
				image = image,
				id = shapes[lookup].id,
			})
			-- end
		else
			print("no: " .. lookup)
			print(Tprint(piece))
		end
	end
end

local function sortAllPieces(pieces)
	for _, piece in ipairs(pieces) do
		sortTableByXY(piece)
	end
end

local function moveToFront(index)
	local piece = table.remove(Pieces, index) -- Remove from list
	table.insert(Pieces, piece)            -- Reinsert at the end (topmost layer)
end

function Game:load()
	genGrid()
	floodFill()
	shiftCoordinates(GeneratedShapeNumbers)
	sortAllPieces(GeneratedShapeNumbers)
	compareShapes(GeneratedShapeNumbers, Shapes)
end

function Game:keypressed(key, scancode, isrepeat)
	if key == "space" then
		shapeId = 1
		self:load()
	end
end

function Game:wheelmoved(x, y)
	if activePiece then
		if y > 0 then
			activePiece.rotationIndex = (activePiece.rotationIndex + 1) % 4 -- Rotate 90° clockwise
		elseif y < 0 then
			activePiece.rotationIndex = (activePiece.rotationIndex - 1) % 4 -- Rotate 90° counterclockwise
			if activePiece.rotationIndex < 0 then activePiece.rotationIndex = activePiece.rotationIndex + 4 end
		end
	end
end

function Game:mousepressed(mx, my, mouseButton)
	for i = #Pieces, 1, -1 do
		local piece = Pieces[i]
		local anchorPointsPixels = piece:getAnchorPointsInPixels(piece.rotationIndex)

		if piece:AABB({ x = mx, y = my }, anchorPointsPixels) then
			activePiece = piece
			moveToFront(i)

			activePiece.clickOffsetX = mx - activePiece.x
			activePiece.clickOffsetY = my - activePiece.y

			break
		end
	end
end

function Game:mousereleased(x, y, button, isTouch)
	activePiece = nil
end

function Game:draw()
	drawGrid()
	for _, piece in ipairs(Pieces) do
		piece:draw()
	end
	love.graphics.setColor(1, 1, 1, 1)
end

function Game:update(dt)
	if activePiece and love.mouse.isDown(1) then
		local mx, my = love.mouse.getPosition()
		activePiece.x = mx - activePiece.clickOffsetX
		activePiece.y = my - activePiece.clickOffsetY
	end
end

return Game

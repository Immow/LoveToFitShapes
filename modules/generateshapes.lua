local Shapes = require("shapes")
local newObject = require("class.object")
local GenerateShapes = {}
local WW, WH = love.graphics.getDimensions()
local shapeId = 1
local GeneratedShapeNumbers = {}
local holeCount = 30

function GenerateShapes:genGrid()
	for y = 1, GRIDHEIGHT do
		Grid.pieces[y] = {}
		for x = 1, GRIDWIDTH do
			Grid.pieces[y][x] = 0
		end
	end
end

function GenerateShapes:GenerateHoles(holes)
	local positions = {}
	for y = 1, GRIDHEIGHT do
		for x = 1, GRIDWIDTH do
			table.insert(positions, { x = x, y = y })
		end
	end

	-- Shuffle the list randomly
	for i = #positions, 2, -1 do
		local j = love.math.random(1, i)
		positions[i], positions[j] = positions[j], positions[i]
	end

	-- Pick the first `holes` positions
	for i = 1, holes do
		local pos = positions[i]
		Grid.pieces[pos.y][pos.x] = -1
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

function GenerateShapes:holeFloodFill()
	local visited = {}
	local startCell = nil

	for y = 1, GRIDHEIGHT do
		if startCell then break end
		for x = 1, GRIDWIDTH do
			if Grid.pieces[y][x] == 0 then
				startCell = { x = x, y = y }
				break
			end
		end
	end

	if not startCell then return false end

	for y = 1, GRIDHEIGHT do
		visited[y] = {}
	end

	-- Flood fill using an iterative stack-based approach
	local stack = { startCell }
	visited[startCell.y][startCell.x] = true
	local count = 1

	while #stack > 0 do
		local cell = table.remove(stack)
		local adjacentCellList = getAdjacentCells(Grid.pieces, cell.x, cell.y)
		for _, adj in ipairs(adjacentCellList) do
			if not visited[adj.y][adj.x] and adj.value ~= -1 then
				visited[adj.y][adj.x] = true
				count = count + 1
				table.insert(stack, { x = adj.x, y = adj.y })
			end
		end
	end

	return count + holeCount == GRIDHEIGHT * GRIDWIDTH
end

---Filter a table so it returns a table of specified values
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

function GenerateShapes:drawShapeIds()
	for y = 1, GRIDHEIGHT do
		for x = 1, GRIDWIDTH do
			local xPos = GRID_X + (CELLSIZE * (x - 1))
			local yPos = GRID_Y + (CELLSIZE * (y - 1))
			local xPosFont = xPos + CELLSIZE / 2 - Font:getWidth(Grid.pieces[y][x]) / 2
			local yPosFont = yPos + CELLSIZE / 2 - Font:getHeight() / 2
			love.graphics.print(Grid.pieces[y][x], xPosFont, yPosFont)
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
	for y = 1, GRIDHEIGHT do
		for x = 1, GRIDWIDTH do
			if grid[y][x] == value then
				return { x = x, y = y }
			end
		end
	end
end

function GenerateShapes:floodFill()
	local cellPieces = {}
	local currentIndex = checkForValue(Grid.pieces, 0)  -- pick a Grid cell (index) to start from
	if currentIndex then
		Grid.pieces[currentIndex.y][currentIndex.x] = shapeId -- set shapeId to cells belong to shape
		table.insert(cellPieces, { x = currentIndex.x, y = currentIndex.y })
		local steps = love.math.random(2, 4)            -- determines shape size in cells
		for _ = 1, steps do
			local cell = cellPieces[love.math.random(1, #cellPieces)]
			local foundAdjacentCells = filterCells(getAdjacentCells(Grid.pieces, cell.x, cell.y), 0) -- find cells of a certain value
			if #foundAdjacentCells == 0 then break end
			local pickedCell = love.math.random(1, #foundAdjacentCells)
			Grid.pieces[foundAdjacentCells[pickedCell].y][foundAdjacentCells[pickedCell].x] = shapeId
			currentIndex = { x = foundAdjacentCells[pickedCell].x, y = foundAdjacentCells[pickedCell].y }
			table.insert(cellPieces, currentIndex)
		end
		GeneratedShapeNumbers[shapeId] = cellPieces
		shapeId = shapeId + 1
		self:floodFill()
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

local function compareShapes(pieces, shapes)
	for i, piece in ipairs(pieces) do
		local lookup = ""
		for _, coord in ipairs(piece) do
			lookup = lookup .. "x" .. coord.x .. "y" .. coord.y
		end
		if shapes[lookup] then
			-- if i == 1 then
			-- lookup = "x1y2x2y2x3y1x3y2x4y1"
			-- print(Tprint(anchorRotations))

			local anchorRotations = { shapes[lookup].default }
			local image = Assets.shapes[shapes[lookup].id]
			for y = 2, 4 do
				local rotated = RotateOnce(anchorRotations[y - 1], "left")
				anchorRotations[y] = ShiftShape(rotated)
			end

			local frames = 5
			local frameWidth = image:getWidth() / frames -- divide by frames in spritesheet
			local frameHeight = image:getHeight()
			local w = image:getWidth()
			local h = image:getHeight()
			local g = Anim8.newGrid(frameWidth, frameHeight, w, h)
			Pieces[i] = newObject.new({
				x = 200,
				y = 400,
				w = frameWidth,
				h = frameHeight,
				anchorPoints = anchorRotations,
				image = image,
				id = shapes[lookup].id,
				states = { Anim8.newAnimation(g("1-2", 1), 0.1) },
			})
			-- end
		else
			print("compareShapes function, no: " .. lookup)
			-- print(Tprint(piece))
		end
	end
end

local function placePiecesInCircle()
	local centerX = WW / 2
	local centerY = WH / 2
	local radius = (GRIDWIDTH * CELLSIZE) + 50 -- Distance from the board

	local numPieces = #Pieces
	local angleStep = (2 * math.pi) / numPieces -- Divide full circle by number of pieces

	for i, piece in ipairs(Pieces) do
		local angle = (i - 1) * angleStep -- Evenly space pieces along the circle

		piece.x = centerX + math.cos(angle) * radius - piece.w / 2
		piece.y = centerY + math.sin(angle) * radius - piece.h / 2
	end
end

local function sortAllPieces(pieces)
	for _, piece in ipairs(pieces) do
		sortTableByXY(piece)
	end
end

local function countTotalAnchorPoints()
	local total = 0
	for _, piece in ipairs(Pieces) do
		local currentRotation = piece.rotationIndex + 1 -- Get the correct rotation index
		if piece.anchorPoints[currentRotation] then
			total = total + #piece.anchorPoints[currentRotation]
		end
	end
	return total
end

local function syncPieces()
	for _, piece in ipairs(Pieces) do
		piece:sync()
	end
end

function GenerateShapes:reset()
	shapeId = 1
	Grid.pieces = {}
	GeneratedShapeNumbers = {}
	Pieces = {}
end

function GenerateShapes:load()
	repeat
		self:genGrid()
		self:GenerateHoles(holeCount)
	until self:holeFloodFill()
	self:floodFill()
	shiftCoordinates(GeneratedShapeNumbers)
	sortAllPieces(GeneratedShapeNumbers)
	compareShapes(GeneratedShapeNumbers, Shapes)
	placePiecesInCircle()
	syncPieces()
end

function GenerateShapes:keypressed(key, scancode, isrepeat)
	if key == "space" then
		self:reset()
		self:load()
	end
end

function GenerateShapes:wheelmoved(x, y)

end

function GenerateShapes:draw()
	-- love.graphics.setColor(1, 1, 1, 1)
	-- self:drawShapeIds()
end

return GenerateShapes

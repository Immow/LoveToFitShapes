require("globals")
require("libs.tprint")
local Shapes = require("shapes")
local allShapes = require("allshapes")
local json = require("libs.json")
local newObject = require("class.object")
local Font = love.graphics.getFont()
local Game = {}
local WW, WH = love.graphics.getDimensions()
local cellSize = 50
local gridWidth, gridHeight = 7, 7
local shapeId = 1
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

-- local function areShapesEqual(shape1, shape2)
-- 	-- if #shape1 ~= #shape2 then
-- 	-- 	return false
-- 	-- end

-- 	local shape1Lookup = {}
-- 	for _, coord in ipairs(shape1) do
-- 		shape1Lookup[coord.x .. "," .. coord.y] = true
-- 	end

-- 	for _, coord in ipairs(shape2) do
-- 		if not shape1Lookup[coord.x .. "," .. coord.y] then
-- 			return false
-- 		end
-- 	end

-- 	return true
-- end

local function areShapesEqual(pieces, shapes)
	local shape1Lookup = {}

	for _, shape in ipairs(pieces) do
		for _, coord in ipairs(shape) do
			shape1Lookup[coord.x .. "," .. coord.y] = true
		end
	end

	for _, shape in ipairs(shapes) do
		for _, coord in ipairs(shape) do
			if shape1Lookup[coord.x .. "," .. coord.y] then
				-- print(coord.x, coord.y)
				return true
			end
		end
	end

	return false
end


local function getMirroredGridPiece(piece, axis)
	local mirroredPiece = {}

	-- Find bounding box
	local minX, minY = math.huge, math.huge
	local maxX, maxY = -math.huge, -math.huge

	for _, coord in ipairs(piece) do
		if coord.x < minX then minX = coord.x end
		if coord.y < minY then minY = coord.y end
		if coord.x > maxX then maxX = coord.x end
		if coord.y > maxY then maxY = coord.y end
	end

	-- Mirror transformation
	for _, coord in ipairs(piece) do
		local mirroredX, mirroredY = coord.x, coord.y

		if axis == "horizontal" then
			mirroredX = maxX - (coord.x - minX) -- Flip across vertical center
		elseif axis == "vertical" then
			mirroredY = maxY - (coord.y - minY) -- Flip across horizontal center
		end

		table.insert(mirroredPiece, { x = mirroredX, y = mirroredY })
	end

	return mirroredPiece
end

local function findMatchingShape(pieces, shapes)
	for _, piece in ipairs(pieces) do
		for key, shape in ipairs(shapes) do
			for angle = 0, 270, 90 do -- Check all 4 rotations
				local rotatedShape = getRotatedGridPiece(shape, angle)
				shiftCoordinates({ rotatedShape })

				if areShapesEqual(piece, rotatedShape) then
					return shape, key, angle, "original"
				end

				-- Check mirrored versions
				for _, axis in ipairs({ "horizontal", "vertical" }) do
					local mirroredShape = getMirroredGridPiece(rotatedShape, axis)
					shiftCoordinates({ mirroredShape })

					if areShapesEqual(piece, mirroredShape) then
						return shape, key, angle, axis
					end
				end
			end
		end
	end
	return nil
end

local function shiftShape(shape)
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

local function rotateShapes(shape)
	local rotatedShapes = { shape }
	for x = 1, 3 do
		local rotated = {}
		for i, cell in ipairs(rotatedShapes[x]) do
			rotated[i] = { x = cell.y, y = -cell.x }
		end
		rotatedShapes[x + 1] = shiftShape(rotated)
	end

	return rotatedShapes
end

local function mirrorShape(shape)
	local mirroredShape = {}

	for i, cell in ipairs(shape) do
		mirroredShape[i] = { x = -cell.x, y = cell.y } -- Flip horizontally
	end

	return shiftShape(mirroredShape)
end

local function test(pieces, shapes)
	local transformedShapes = {}
	local cow
	for _, piece in ipairs(pieces) do
		-- for key, shape in ipairs(shapes) do
		-- print(Tprint(rotatedShapes))
		-- if #piece ~= #shape then
		-- 	break
		-- end

		local rotatedShapes = rotateShapes(piece)
		local mirroredShape = mirrorShape(piece)
		local rotatedMirrorerdShapes = rotateShapes(mirroredShape)
		cow = areShapesEqual(rotatedShapes, shapes)
		-- end
		print(Tprint(rotatedShapes))
	end
	return cow
end

local function makeShapes(pieces)
	local rotated = {}
	for _, piece in ipairs(pieces) do
		local rotatedShapes = rotateShapes(piece)
		local mirroredShape = mirrorShape(piece)
		local rotatedMirrorerdShapes = rotateShapes(mirroredShape)
		table.insert(rotated, rotatedShapes[1])
		table.insert(rotated, rotatedShapes[2])
		table.insert(rotated, rotatedShapes[3])
		table.insert(rotated, rotatedShapes[4])
		table.insert(rotated, rotatedMirrorerdShapes[1])
		table.insert(rotated, rotatedMirrorerdShapes[2])
		table.insert(rotated, rotatedMirrorerdShapes[3])
		table.insert(rotated, rotatedMirrorerdShapes[4])
	end
	love.filesystem.write("rotated1", json.encode(rotated))
end

function removeDuplicates(tbl)
	local seen = {}
	local unique = {}

	-- Helper function to convert a table to a unique string key
	local function tableToString(t)
		table.sort(t, function(a, b) return a.x < b.x or (a.x == b.x and a.y < b.y) end)
		local str = ""
		for _, v in ipairs(t) do
			str = str .. string.format("(%d,%d)", v.x, v.y)
		end
		return str
	end

	for _, subTable in ipairs(tbl) do
		local key = tableToString(subTable)
		if not seen[key] then
			seen[key] = true
			table.insert(unique, subTable)
		end
	end

	return unique
end

-- local test1111 = require("test")
-- -- Example usage:
-- local uniqueTables = removeDuplicates(test1111)
-- love.filesystem.write("complete shapes", json.encode(uniqueTables))
-- local blalalala = makeShapes(removeDuplicates(test1111))
-- love.filesystem.write("complete shapes", json.encode(blalalala))

-- for i, t in ipairs(uniqueTables) do
-- 	print("Table " .. i .. ":")
-- 	for _, v in ipairs(t) do
-- 		print("  x:", v.x, "y:", v.y)
-- 	end
-- end

local function compareCells(shapes, pieces)
	for _, piece in ipairs(pieces) do
		print(#piece)
	end
	for _, shape in ipairs(shapes) do
		for _, cell in ipairs(shape) do
			-- print(cell.x)
		end
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

local function compareShapes(pieces, shapes)
	-- for _, piece in ipairs(pieces) do
	-- 	for key, cell in ipairs(piece) do
	-- 		print(key, cell.x)
	-- 	end
	-- end
	for i, piece in ipairs(pieces) do
		local lookup = ""
		print("checking piece:" .. i)
		for _, coord in ipairs(piece) do
			-- print("x" .. coord.x .. "y" .. coord.y)
			lookup = lookup .. "x" .. coord.x .. "y" .. coord.y
		end
		if shapes[lookup] then
			-- print("yes")
			-- print("found index:" .. i .. " cords x:" .. coord.x .. " y:" .. coord.y)
		else
			-- print("not found index:" .. i .. " cords x:" .. coord.x .. " y:" .. coord.y)
			print("no: " .. lookup)
			print(Tprint(piece))
			-- print("not found " .. i .. " " .. shapes["x" .. coord.x .. "y" .. coord.y])
		end
	end
end

function Game:load()
	genGrid()
	floodFill()
	shiftCoordinates(Pieces)
	-- local test1234 = { { x = 1, y = 1 }, { x = 2, y = 1 } }
	-- compareCells(allShapes, test1234)

	for key, piece in ipairs(Pieces) do
		-- for _, cell in ipairs(piece) do
		sortTableByXY(piece)
		-- end
	end
	compareShapes(Pieces, allShapes)
	-- print(Tprint(Pieces))

	-- makeShapes(Shapes)
	-- love.filesystem.write("unshifted pieces", json.encode(Pieces))
	-- love.filesystem.write("shifted pieces", json.encode(Pieces))
	-- for key, piece in ipairs(Pieces) do
	-- 	local matchedShape, matchedShape_key, matchedAngle = findMatchingShape({ piece }, Shapes)
	-- 	if matchedShape then
	-- 		print("Match found for piece: " ..
	-- 			key .. " with shape " .. matchedShape_key .. " rotated " .. matchedAngle .. "°")
	-- 	else
	-- 		print("No match found for piece: " .. key)
	-- 		for i = 1, 4 do
	-- 			for angle = 0, 270, 90 do -- Check all 4 rotations
	-- 				local rotatedShape = getRotatedGridPiece(piece, angle)
	-- 				shiftCoordinates({ rotatedShape })

	-- 				if areShapesEqual(piece, rotatedShape) then
	-- 					print(Tprint(rotatedShape))
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	-- end

	-- print(test(Pieces, Shapes))
end

function Game:keypressed(key, scancode, isrepeat)
	if key == "space" then
		print("----------------------------------------")
		shapeId = 1
		self:load()
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

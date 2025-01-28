require("globals")
require("libs.tprint")
local newObject = require("class.object")

local Game = {}
local WW, WH = love.graphics.getDimensions()
local cellSize = 50
local gridWidth, gridHeight = 7, 7
Grid = {}
Pieces = {}
local offsetX, offsetY = WW / 2 - (gridWidth * cellSize) / 2, WH / 2 - (gridHeight * cellSize) / 2

local function genGrid()
	for i = 1, gridWidth * gridHeight do
		Grid[i] = 0
	end
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

local function getCellPosition(index, width)
	return index % width + 1, math.floor(index / width + 1)
end

local function getNeighbours(index, width, height)
	local x, y = getCellPosition(index - 1, width)

	local neighbours = {}

	if x > 0 then table.insert(neighbours, index - 1) end
	if x < width - 1 then table.insert(neighbours, index + 1) end
	if y > 0 then table.insert(neighbours, index - width) end
	if y < height - 1 then table.insert(neighbours, index + width) end

	return neighbours
end

local function getEmptyNeighbours(index)
	local cells = {}

	if index % gridWidth ~= 1 then cells[1] = index - 1 end
	if index % gridWidth ~= 0 then cells[2] = index + 1 end
	if index > gridWidth then cells[3] = index - gridWidth end
	if index <= gridWidth * gridHeight - gridWidth then cells[4] = index + gridWidth end
	for key, value in pairs(cells) do
		print(value)
	end
	return cells
end

local function drawGrid()
	for i = 0, #Grid - 1 do
		local xCord = offsetX + (((i % gridWidth) * cellSize))
		local yCord = offsetY + math.floor((i) / gridHeight) * cellSize
		love.graphics.rectangle("line", xCord, yCord, cellSize, cellSize)
		love.graphics.setColor(0, 1, 0, 1)
		love.graphics.print(Grid[i + 1], xCord, yCord)
		love.graphics.setColor(1, 1, 1, 1)
	end
end

local currentIndex = math.ceil((gridWidth * gridHeight) / 2)
local shapeId = 1
Grid[currentIndex] = shapeId
local function floodFill()
	-- local steps = love.math.random(1, 4)
	-- for i = 1, steps do
	-- 	local cells = getEmptyNeighbours(currentIndex)
	-- 	local pickedCell = love.math.random(1, #cells)
	-- 	Grid[pickedCell] = shapeId
	-- 	currentIndex = pickedCell
	-- end
	-- shapeId = shapeId + 1
	-- local cells = getEmptyNeighbours(currentIndex)
	-- for _, value in pairs(cells) do
	-- 	Grid[value] = 1
	-- end
	local test = getNeighbours(1, gridWidth, gridHeight)
	for key, value in pairs(test) do
		Grid[value] = "cow"
	end
end

function Game:load()
	genGrid()
	-- local test = getEmptyNeighbours(10)
	-- print(Tprint(test))
	floodFill()

	-- print(Tprint(Grid))
	-- print("Game module loaded")
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

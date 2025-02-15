local Game = {}
Pieces = {}
Grid = { shapeId = {}, tileId = {}, placedShapes = {} } -- Change so we store data in tables so we can do Grid.debug or Grid.cell etc
local GenerateShapes = require("modules.generateshapes")
local activePiece = nil

local function genGrid()
	for y = 1, GRIDHEIGHT do
		Grid.shapeId[y] = {}
		Grid.tileId[y] = {}
		Grid.placedShapes[y] = {}
		for x = 1, GRIDWIDTH do
			Grid.shapeId[y][x] = 0
			Grid.tileId[y][x] = 0
			Grid.placedShapes[y][x] = 0
		end
	end
end

local function drawGrid()
	local gridOffsetX, gridOffsetY = WW / 2 - (GRIDWIDTH * CELLSIZE) / 2, WH / 2 - (GRIDHEIGHT * CELLSIZE) / 2
	for y = 1, GRIDHEIGHT do
		for x = 1, GRIDWIDTH do
			local xPos = gridOffsetX + (CELLSIZE * (x - 1))
			local yPos = gridOffsetY + (CELLSIZE * (y - 1))
			love.graphics.rectangle("line", xPos, yPos, CELLSIZE, CELLSIZE)
		end
	end
end

local function moveToFront(index)
	local piece = table.remove(Pieces, index) -- Remove from list
	table.insert(Pieces, piece)            -- Reinsert at the end (topmost layer)
end

function Game:load()
	genGrid()
	GenerateShapes:load()
end

--- check if a is inside b
--- @param a table object
--- @param b table object
--- @return boolean
local function isInside(a, b)
	return a.x >= b.x and
		a.x + a.w <= b.x + b.w and
		a.y >= b.y and
		a.y + a.h <= b.y + b.h
end

function Game:isInsideGrid(piece)
	local grid = {
		x = WW / 2 - (GRIDWIDTH / 2 * CELLSIZE),
		y = WH / 2 - (GRIDHEIGHT / 2 * CELLSIZE),
		w = GRIDWIDTH * CELLSIZE,
		h = GRIDHEIGHT * CELLSIZE
	}

	local test = {
		x = piece.centroids[piece.rotationIndex + 1].x + piece.x,
		y = piece.centroids[piece.rotationIndex + 1].y + piece.y,
		w = piece.w,
		h = piece.h
	}
	print(Tprint(test))
	return isInside(piece, grid)
end

function Game:keypressed(key, scancode, isrepeat)
	if key == "space" then
		genGrid()
		GenerateShapes:reset()
		GenerateShapes:load()
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

local function getAnchorPointsInPixels(shape)
	local points = {}
	local ox, oy = shape.w / 2, shape.h / 2
	for i, anchor in ipairs(shape.anchorPoints[shape.rotationIndex + 1]) do
		local shapeCenter = shape.centroids[shape.rotationIndex + 1]
		local offsetX = ox - shapeCenter.x
		local offsetY = oy - shapeCenter.y
		local x = (anchor.x - 1) * CELLSIZE + shape.x + offsetX + CELLSIZE / 2
		local y = (anchor.y - 1) * CELLSIZE + shape.y + offsetY + CELLSIZE / 2
		table.insert(points, { x = x, y = y })
	end

	return points
end

local function pointRecCollision(point, rec)
	local xRegion = rec.x <= point.x and rec.x + rec.width >= point.x
	local yRegion = rec.y <= point.y and rec.y + rec.height >= point.y
	return xRegion and yRegion
end

local function getGridIndexFromPosition(x, y)
	local gridOffsetX = WW / 2 - (GRIDWIDTH * CELLSIZE) / 2
	local gridOffsetY = WH / 2 - (GRIDHEIGHT * CELLSIZE) / 2

	-- Convert screen coordinates to grid indices
	local gridX = math.floor((x - gridOffsetX) / CELLSIZE) + 1
	local gridY = math.floor((y - gridOffsetY) / CELLSIZE) + 1

	return gridX, gridY
end

local Font = love.graphics.getFont()
local function drawFoundShapes()
	local gridOffsetX, gridOffsetY = WW / 2 - (GRIDWIDTH * CELLSIZE) / 2, WH / 2 - (GRIDHEIGHT * CELLSIZE) / 2
	for y = 1, GRIDHEIGHT do
		for x = 1, GRIDWIDTH do
			local xPos = gridOffsetX + (CELLSIZE * (x - 1))
			local yPos = gridOffsetY + (CELLSIZE * (y - 1))
			local xPosFont = xPos + CELLSIZE / 2 - Font:getWidth(Grid.shapeId[y][x]) / 2
			local yPosFont = yPos + CELLSIZE / 2 - Font:getHeight() / 2
			love.graphics.print(Grid.placedShapes[y][x], xPosFont, yPosFont)
		end
	end
end

function Game:mousereleased(x, y, button, isTouch)
	if activePiece and self:isInsideGrid(activePiece) then
		-- local gridOffsetX, gridOffsetY = WW / 2 - (GRIDWIDTH * CELLSIZE) / 2, WH / 2 - (GRIDHEIGHT * CELLSIZE) / 2

		local anchorPoints = getAnchorPointsInPixels(activePiece)
		print(Tprint(anchorPoints))
		local indexes = {}
		for i, cell in ipairs(anchorPoints) do
			local gridX, gridY = getGridIndexFromPosition(cell.x, cell.y)
			if Grid.placedShapes[gridY][gridX] ~= 0 then
				return print("no")
			else
				indexes[i] = { x = gridX, y = gridY }
				Grid.placedShapes[gridY][gridX] = 1
			end
		end


		-- for _, cell in ipairs(activePiece.anchorPoints[activePiece.rotationIndex + 1]) do
		-- 	for _, point in ipairs(cell) do

		-- 		if pointRecCollision(anchor, )

		-- 	end
		-- end
		-- print(Tprint(anchorPoints))
	end
	activePiece = nil
end

function Game:draw()
	drawGrid()
	GenerateShapes:draw()
	for _, piece in ipairs(Pieces) do
		piece:draw()
	end
	drawFoundShapes()
	-- DEBUG.add(countTotalAnchorPoints())
	-- love.graphics.setColor(1, 1, 1, 1)
end

function Game:update(dt)
	if activePiece and love.mouse.isDown(1) then
		local mx, my = love.mouse.getPosition()
		activePiece.x = mx - activePiece.clickOffsetX
		activePiece.y = my - activePiece.clickOffsetY
	end
end

return Game

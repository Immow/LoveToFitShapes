local Game = {}
Pieces = {}
local Grid = {} -- Change so we store data in tables so we can do Grid.debug or Grid.cell etc
local GenerateShapes = require("modules.generateshapes")
local activePiece = nil

function Game.genGrid()
	for y = 1, GRIDHEIGHT do
		Grid[y] = {}
		for x = 1, GRIDWIDTH do
			Grid[y][x] = 0
		end
	end
end

function Game:load()
	Game.genGrid()
	GenerateShapes:load()
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
		x = WW / 2 - (GRIDWIDTH / 2 * CELLSIZE) - CELLSIZE / 3,
		y = WH / 2 - (GRIDHEIGHT / 2 * CELLSIZE) - CELLSIZE / 3,
		w = GRIDWIDTH * CELLSIZE + (CELLSIZE / 3 * 2),
		h = GRIDHEIGHT * CELLSIZE + (CELLSIZE / 3 * 2)
	}
	return isInside(piece, grid)
end

function Game:AABB(mouse, points)
	for _, point in ipairs(points) do
		local xRegion = point.x - CELLSIZE / 2 <= mouse.x and point.x + CELLSIZE / 2 >= mouse.x
		local yRegion = point.y - CELLSIZE / 2 <= mouse.y and point.y + CELLSIZE / 2 >= mouse.y
		if xRegion and yRegion then return true end
	end

	return false
end

local function getGridCellFromPosition(x, y)
	-- Grid top-left corner in screen coordinates
	local gridOffsetX = WW / 2 - (GRIDWIDTH * CELLSIZE) / 2
	local gridOffsetY = WH / 2 - (GRIDHEIGHT * CELLSIZE) / 2

	-- Convert screen coordinates to grid indices
	local gridX = math.floor((x - gridOffsetX) / CELLSIZE) + 1
	local gridY = math.floor((y - gridOffsetY) / CELLSIZE) + 1

	-- Check if the position is inside the grid
	if gridX < 1 or gridX > GRIDWIDTH or gridY < 1 or gridY > GRIDHEIGHT then
		return nil, nil -- Out of bounds
	end

	return gridX, gridY
end

function Game:drawPieceIds()
	local gridOffsetX, gridOffsetY = WW / 2 - (GRIDWIDTH * CELLSIZE) / 2, WH / 2 - (GRIDHEIGHT * CELLSIZE) / 2
	for y = 1, GRIDHEIGHT do
		for x = 1, GRIDWIDTH do
			local xPos = gridOffsetX + (CELLSIZE * (x - 1))
			local yPos = gridOffsetY + (CELLSIZE * (y - 1))
			local xPosFont = xPos + CELLSIZE / 2 - Font:getWidth(Grid[y][x]) / 2
			local yPosFont = yPos + CELLSIZE / 2 - Font:getHeight() / 2
			love.graphics.print(Grid[y][x], xPosFont, yPosFont)
		end
	end
end

function Game:keypressed(key, scancode, isrepeat)
	if key == "space" then
		activePiece = nil
		Grid = {}
		GenerateShapes:reset()
		Game:load()
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
		local rotationIndex = piece.rotationIndex + 1
		if piece.anchorPointsInPixels[rotationIndex] and self:AABB({ x = mx, y = my }, piece.anchorPointsInPixels[rotationIndex]) then
			activePiece = piece
			moveToFront(i)

			activePiece.clickOffsetX = mx - activePiece.x
			activePiece.clickOffsetY = my - activePiece.y
			break
		end
	end
end

function Game:mousereleased(x, y, button, isTouch)
	if activePiece then
		local canPlacePiece = true
		local snapped = { x = nil, y = nil }
		local pointPos = {}
		local rotationIndex = activePiece.rotationIndex + 1

		for _, point in ipairs(activePiece.anchorPointsInPixels[rotationIndex]) do
			local gridX, gridY = getGridCellFromPosition(point.x, point.y)
			if gridX and gridY and Grid[gridY] and Grid[gridY][gridX] == 0 then
				if not snapped.x or not snapped.y then
					pointPos.x = point.x
					pointPos.y = point.y
					snapped.x = (gridX - 1) * CELLSIZE + (WW / 2 - (GRIDWIDTH * CELLSIZE) / 2)
					snapped.y = (gridY - 1) * CELLSIZE + (WH / 2 - (GRIDHEIGHT * CELLSIZE) / 2)
				end
			else
				canPlacePiece = false
				break
			end
		end

		if canPlacePiece and snapped.x and snapped.y then
			activePiece.x = activePiece.x - (pointPos.x - (snapped.x + CELLSIZE / 2))
			activePiece.y = activePiece.y - (pointPos.y - (snapped.y + CELLSIZE / 2))

			for _, point in ipairs(activePiece.anchorPointsInPixels[rotationIndex]) do
				local gridX, gridY = getGridCellFromPosition(point.x, point.y)
				if gridX and gridY then
					Grid[gridY][gridX] = 1
				end
			end
		end
		activePiece:sync()
	end
	activePiece = nil
end

function Game:draw()
	drawGrid()
	GenerateShapes:draw()
	for _, piece in ipairs(Pieces) do
		piece:draw()
	end
	self:drawPieceIds()
	-- DEBUG.add(countTotalAnchorPoints())
	-- love.graphics.setColor(1, 1, 1, 1)
end

function Game:update(dt)
	if activePiece then
		local mx, my = love.mouse.getPosition()
		activePiece.x = mx - activePiece.clickOffsetX
		activePiece.y = my - activePiece.clickOffsetY
		activePiece:sync()
	end
end

return Game

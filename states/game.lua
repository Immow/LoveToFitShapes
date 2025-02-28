local Game = { state = "unsolved" }
Pieces = {}
Grid = {
	board = {}, -- Represents the grid itself (holes, placed pieces)
	pieces = {} -- Stores generated puzzle pieces
}

local GenerateShapes = require("modules.generateshapes")
local activePiece = nil

function Game.genGrid()
	for y = 1, GRIDHEIGHT do
		Grid.board[y] = {}
		for x = 1, GRIDWIDTH do
			if Grid.pieces[y][x] > 0 then
				Grid.board[y][x] = 0
			elseif Grid.pieces[y][x] == -1 then
				Grid.board[y][x] = -1
			end
		end
	end
end

function Game:load()
	self.state = "unsolved"
	GenerateShapes:load()
	Game.genGrid()
end

function Game:getGameState()
	for y = 1, GRIDHEIGHT do
		for x = 1, GRIDWIDTH do
			if Grid.board[y][x] == 0 then
				return
			end
		end
	end
	self.state = "solved"
	return self.state
end

local function drawGrid()
	for y = 1, GRIDHEIGHT do
		for x = 1, GRIDWIDTH do
			local xPos = GRID_X + (CELLSIZE * (x - 1))
			local yPos = GRID_Y + (CELLSIZE * (y - 1))
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.rectangle("line", xPos, yPos, CELLSIZE, CELLSIZE)
			if Grid.board[y][x] == -1 then
				love.graphics.setColor(0, 0, 0, 1)
				love.graphics.rectangle("fill", xPos, yPos, CELLSIZE, CELLSIZE)
			elseif Grid.board[y][x] >= 0 then
				love.graphics.setColor(0.5, 0.5, 0.5, 1)
				love.graphics.rectangle("fill", xPos, yPos, CELLSIZE, CELLSIZE)
			end
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
	-- Convert screen coordinates to grid indices
	local gridX = math.floor((x - GRID_X) / CELLSIZE) + 1
	local gridY = math.floor((y - GRID_Y) / CELLSIZE) + 1

	-- Check if the position is inside the grid
	if gridX < 1 or gridX > GRIDWIDTH or gridY < 1 or gridY > GRIDHEIGHT then
		return nil, nil -- Out of bounds
	end

	return gridX, gridY
end

function Game:drawPieceIds()
	for y = 1, GRIDHEIGHT do
		for x = 1, GRIDWIDTH do
			local xPos = GRID_X + (CELLSIZE * (x - 1))
			local yPos = GRID_Y + (CELLSIZE * (y - 1))
			local xPosFont = xPos + CELLSIZE / 2 - Font:getWidth(Grid.board[y][x]) / 2
			local yPosFont = yPos + CELLSIZE / 2 - Font:getHeight() / 2
			if Grid.board[y][x] ~= 0 then
				love.graphics.setColor(1, 0, 0, 1)
			else
				love.graphics.setColor(0, 0, 0, 1)
			end
			love.graphics.print(Grid.board[y][x], xPosFont, yPosFont)
		end
	end
end

function Game:canPieceBePlaced(piece, rotationIndex)
	local canPlace = true
	local snapped = { x = nil, y = nil }
	local pointPos = {}

	for _, point in ipairs(piece.anchorPointsInPixels[rotationIndex]) do
		local gridX, gridY = getGridCellFromPosition(point.x, point.y)

		if gridX and gridY and Grid.board[gridY] and Grid.board[gridY][gridX] == 0 then
			if not snapped.x or not snapped.y then
				pointPos.x = point.x
				pointPos.y = point.y
				snapped.x = (gridX - 1) * CELLSIZE + GRID_X
				snapped.y = (gridY - 1) * CELLSIZE + GRID_Y
			end
		else
			return false, nil, nil -- If any part of the shape can't be placed, return early
		end
	end

	return canPlace, snapped, pointPos
end

function Game:snapPieceToGrid(piece, snapped, pointPos)
	piece.x = piece.x - (pointPos.x - (snapped.x + CELLSIZE / 2))
	piece.y = piece.y - (pointPos.y - (snapped.y + CELLSIZE / 2))
end

function Game:updateGrid(piece, rotationIndex)
	piece.occupiedCells = {} -- Store grid positions in the piece

	for _, point in ipairs(piece.anchorPointsInPixels[rotationIndex]) do
		local gridX, gridY = getGridCellFromPosition(point.x, point.y)

		if gridX and gridY then
			Grid.board[gridY][gridX] = 1
			table.insert(piece.occupiedCells, { x = gridX, y = gridY }) -- Store occupied cell
		end
	end
end

function Game:keypressed(key, scancode, isrepeat)
	if key == "space" then
		activePiece = nil
		Grid.board = {}
		GenerateShapes:reset()
		Game:load()
	end
end

function Game:playRotationSound(piece)
	local size = #piece.anchorPoints[1]

	local basePitch = 1.2 - (size * 0.05)
	local pitchVariation = love.math.random() * 0.1
	local finalPitch = math.max(0.8, basePitch + pitchVariation)

	if Assets.sounds.rotate then
		Assets.sounds.rotate:setPitch(finalPitch)
		Assets.sounds.rotate:play()
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

		self:playRotationSound(activePiece)
	end
end

function Game:mousepressed(mx, my, mouseButton)
	if mouseButton ~= 1 then return end
	-- if self.state == "solved" then return end
	for i = #Pieces, 1, -1 do
		local piece = Pieces[i]
		local rotationIndex = piece.rotationIndex + 1

		if self:AABB({ x = mx, y = my }, piece.anchorPointsInPixels[rotationIndex]) then
			if piece.occupiedCells then
				for _, cell in ipairs(piece.occupiedCells) do
					Grid.board[cell.y][cell.x] = 0
				end
			end

			activePiece = piece
			moveToFront(i)

			activePiece.clickOffsetX = mx - activePiece.x
			activePiece.clickOffsetY = my - activePiece.y

			if Assets.sounds.animals[activePiece.id] and #Assets.sounds.animals[activePiece.id] > 0 then
				local size = #Assets.sounds.animals[activePiece.id]
				local r = love.math.random(1, size)
				local rp = 1 + love.math.random() * 0.05
				Assets.sounds.animals[activePiece.id][r]:setPitch(rp)
				Assets.sounds.animals[activePiece.id][r]:play()
			end
			break
		end
	end
end

function Game:mousereleased(x, y, button, isTouch)
	if not activePiece then return end
	local rotationIndex = activePiece.rotationIndex + 1
	local canPlacePiece, snapped, pointPos = self:canPieceBePlaced(activePiece, rotationIndex)

	if canPlacePiece and snapped and snapped.x and snapped.y then
		self:snapPieceToGrid(activePiece, snapped, pointPos)
		self:updateGrid(activePiece, rotationIndex)
		Assets.sounds.place:setPitch(1.2)
		Assets.sounds.place:play()
	else
		activePiece.occupiedCells = {}
	end

	activePiece:sync()
	self:getGameState()
	activePiece = nil
end

function Game:draw()
	love.graphics.draw(Assets.background.image, Assets.background.quad, 0, 0)
	drawGrid()
	-- GenerateShapes:draw()
	for _, piece in ipairs(Pieces) do
		piece:draw()
	end
	self:drawPieceIds()
	love.graphics.print(self.state)
end

function Game:update(dt)
	if activePiece then
		local mx, my = love.mouse.getPosition()
		activePiece.x = mx - activePiece.clickOffsetX
		activePiece.y = my - activePiece.clickOffsetY
		activePiece:sync()
	end

	for _, piece in ipairs(Pieces) do
		piece:update(dt)
	end
end

return Game

local Game = {}
Pieces = {}
local Grid = {} -- Change so we store data in tables so we can do Grid.debug or Grid.cell etc
local GenerateShapes = require("modules.generateshapes")
local activePiece = nil

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

function Game:keypressed(key, scancode, isrepeat)
	if key == "space" then
		GenerateShapes:reset()
		GenerateShapes:load()
	end
end

function Game:wheelmoved(x, y)
	if activePiece then
		if y > 0 then
			activePiece.rotation = ((activePiece.rotation -1 +1) % 4) +1 -- Rotate 90° clockwise
		elseif y < 0 then
			activePiece.rotation = ((activePiece.rotation -1 -1) % 4) +1 -- Rotate 90° counterclockwise
			if activePiece.rotation < 0 then activePiece.rotation = activePiece.rotation + 4 end
		end
		activePiece:updateState()
	end
end

function Game:mousepressed(mx, my, mouseButton)
	for i = #Pieces, 1, -1 do
		local piece = Pieces[i]
--		local anchorPointsPixels = piece:getAnchorPointsInPixels(piece.rotation)

		if self:AABB({ x = mx, y = my }, Pieces[i].anchorpoints) then
			activePiece = piece
			moveToFront(i)

			activePiece.clickOffsetX = mx - activePiece.x
			activePiece.clickOffsetY = my - activePiece.y

			break
		end
	end
end

function Game:mousereleased(x, y, button, isTouch)
	if activePiece and self:isInsideGrid(activePiece) then

	end
	activePiece = nil
end

function Game:draw()
	drawGrid()
	GenerateShapes:draw()
	for _, piece in ipairs(Pieces) do
		piece:draw()
	end
	-- DEBUG.add(countTotalAnchorPoints())
	-- love.graphics.setColor(1, 1, 1, 1)
end

function Game:update(dt)
	if activePiece and love.mouse.isDown(1) then
		local mx, my = love.mouse.getPosition()
		activePiece.x = mx - activePiece.clickOffsetX
		activePiece.y = my - activePiece.clickOffsetY
		activePiece:updateState()
	end
end

return Game

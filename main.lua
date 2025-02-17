StateManager = require("libs.statemanager")
LM = require("libs.lovemeasure")
LP = require("libs.loveprint")
DEBUG = require("libs.lovedebugdraw")
Json = require("libs.json")
require("loadassets")
require("globals")
require("libs.tprint")
Font = love.graphics.getFont()

function love.load()
	StateManager:addState("states.game")
	StateManager:setState("game")
	StateManager:load()
end

function love.keypressed(key, scancode, isrepeat)
	StateManager:call("keypressed", key, scancode, isrepeat)
end

function love.mousepressed(x, y, button, isTouch)
	StateManager:call("mousepressed", x, y, button, isTouch)
end

function love.mousereleased(x, y, button, isTouch)
	StateManager:call("mousereleased", x, y, button, isTouch)
end

function love.wheelmoved(x, y)
	StateManager:call("wheelmoved", x, y)
end

function love.update(dt)
	StateManager:call("update", dt)
end

function love.draw()
	StateManager:call("draw")
	LM:draw()
	DEBUG.draw()
end

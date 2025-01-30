StateManager = require("libs.statemanager")

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

function love.update(dt)
	StateManager:call("update", dt)
end

function love.draw()
	StateManager:call("draw")
end

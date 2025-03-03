local MainMenu = {}
local Button = require("class.button")

Button.new({
	x = WW / 2 - BUTTONS.w / 2,
	y = 100,
	text = "Load Game",
	state = "mainmenu",
	fn = function()
		StateManager
			:setState("game")
	end
})
Button.new({ x = WW / 2 - BUTTONS.w / 2, y = 200, text = "button1", state = "mainmenu" })
Button.new({ x = WW / 2 - BUTTONS.w / 2, y = 300, text = "button2", state = "mainmenu" })
Button.new({ x = WW / 2 - BUTTONS.w / 2, y = 400, text = "button3", state = "mainmenu" })

function MainMenu:load()
end

function MainMenu:mousepressed(mx, my, mouseButton)
	Button:mousepressed(mx, my, mouseButton)
end

function MainMenu:draw()
	Button:draw()
end

function MainMenu:update(dt)
	Button:update(dt)
end

return MainMenu

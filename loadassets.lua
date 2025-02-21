Assets = {
	shapes = {},
	background = {}
}

local path = "assets/shapes/"

local files = love.filesystem.getDirectoryItems(path)

for _, file in ipairs(files) do
	Assets.shapes[tonumber(string.match(file, "%d+"))] = love.graphics.newImage(path .. file)
	-- print(string.match(file, "%d+"))
end

Assets.background.image = love.graphics.newImage("assets/background/background.png")
Assets.background.quad = love.graphics.newQuad(0, 0, WW, WH, Assets.background.image:getWidth(),
	Assets.background.image:getHeight())

Assets.background.image:setWrap("repeat", "repeat")

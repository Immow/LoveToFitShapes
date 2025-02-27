local shapePath = "assets/shapes/"
local soundPathAnimals = "assets/sounds/animals/"

Assets = {
	shapes = {},
	background = {},
	sounds = {
		animals = {},
		rotate = love.audio.newSource("assets/sounds/rotate/rotate.wav", "stream")
	}
}


local shapeFiles = love.filesystem.getDirectoryItems(shapePath)
local folders = love.filesystem.getDirectoryItems(soundPathAnimals)

for i = 1, #folders do
	Assets.sounds.animals[i] = {}
	local files = love.filesystem.getDirectoryItems(soundPathAnimals .. i)
	for j, file in ipairs(files) do
		if file then
			Assets.sounds.animals[i][j] = love.audio.newSource(soundPathAnimals .. i .. "/" .. file, "stream")
		end
	end
end

-- print(Tprint(Assets.sounds.animals.click))


for _, file in ipairs(shapeFiles) do
	Assets.shapes[tonumber(string.match(file, "%d+"))] = love.graphics.newImage(shapePath .. file)
	-- print(string.match(file, "%d+"))
end

Assets.background.image = love.graphics.newImage("assets/background/background.png")
Assets.background.quad = love.graphics.newQuad(0, 0, WW, WH, Assets.background.image:getWidth(),
	Assets.background.image:getHeight())

Assets.background.image:setWrap("repeat", "repeat")

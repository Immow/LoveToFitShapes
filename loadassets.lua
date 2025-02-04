Assets = {}

local path = "assets/shapes/"

local files = love.filesystem.getDirectoryItems(path)

for _, file in ipairs(files) do
	Assets[tonumber(string.match(file, "%d+"))] = love.graphics.newImage(path .. file)
	-- print(string.match(file, "%d+"))
end

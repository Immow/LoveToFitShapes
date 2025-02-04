local Shapes = {
	["x1y1"] = { id = 1, shape = { { x = 1, y = 1 } } },
	["x1y1x2y1"] = { id = 2, shape = { { x = 1, y = 1 }, { x = 2, y = 1 } } },
	["x1y1x1y2"] = { id = 2, shape = { { x = 1, y = 1 }, { x = 1, y = 2 } } },
	["x1y1x2y1x3y1"] = { id = 3, shape = { { x = 1, y = 1 }, { x = 2, y = 1 }, { x = 3, y = 1 } } },
	["x1y1x1y2x1y3"] = { id = 3, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 1, y = 3 } } },
	["x1y1x2y1x2y2"] = { id = 4, shape = { { x = 1, y = 1 }, { x = 2, y = 1 }, { x = 2, y = 2 } } },
	["x1y1x1y2x2y1"] = { id = 4, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 2, y = 1 } } },
	["x1y1x1y2x2y2"] = { id = 4, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 2, y = 2 } } },
	["x1y2x2y1x2y2"] = { id = 4, shape = { { x = 1, y = 2 }, { x = 2, y = 1 }, { x = 2, y = 2 } } },
	["x1y1x2y1x3y1x4y1"] = { id = 5, shape = { { x = 1, y = 1 }, { x = 2, y = 1 }, { x = 3, y = 1 }, { x = 4, y = 1 } } },
	["x1y1x1y2x1y3x1y4"] = { id = 5, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 1, y = 3 }, { x = 1, y = 4 } } },
	["x1y1x1y2x2y1x2y2"] = { id = 6, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 2, y = 1 }, { x = 2, y = 2 } } },
	["x1y1x2y1x2y2x3y1"] = { id = 7, shape = { { x = 1, y = 1 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 3, y = 1 } } },
	["x1y1x1y2x1y3x2y2"] = { id = 7, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 1, y = 3 }, { x = 2, y = 2 } } },
	["x1y2x2y1x2y2x3y2"] = { id = 7, shape = { { x = 1, y = 2 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 3, y = 2 } } },
	["x1y2x2y1x2y2x2y3"] = { id = 7, shape = { { x = 1, y = 2 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 2, y = 3 } } },
	["x1y2x2y1x2y2x3y1"] = { id = 8, shape = { { x = 1, y = 2 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 3, y = 1 } } },
	["x1y1x1y2x2y2x2y3"] = { id = 8, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 2, y = 2 }, { x = 2, y = 3 } } },
	["x1y1x2y1x2y2x3y2"] = { id = 9, shape = { { x = 1, y = 1 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 3, y = 2 } } },
	["x1y2x1y3x2y1x2y2"] = { id = 9, shape = { { x = 1, y = 2 }, { x = 1, y = 3 }, { x = 2, y = 1 }, { x = 2, y = 2 } } },
	["x1y1x1y2x1y3x2y3"] = { id = 10, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 1, y = 3 }, { x = 2, y = 3 } } },
	["x1y2x2y2x3y1x3y2"] = { id = 10, shape = { { x = 1, y = 2 }, { x = 2, y = 2 }, { x = 3, y = 1 }, { x = 3, y = 2 } } },
	["x1y1x2y1x2y2x2y3"] = { id = 10, shape = { { x = 1, y = 1 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 2, y = 3 } } },
	["x1y1x1y2x2y1x3y1"] = { id = 10, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 2, y = 1 }, { x = 3, y = 1 } } },
	["x1y3x2y1x2y2x2y3"] = { id = 11, shape = { { x = 1, y = 3 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 2, y = 3 } } },
	["x1y1x2y1x3y1x3y2"] = { id = 11, shape = { { x = 1, y = 1 }, { x = 2, y = 1 }, { x = 3, y = 1 }, { x = 3, y = 2 } } },
	["x1y1x1y2x1y3x2y1"] = { id = 11, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 1, y = 3 }, { x = 2, y = 1 } } },
	["x1y1x1y2x2y2x3y2"] = { id = 11, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 2, y = 2 }, { x = 3, y = 2 } } },
	["x1y2x2y1x2y2x2y3x3y1"] = { id = 12, shape = { { x = 1, y = 2 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 2, y = 3 }, { x = 3, y = 1 } } },
	["x1y1x1y2x2y2x2y3x3y2"] = { id = 12, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 2, y = 2 }, { x = 2, y = 3 }, { x = 3, y = 2 } } },
	["x1y3x2y1x2y2x2y3x3y2"] = { id = 12, shape = { { x = 1, y = 3 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 2, y = 3 }, { x = 3, y = 2 } } },
	["x1y2x2y1x2y2x3y2x3y3"] = { id = 12, shape = { { x = 1, y = 2 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 3, y = 2 }, { x = 3, y = 3 } } },
	["x1y1x2y1x2y2x2y3x3y2"] = { id = 13, shape = { { x = 1, y = 1 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 2, y = 3 }, { x = 3, y = 2 } } },
	["x1y2x1y3x2y1x2y2x3y2"] = { id = 13, shape = { { x = 1, y = 2 }, { x = 1, y = 3 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 3, y = 2 } } },
	["x1y2x2y1x2y2x2y3x3y3"] = { id = 13, shape = { { x = 1, y = 2 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 2, y = 3 }, { x = 3, y = 3 } } },
	["x1y2x2y2x2y3x3y1x3y2"] = { id = 13, shape = { { x = 1, y = 2 }, { x = 2, y = 2 }, { x = 2, y = 3 }, { x = 3, y = 1 }, { x = 3, y = 2 } } },
	["x1y1x2y1x3y1x4y1x5y1"] = { id = 14, shape = { { x = 1, y = 1 }, { x = 2, y = 1 }, { x = 3, y = 1 }, { x = 4, y = 1 }, { x = 5, y = 1 } } },
	["x1y1x1y2x1y3x1y4x1y5"] = { id = 14, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 1, y = 3 }, { x = 1, y = 4 }, { x = 1, y = 5 } } },
	["x1y1x1y2x1y3x1y4x2y4"] = { id = 15, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 1, y = 3 }, { x = 1, y = 4 }, { x = 2, y = 4 } } },
	["x1y2x2y2x3y2x4y1x4y2"] = { id = 15, shape = { { x = 1, y = 2 }, { x = 2, y = 2 }, { x = 3, y = 2 }, { x = 4, y = 1 }, { x = 4, y = 2 } } },
	["x1y1x2y1x2y2x2y3x2y4"] = { id = 15, shape = { { x = 1, y = 1 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 2, y = 3 }, { x = 2, y = 4 } } },
	["x1y1x1y2x2y1x3y1x4y1"] = { id = 15, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 2, y = 1 }, { x = 3, y = 1 }, { x = 4, y = 1 } } },
	["x1y4x2y1x2y2x2y3x2y4"] = { id = 16, shape = { { x = 1, y = 4 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 2, y = 3 }, { x = 2, y = 4 } } },
	["x1y1x2y1x3y1x4y1x4y2"] = { id = 16, shape = { { x = 1, y = 1 }, { x = 2, y = 1 }, { x = 3, y = 1 }, { x = 4, y = 1 }, { x = 4, y = 2 } } },
	["x1y1x1y2x1y3x1y4x2y1"] = { id = 16, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 1, y = 3 }, { x = 1, y = 4 }, { x = 2, y = 1 } } },
	["x1y1x1y2x2y2x3y2x4y2"] = { id = 16, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 2, y = 2 }, { x = 3, y = 2 }, { x = 4, y = 2 } } },
	["x1y1x2y1x2y2x3y2x4y2"] = { id = 17, shape = { { x = 1, y = 1 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 3, y = 2 }, { x = 4, y = 2 } } },
	["x1y3x1y4x2y1x2y2x2y3"] = { id = 17, shape = { { x = 1, y = 3 }, { x = 1, y = 4 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 2, y = 3 } } },
	["x1y1x2y1x3y1x3y2x4y2"] = { id = 17, shape = { { x = 1, y = 1 }, { x = 2, y = 1 }, { x = 3, y = 1 }, { x = 3, y = 2 }, { x = 4, y = 2 } } },
	["x1y2x1y3x1y4x2y1x2y2"] = { id = 17, shape = { { x = 1, y = 2 }, { x = 1, y = 3 }, { x = 1, y = 4 }, { x = 2, y = 1 }, { x = 2, y = 2 } } },
	["x1y2x2y2x3y1x3y2x4y1"] = { id = 18, shape = { { x = 1, y = 2 }, { x = 2, y = 2 }, { x = 3, y = 1 }, { x = 3, y = 2 }, { x = 4, y = 1 } } },
	["x1y1x1y2x2y2x2y3x2y4"] = { id = 18, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 2, y = 2 }, { x = 2, y = 3 }, { x = 2, y = 4 } } },
	["x1y2x2y1x2y2x3y1x4y1"] = { id = 18, shape = { { x = 1, y = 2 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 3, y = 1 }, { x = 4, y = 1 } } },
	["x1y1x1y2x1y3x2y3x2y4"] = { id = 18, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 1, y = 3 }, { x = 2, y = 3 }, { x = 2, y = 4 } } },
	["x1y1x1y2x2y1x2y2x3y1"] = { id = 19, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 3, y = 1 } } },
	["x1y1x1y2x1y3x2y2x2y3"] = { id = 19, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 1, y = 3 }, { x = 2, y = 2 }, { x = 2, y = 3 } } },
	["x1y2x2y1x2y2x3y1x3y2"] = { id = 19, shape = { { x = 1, y = 2 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 3, y = 1 }, { x = 3, y = 2 } } },
	["x1y1x1y2x2y1x2y2x2y3"] = { id = 19, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 2, y = 3 } } },
	["x1y1x2y1x2y2x3y1x3y2"] = { id = 20, shape = { { x = 1, y = 1 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 3, y = 1 }, { x = 3, y = 2 } } },
	["x1y1x1y2x1y3x2y1x2y2"] = { id = 20, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 1, y = 3 }, { x = 2, y = 1 }, { x = 2, y = 2 } } },
	["x1y1x1y2x2y1x2y2x3y2"] = { id = 20, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 3, y = 2 } } },
	["x1y2x1y3x2y1x2y2x2y3"] = { id = 20, shape = { { x = 1, y = 2 }, { x = 1, y = 3 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 2, y = 3 } } },
	["x1y1x2y1x2y2x2y3x3y1"] = { id = 21, shape = { { x = 1, y = 1 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 2, y = 3 }, { x = 3, y = 1 } } },
	["x1y1x1y2x1y3x2y2x3y2"] = { id = 21, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 1, y = 3 }, { x = 2, y = 2 }, { x = 3, y = 2 } } },
	["x1y3x2y1x2y2x2y3x3y3"] = { id = 21, shape = { { x = 1, y = 3 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 2, y = 3 }, { x = 3, y = 3 } } },
	["x1y2x2y2x3y1x3y2x3y3"] = { id = 21, shape = { { x = 1, y = 2 }, { x = 2, y = 2 }, { x = 3, y = 1 }, { x = 3, y = 2 }, { x = 3, y = 3 } } },
	["x1y1x1y2x2y2x3y1x3y2"] = { id = 22, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 2, y = 2 }, { x = 3, y = 1 }, { x = 3, y = 2 } } },
	["x1y1x1y3x2y1x2y2x2y3"] = { id = 22, shape = { { x = 1, y = 1 }, { x = 1, y = 3 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 2, y = 3 } } },
	["x1y1x1y2x2y1x3y1x3y2"] = { id = 22, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 2, y = 1 }, { x = 3, y = 1 }, { x = 3, y = 2 } } },
	["x1y1x1y2x1y3x2y1x2y3"] = { id = 22, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 1, y = 3 }, { x = 2, y = 1 }, { x = 2, y = 3 } } },
	["x1y1x1y2x1y3x2y3x3y3"] = { id = 23, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 1, y = 3 }, { x = 2, y = 3 }, { x = 3, y = 3 } } },
	["x1y3x2y3x3y1x3y2x3y3"] = { id = 23, shape = { { x = 1, y = 3 }, { x = 2, y = 3 }, { x = 3, y = 1 }, { x = 3, y = 2 }, { x = 3, y = 3 } } },
	["x1y1x2y1x3y1x3y2x3y3"] = { id = 23, shape = { { x = 1, y = 1 }, { x = 2, y = 1 }, { x = 3, y = 1 }, { x = 3, y = 2 }, { x = 3, y = 3 } } },
	["x1y1x1y2x1y3x2y1x3y1"] = { id = 23, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 1, y = 3 }, { x = 2, y = 1 }, { x = 3, y = 1 } } },
	["x1y1x2y1x2y2x3y2x3y3"] = { id = 24, shape = { { x = 1, y = 1 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 3, y = 2 }, { x = 3, y = 3 } } },
	["x1y2x1y3x2y1x2y2x3y1"] = { id = 24, shape = { { x = 1, y = 2 }, { x = 1, y = 3 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 3, y = 1 } } },
	["x1y1x1y2x2y2x2y3x3y3"] = { id = 24, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 2, y = 2 }, { x = 2, y = 3 }, { x = 3, y = 3 } } },
	["x1y3x2y2x2y3x3y1x3y2"] = { id = 24, shape = { { x = 1, y = 3 }, { x = 2, y = 2 }, { x = 2, y = 3 }, { x = 3, y = 1 }, { x = 3, y = 2 } } },
	["x1y2x2y1x2y2x2y3x3y2"] = { id = 25, shape = { { x = 1, y = 2 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 2, y = 3 }, { x = 3, y = 2 } } },
	["x1y2x2y2x3y1x3y2x4y2"] = { id = 26, shape = { { x = 1, y = 2 }, { x = 2, y = 2 }, { x = 3, y = 1 }, { x = 3, y = 2 }, { x = 4, y = 2 } } },
	["x1y2x2y1x2y2x2y3x2y4"] = { id = 26, shape = { { x = 1, y = 2 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 2, y = 3 }, { x = 2, y = 4 } } },
	["x1y1x2y1x2y2x3y1x4y1"] = { id = 26, shape = { { x = 1, y = 1 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 3, y = 1 }, { x = 4, y = 1 } } },
	["x1y1x1y2x1y3x1y4x2y3"] = { id = 26, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 1, y = 3 }, { x = 1, y = 4 }, { x = 2, y = 3 } } },
	["x1y2x2y1x2y2x3y2x4y2"] = { id = 27, shape = { { x = 1, y = 2 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 3, y = 2 }, { x = 4, y = 2 } } },
	["x1y3x2y1x2y2x2y3x2y4"] = { id = 27, shape = { { x = 1, y = 3 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 2, y = 3 }, { x = 2, y = 4 } } },
	["x1y1x2y1x3y1x3y2x4y1"] = { id = 27, shape = { { x = 1, y = 1 }, { x = 2, y = 1 }, { x = 3, y = 1 }, { x = 3, y = 2 }, { x = 4, y = 1 } } },
	["x1y1x1y2x1y3x1y4x2y2"] = { id = 27, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 1, y = 3 }, { x = 1, y = 4 }, { x = 2, y = 2 } } },
	["x1y1x2y1x2y2x2y3x3y3"] = { id = 28, shape = { { x = 1, y = 1 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 2, y = 3 }, { x = 3, y = 3 } } },
	["x1y2x1y3x2y2x3y1x3y2"] = { id = 28, shape = { { x = 1, y = 2 }, { x = 1, y = 3 }, { x = 2, y = 2 }, { x = 3, y = 1 }, { x = 3, y = 2 } } },
	["x1y3x2y1x2y2x2y3x3y1"] = { id = 29, shape = { { x = 1, y = 3 }, { x = 2, y = 1 }, { x = 2, y = 2 }, { x = 2, y = 3 }, { x = 3, y = 1 } } },
	["x1y1x1y2x2y2x3y2x3y3"] = { id = 29, shape = { { x = 1, y = 1 }, { x = 1, y = 2 }, { x = 2, y = 2 }, { x = 3, y = 2 }, { x = 3, y = 3 } } }
}

return Shapes

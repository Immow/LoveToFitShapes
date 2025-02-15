local shapeTypes = {
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{
		imageAsset = 15,
		rotations = {
			{ -- rotation 1
				name = "x1y1x1y2x1y3x1y4x2y4",
				imageOffset = { x = -50, y =-100 }, -- For rotation 1 this is upperleft corner of the image
				anchorpoints = {
					{ offsetX = -25, offsetY = -75 },
					{ offsetX = -25, offsetY = -25 },
					{ offsetX = -25, offsetY =  25 },
					{ offsetX = -25, offsetY =  75 },
					{ offsetX =  25, offsetY =  75 }
				}
			},
			{ -- rotation 2
				name = "x1y2x2y2x3y2x4y1x4y2",
				imageOffset = { x = -100, y = 50 }, -- For rotation 2 this is lowerleft corner of the image
				anchorpoints = {
					{ offsetX = -75, offsetY =  25 },
					{ offsetX = -25, offsetY =  25 },
					{ offsetX =  25, offsetY =  25 },
					{ offsetX =  75, offsetY =  25 },
					{ offsetX =  75, offsetY = -25 }
				}
			},
			{ -- rotation 3
				name = "x1y1x2y1x2y2x2y3x2y4",
				imageOffset = { x = 50, y = 100 }, -- For rotation 3 this is lowerright corner of the image
				anchorpoints = {
					{ offsetX = -25, offsetY = -75 },
					{ offsetX =  25, offsetY = -75 },
					{ offsetX =  25, offsetY = -25 },
					{ offsetX =  25, offsetY =  25 },
					{ offsetX =  25, offsetY =  75 }
				}
			},
			{ -- rotation 4
				name = "x1y1x1y2x2y1x3y1x4y1",
				imageOffset = { x = 100, y =-50 }, -- For rotation 4 this is upperright corner of the image
				anchorpoints = {
					{ offsetX = -75, offsetY = -25 },
					{ offsetX = -75, offsetY =  25 },
					{ offsetX = -25, offsetY = -25 },
					{ offsetX =  25, offsetY = -25 },
					{ offsetX =  75, offsetY = -25 }
				}
			}
		}
	}
}

return shapeTypes
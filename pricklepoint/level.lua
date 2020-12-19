--storedTiles = {} 
currentLevel = 1
curLvlBnds = {}
levelBounds = {{topLeft = {0,0}, bottomRight = {17,18}}}
function initializeLevel() 
	 --for each tile on map 
	 curLvlBnds = levelBounds[currentLevel]
	 for i = curLvlBnds.topLeft[1], 1, curLvlBnds.bottomRight[1] do
	 	for j = curLvlBnds.topLeft[2], 1, curLvlBnds.bottomRight[2] do  
	 		--if map(i,j) has flag set for porc 
	 			--add new porc to porc table 
	 		--optional: if map(i,j) has flag set for render over everything (like leaves and shit)
	 			--add sprite to extra draw table 
	 		--if tile was flagged, set to regular floor
	 	end
	 end
	 --search for porc sprite, place porc 
	 --replace map sprite with grass

	 -- can also do the same for like, overlapping sprites on player 
end 

function drawLevel() 
	lvl = levelBounds[currentLevel]

	camera(mid(lvl.topLeft[1] * 8, px - screenWidth/2, (lvl.bottomRight[1])*8 - screenWidth+8),
		mid(lvl.topLeft[2] * 8, py - screenWidth/2, (lvl.bottomRight[2])*8 - screenWidth+8))
	map( mid(0, px - screenWidth/2, lvl.topLeft[1], 
		mid(0, py - screenWidth/2, lvl.topLeft[2]), 0, 0, 16, 16))

	--draw map based on player
	--camera does NOT show past levelbounds
end

-- function endLevel() 

-- end 
photoWidth, photoHeight = 50, 40
offsetx, offsety = 10, 3
pictureTaken = false
photoTLX, photoTLY = 0

frameLen = .3
frameStart = 0 
curFrame = 0 

function takePhoto()
	if not pictureTaken and (btn(4)) then 
		--take photo
	    photoTLX =  flipPlayer and px + abs(offsetx) or px + (-abs(offsetx - 8) - photoWidth) 
	    photoTLY = py + offsety - photoHeight
		pictureTaken = true;
		frameStart = time() 
	end
end

function drawPhoto() 
	if (pictureTaken) then		
		rect(photoTLX, photoTLY, photoTLX + photoWidth,
			photoTLY + photoHeight, 127, 1)

		-- fill surrounding
		if (time() - frameStart < 1/4 * frameLen) then 
			fillp(0b0111111111011111.1)
		elseif (time() - frameStart < 2/4 * frameLen) then 
			fillp(0b1111011110100111.1) -- big dots
		elseif (time() - frameStart < 3/4 * frameLen) then
			fillp(0b0101101001011010.1) -- every other
		elseif (time() - frameStart < frameLen) then
			fillp(0b0000000000000000)
		else
			pictureTaken = false
		end

		rectfill(px - screenWidth/2, py - screenWidth/2, photoTLX, py + screenWidth/2, 6)
		rectfill(photoTLX, py - screenWidth/2, px + screenWidth/2, photoTLY, 6)
		rectfill(photoTLX, photoTLY + photoHeight, px + screenWidth/2, py + screenWidth/2, 6)
		rectfill(photoTLX + photoWidth, photoTLY, px + screenWidth/2, photoTLY + photoHeight, 6)
		-- rectfill(px - screenWidth/2, py - screenWidth/2, px + screenWidth/2, py + screenWidth/2, 7)

		-- fillp(0b1111111111111111.1)
		-- rect(photoTLX, photoTLY, photoTLX + photoWidth, photoTLY + photoHeight, 7)

		-- fillp(0b1111011110100111.1) -- or 0x33cc.8

		fillp(0b0000000000000000) --reset
	end
end
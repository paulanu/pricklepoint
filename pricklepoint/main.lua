px = 64
py = 80
screenWidth = 128
playerSpeed = 1
playerHealth = 3
flipPlayer = false;  

function _init() 
	initializeLevel() 
	addPorcupine(20, 70, 1, 1, 1, .5, 2)
	addPorcupine(30, 70, 1, 1, 1, .5, 2)
end

hitQuills = {} 
----PLAYER FUNCTS----
function updatePlayer() 
	local dx, dy = 0, 0 
	--horiz movement
	if (btn(0)) then
    	dx = -1
    	flipPlayer = false; 
    elseif (btn(1)) then
    	dx = 1
    	flipPlayer = true; 
    end
    --vertical movement
    if (btn(2)) then 
    	dy = -1
    elseif(btn(3)) then
    	dy = 1
    end

	--normalize diagonal movement (no increased speed)
	--dx, dy = normalizeDiagonalMovement(dx, dy)

	--map collisions
    xhit, yhit = mapCollisionCheck(px + dx, py + dy, 7, 7, px, py)
    if xhit then
    	dx = 0
    end
    if yhit then
    	dy = 0 
    end
       
    px = px + dx * playerSpeed
    py = py + dy * playerSpeed

    --move pricked quills as needed
    for _, quill in ipairs(hitQuills) do 
    	quill.x += dx
    	quill.y += dy 
    end
end

function drawPlayer() 
	--draw quills
	--TO DO: position still fucking glitchy lol
	for _, quill in ipairs(hitQuills) do 
		if (quill.flipped != flipPlayer) then
			quill.angle = .5 - quill.angle 
			quill.x = quill.x < px and quill.x + 2 * abs(px - quill.x) or quill.x - 2 * abs(quill.x - px) 
			quill.flipped = flipPlayer
		end
		rspr(4*8, 8, quill.x, quill.y, quill.angle, 1, 1) -- MIRROR ANGLE WHEN PLAYER FLIPS
    end


	spr(1, px, py, 1, 1, flipPlayer)

end

playerw = 4
playerh = 7
--https://stackoverflow.com/questions/5650032/collision-detection-with-rotated-rectangles ty stackoverlord
function angledCollisionCheck(x, y, w, h, --[[optional from now on lol]]angle, hitX, hitY, hitW, hitH)
	local angle = angle or 0
	local hitX = hitX or px
	local hitY = hitY or py 
	local hitW = hitW or playerw
	local hitH = hitH or playerh

    if angle == 0 then
        return abs(x-hitX) < (w/2 + hitW/2) and abs(y-hitY) < (h/2 + hitH/2)  
    end 

    tx = cos(angle)*hitX - sin(angle)*hitY 
    ty = cos(angle)*hitY + sin(angle)*hitX

    cx = cos(angle)*x - sin(angle)*y
    cy = cos(angle)*y + sin(angle)*x

    return abs(cx-tx) < (w/2 + hitW/2) and abs(cy-ty) < (h/2 + hitH/2)
end

----ENEMY FUNCTS---- 

quills = {}
porcupines = {} 
photoCount = 0
-- lastFired = -1
porcSpeed = 1 
stateDuration = 2 -- how long does each state last
runDuration = .5
pauseDuration = 2
stateStartTime = 0 -- when did state start
-- chargeUp = 3 --TODO: think of better var name for this lol (time between firing) 
readyToFire = true;
ex, ey = 20, 70
dx, dy = 1, 1 
states = {"running", "resting", "firing", "dazed"}
state = "resting"

function addPorcupine(x, y, dx, dy, speed, runDuration, pauseDuration)
	local p = {} 
	p.x, p.y, p.dx, p.dy, p.speed, p.runDur, p.pauseDur, p.state, p.curStateDur, p.stateStartTime, p.readyToFire = 
		x, y, dx, dy, speed, runDuration, pauseDuration, states[2], pauseDuration, time(), true
	add(porcupines, p)
end

function updatePorcupine() 
	for _, p in pairs(porcupines) do 
		if pictureTaken and p.state ~= states[4] then --v decide WHERE IN SPRITE u want porc collisino to be - is it middle? top? bottom? then adjust!!!!
			if abs(p.x + 4 - (photoTLX)) < photoWidth and p.x + 4 - (photoTLX) > 0 and -- add porc h,w to account for size!
				abs(p.y + 5 - (photoTLY)) < abs(photoHeight) and p.y + 4 - (photoTLY) > 0 then 
				p.state = states[4]
				photoCount += 1
			end
		end

		if p.state == states[1] then --TODO: hits
			p.x = p.x + p.dx 
			p.y = p.y + p.dy 
			-- CHECK FOR HIT HERE - IF BOTH XHIT AND YHIT THEN STOP!
		end 

		--fsm updating, only update if porc not dazed!
		if (time() - p.stateStartTime > p.curStateDur) and p.state ~= states[4] then
			p.state = p.state == states[1] and states[2] or states[1]
			p.curStateDur = p.runDur + p.pauseDur - p.curStateDur
			p.stateStartTime = time()
			p.readyToFire = true 

			-- get direction, porc can only go in 8 cardinal directions or there's jittery movement :(
			local theta = atan2(px-p.x, py-p.y)
			sgny = -sgn(.5 - theta) 
			sgnx = theta > .25 and theta < .75 and -1 or 1
			p.dx = sgnx * p.speed * flr(rnd(2)) -- randomly choose 1 of 3 directions towards
			p.dy = sgny * p.speed
			if  p.dx ~= 0 then 
				p.dy = p.dy * flr(rnd(2))
			end
		end 

		if p.state == states[2] and p.readyToFire then
			-- if lastFired < 0 then -- USE THIS IF U ACTUALLY WANT TO TIME FIRING!!!
				shootTrio(p.x, p.y)
				p.readyToFire = false
				-- lastFired = time() 
			-- elseif (time() - lastFired > chargeUp) then
		 -- 		lastFired = -1
		 	-- end
		end
	end
end

function drawPorcupine() 
	for _, p in pairs(porcupines) do 
		if p.state == states[4] then --dazed
			spr(18, p.x, p.y)
		else
			spr(3, p.x, p.y)
		end
	end
end 

hitObstacleQuills = {}
removeHitQuillTimer = 0
removeQuillOn = 1
function updateQuills() 
	for _, quill in pairs(quills) do
		updateTrio(quill)

		local mapRow, mapCol = (quill.x + quill.dx * 2)/8, (quill.y + quill.dy * 2)/8
		if quill.active and angledCollisionCheck(quill.x, quill.y, 8, 2, quill.angle) then
			playerHealth = mid(0, playerHealth-1, 3)

			quill.active = false; --quill is stuck to player now :( ) --TODO 
			quill.flipped = flipPlayer; 
			add(hitQuills, quill)
			del(quills, quill) 
		elseif (fget(mget(mapRow, mapCol), 1)) then 
			if (angledCollisionCheck(quill.x, quill.y, 8, 3, quill.angle, 
				mapRow * 8 , mapCol * 8, 8, 8)) then
				del(quills, quill)
				add(hitObstacleQuills, quill) 
			end
		end 
  		-- tree / map collisions - have to check a little before quill since it's angled and i'm lost and confused
	end

	if (time() - removeHitQuillTimer > removeQuillOn) then
		del(hitObstacleQuills, hitObstacleQuills[1])  -- evens = {2, 3, 4, 5, 6}
		removeHitQuillTimer = time() 
	end

end 

function drawQuills()
    for i, quill in pairs(quills) do
    	-- if (quill.active) then
			rspr(4 * 8, 0, quill.x, quill.y, quill.angle, 1, 1) 
 		-- end
    end

    for i, quill in pairs(hitObstacleQuills) do
		rspr(4 * 8, 8, quill.x, quill.y, quill.angle, 1, 1) 
	end
end

hitCount = 0 
--playerHitInvinsibilty = 3
----PICO-8 FUNCTS----
function _update()
	updatePlayer()
	takePhoto()
	updatePorcupine()
	updateQuills()
end

function _draw()
	cls()
	drawLevel()
	drawPlayer()
	drawPorcupine()
    drawQuills() 
    drawPhoto()
end
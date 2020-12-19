function shootTrio(startx, starty) 
	local r = sqrt( (px-startx)^2 + (py-starty)^2 )
	local theta = atan2(px-startx, py-starty)

	for i = -.05, .05, .05 do
		local dx = cos(theta + i) 
		local dy = sin(theta + i)
		local angleOfDirection = 1-((theta - .1) % 1)
		local quill = {} 
		quill.x, quill.y, quill.dx, quill.dy, quill.active, quill.start, quill.angle =
			startx, starty, dx, dy, true, time(), angleOfDirection
		add(quills, quill)
	end
end

-- call this if bullet designated by #1 
function updateTrio(quill) 
	local speed = 3
	finish = 1 
	if quill.active then
		quill.x += quill.dx * speed
		quill.y += quill.dy * speed
		
		if (time() - quill.start > finish) then
		-- quill.active = false; --TODO : get rid of quill??!??!?!??!??!
			del(quills, quill)
		end
	end
	-- elseif (quill.active) then 
	-- end
end

function rspr(sx,sy,x,y,a,w, --[[optional]]coloralpha)
	local alpha = coloralpha or 0 
    local ca,sa=cos(a),sin(a)
    local srcx,srcy
    local ddx0,ddy0=ca,sa
    local mask=shl(0xfff8,(w-1))
    w*=4
    ca*=w-0.5
    sa*=w-0.5
    local dx0,dy0=sa-ca+w,-ca-sa+w
    w=2*w-1
    for ix=0,w do
        srcx,srcy=dx0,dy0
        for iy=0,w do
            if band(bor(srcx,srcy),mask)==0 then
                local c=sget(sx+srcx,sy+srcy)
                if (c != alpha) then
                	pset(x+ix,y+iy,c)
                end
            end
            srcx-=ddy0
            srcy+=ddx0
        end
        dx0+=ddx0
        dy0+=ddy0
    end
end

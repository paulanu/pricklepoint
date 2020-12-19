function mapCollisionCheck(x,y,w,h, --[[optional]]originalX, --[[optional]]originalY)
  local orgX = originalX or x
  local orgY = originalY or y 
  local xhit, yhit = false
  for i=x,x+w,w do
    if (fget(mget(i/8,orgY/8))>0) or
         (fget(mget(i/8,(orgY+h)/8))>0) then
          xhit=true
    end
  end

  for i=orgX,orgX+w,w do
    if (fget(mget(i/8,y/8))>0) or
         (fget(mget(i/8,(y+h)/8))>0) then
          yhit=true
    end
  end

  return xhit, yhit
end

function normalizeDiagonalMovement(dx, dy) 
  if (dx*dx+dy*dy>1) then
    dist=sqrt(dx*dx+dy*dy)
    dx/=dist
    dy/=dist
  end
          printh("dx, dy: " .. dx .. " " .. dy) 
  return dx, dy
end
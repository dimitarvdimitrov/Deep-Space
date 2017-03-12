LowerObstacles = {}
LowerObstacles.fun = math.sin
LowerObstacles.speed = Background.speed
LowerObstacles.startY = 50
LowerObstacles.scale  = 14
LowerObstacles.xPos   = 10	--%1600
local NUM_VERTS=100

function LowerObstacles:move(dt)
    LowerObstacles.xPos=(LowerObstacles.xPos+dt*LowerObstacles.speed)%2000
end
function LowerObstacles:draw()
	local verticies = {}
	--Lower right
	verticies [#verticies+1]=love.graphics.getWidth()
	verticies [#verticies+1]=  love.graphics.getHeight()
	--Lower left
	verticies [#verticies+1]=0
	verticies [#verticies+1]=love.graphics.getHeight()

	for i=0,NUM_VERTS do
		verticies [#verticies+1]=i*(love.graphics.getWidth()/NUM_VERTS)
		verticies [#verticies+1]=LowerObstacles:getY(verticies[#verticies])

		--love.graphics.circle("fill", verticies [#verticies-1], verticies [#verticies], 4, 20)
	end

	--love.graphics.polygon("fill", unpack(verticies) )
end

function LowerObstacles:getY(pointX)
	return love.graphics.getHeight()-( LowerObstacles.startY + LowerObstacles.scale*LowerObstacles.fun((pointX+LowerObstacles.xPos)/20) )
end

function LowerObstacles:isPointOverLapped(pointX,pointY)
	if LowerObstacles:getY(pointX) < pointY then
		return true
	else 
		return false
	end
end
function LowerObstacles:isPlayerOverLapping(player)
	--Player.yPos = 0 --some default values - not to be used
	--Player.xPos = 100 --some default values - not to be used
	if LowerObstacles:isPointOverLapped(player.xPos, player.yPos +player.height) then
		return true
	end

	if LowerObstacles:isPointOverLapped(player.xPos + player.width , player.yPos +player.height) then
		return true
	end
	return false
end
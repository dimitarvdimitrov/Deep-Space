UpperObstacles = {}
UpperObstacles.fun = math.sin
UpperObstacles.speed = Background.speed
UpperObstacles.startY = 50
UpperObstacles.scale  = 14
UpperObstacles.xPos   = 10  --%1600
local NUM_VERTS=100
function UpperObstacles:move(dt)
    UpperObstacles.xPos=(UpperObstacles.xPos+dt*UpperObstacles.speed)%2000
end
function UpperObstacles:draw()
    local verticies = {}
    --Upper right
    verticies [#verticies+1]=love.graphics.getWidth()
    verticies [#verticies+1]=0
    --Upper left
    verticies [#verticies+1]=0
    verticies [#verticies+1]=0

    for i=0,NUM_VERTS do
        verticies [#verticies+1]=i*(love.graphics.getWidth()/NUM_VERTS)
        verticies [#verticies+1]=UpperObstacles:getY(verticies[#verticies])

        --love.graphics.circle("fill", verticies [#verticies-1], verticies [#verticies], 4, 20)
    end

    --love.graphics.polygon("fill", unpack(verticies) )
end

function UpperObstacles:getY(pointX)
    return ( UpperObstacles.startY + UpperObstacles.scale*UpperObstacles.fun( (pointX+UpperObstacles.xPos)/20) )
end

function UpperObstacles:isPointOverLapped(pointX,pointY)
    if UpperObstacles:getY(pointX) > pointY then
        return true
    else 
        return false
    end
end
function UpperObstacles:isPlayerOverLapping(player)
    --Player.yPos = 0 --some default values - not to be used
    --Player.xPos = 100 --some default values - not to be used
    if UpperObstacles:isPointOverLapped(player.xPos, player.yPos) then
        return true
    end

    if UpperObstacles:isPointOverLapped(player.xPos + player.width , player.yPos) then
        return true
    end
    return false
end
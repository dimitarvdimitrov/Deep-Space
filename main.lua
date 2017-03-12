require 'Player'
require 'Background'
require 'UpperObstacles'
require 'LowerObstacles'
require 'Alien'
require 'Boss'
require 'Bonus'
require 'BackGroundObject'

require 'Menu'
require 'Home'
require 'GameOver'
--Screen size is 800x600
--Background size is 1600x600

aliens = {}
bossIsOn = false
currentDifficulty = 1
timeSinceLastAlien = 0
gameOnceLoaded = false

function game_load()
    if gameOnceLoaded then
        resetGame()
        return
    end

    shootingSound = love.audio.newSource('lazer.mp3')

    Player.xPos = love.graphics.getWidth() / 10
    Player.yPos = love.graphics.getHeight() / 2
    Player.image = love.graphics.newImage(Player.imagePath)
    Player.height = Player.image:getHeight()
    Player.width = Player.image:getWidth()

    Background.image2 = love.graphics.newImage(Background.image2Path)
    Background.image = love.graphics.newImage(Background.imagePath)
    Background.initialize()
    for i=1,10 do 
        Background.newBackgroundObject()
    end

    Boss.image = love.graphics.newImage(Boss.imagePath)

    Bullet.image = love.graphics.newImage(Bullet.imagePath)
    Alien.image = love.graphics.newImage(Alien.imagePath)
    Alien.height = Alien.image:getHeight()
    Alien.width = Alien.image:getWidth()

    font = love.graphics.newFont('Xcelsion.ttf', 20)

    gameOnceLoaded = true
end

function game_update(dt)
    if love.keyboard.isDown('space') then
        Player:fire()
    end

    if love.keyboard.isDown('down') then
        Player:moveDown(dt)
    end

    if love.keyboard.isDown('up') then
        Player:moveUp(dt)
    end

    Player.timeSinceLastBullet = Player.timeSinceLastBullet + dt

    if bossIsOn then
        Boss.shootCooldown = Boss.shootCooldown + dt
        Boss:move()
        Boss:fire() --doesnt actually fire each time; checks the cooldown first
    end

    if (timeSinceLastAlien >= 3) then
        aliens[Alien.new(Player.speed * currentDifficulty * 20)] = true
        timeSinceLastAlien = 0
    else 
        timeSinceLastAlien = timeSinceLastAlien + dt
    end

    moveBullets(Player.bullets, dt)
    moveBossBullets(Boss.bullets, dt)

    Background:move(dt)
    UpperObstacles:move(dt)
    LowerObstacles:move(dt)
    moveAliens(aliens, dt)

    if not bossIsOn then
        checkForShotAliens(aliens, Player.bullets)
    else
        checkForShotBoss(Player.bullets)
        checkForShotPlayer(Boss.bullets)
    end
end

function game_draw()

    love.graphics.setColor(255, 255, 255)

    love.graphics.draw(Background.image, Background.xPos, Background.yPos)
    love.graphics.draw(Background.image, Background.xPos2, Background.yPos)
    Background.draw()
    drawBullets(Player.bullets)

    love.graphics.draw(Player.image, Player.xPos, Player.yPos)
    if UpperObstacles:isPlayerOverLapping(Player) or LowerObstacles:isPlayerOverLapping(Player) then 
        --love.graphics.rectangle('fill', Player:getXPos(), Player:getYPos(), Player.width, Player.height)
        Player:changeScore(-0.0050)
    end

    UpperObstacles:draw()
    LowerObstacles:draw()

    love.graphics.setFont(font)
    --love.graphics.draw(love.graphics.newImage('background texture.png'), 0, 0)

    love.graphics.draw(Background.image2, Background.img2xPos, Background.yPos)
    love.graphics.draw(Background.image2, Background.img2xPos2, Background.yPos)
    love.graphics.print('Score: ' .. math.floor(Player.score + 0.5), 10, 10)
    love.graphics.print('Difficulty: ' .. currentDifficulty, 10, 575)


    if not bossIsOn then
        drawAliens(aliens)
    else
        Boss:draw()
        love.graphics.print('Boss Health: ' .. Boss.health .. '/' .. Boss.maxHealth, 300, 10)
        Boss:drawBullets()
    end


end

function drawBullets(tableOfBullets)
    if type(tableOfBullets) ~= 'table' then
        return
    end

    for bul, _ in pairs(tableOfBullets) do
        Bullet.draw(bul)
    end
end

function drawAliens(tableOfAliens)
    for value, key in pairs(tableOfAliens) do
        --love.graphics.rectangle('fill', value.xpose, value.ypose, value.width, value.height)
        love.graphics.draw(Alien.image, value.xpose, value.ypose)
    end
end

function moveBullets(tableOfBullets , dt)
    if type(tableOfBullets) ~= 'table' then
        return
    end

    local toDelete={}
    local width = love.graphics.getWidth()
    for bull, _ in pairs(tableOfBullets) do
        Bullet.move(bull,dt,1)
        if bull.xPos > width or bull.xPos < 0 then
            toDelete[bull]=true
        end
    end
    for bull, _ in pairs(toDelete) do
        tableOfBullets[bull]=nil
    end
end

function moveBossBullets(tableOfBullets, dt)
    local toDelete={}
    local width = love.graphics.getWidth()
    for bull, _ in pairs(tableOfBullets) do
        Bullet.specialMove(bull,dt,1)
        if bull.xPos > width or bull.xPos < 0 then
            toDelete[bull]=true
        end
    end

    for bull, _ in pairs(toDelete) do
        tableOfBullets[bull]=nil
    end
end

function moveAliens(tableOfAliens, dt)
    local aliensToDelete = {}
    for alien, _ in pairs(tableOfAliens) do
        Alien.move(alien, dt)

        --remove the alien form current aliens when
        if alien.xpose < 0 then
            aliensToDelete[alien] = true
        end
    end
    for alien, _ in pairs(aliensToDelete) do
        Player:changeScore(-20 * currentDifficulty)
        tableOfAliens[alien] = nil
    end
end

function checkForShotAliens (tableOfAliens, tableOfBullets)
    local bullsToDelete = {}
    local aliensToDelete = {}

    for bul, _ in pairs(tableOfBullets) do
        for ali, __ in pairs(tableOfAliens) do
            if pointIsInRectangle(bul.xPos, bul.yPos, unpack(Alien.getRectangle(ali))) then
                updatePointsOnAlienKill()
                aliensToDelete[ali] = true
                bullsToDelete[bul] = true     
            end
        end
    end

    for bul, _ in pairs(bullsToDelete) do
        tableOfBullets[bul] = nil
    end
    for ali, _ in pairs(aliensToDelete) do
        tableOfAliens[ali] = nil
    end
end

function checkForShotBoss (tableOfBullets)
    local toBeDeleted = {}
    for bul, _ in pairs(tableOfBullets) do
        if pointIsInRectangle(bul.xPos, bul.yPos, unpack(Boss:getRectangle())) then
            Boss:getHit()
            toBeDeleted[bul] = true
        end
    end

    for bul, _ in pairs(toBeDeleted) do
        tableOfBullets[bul] = nil
    end
end

function checkForShotPlayer (tableOfBullets)
    local playerRectangle = Player:getRectangle()

    for bul, _ in pairs(tableOfBullets) do
        if bul ~= nil then --for some reason is still entered the for even when there were no elements
                            --unexplicable but i had no time
            if rectanglesOverlap(Player.xPos, Player.yPos, Player.image:getWidth(), Player.image:getHeight(), bul.xPos, bul.yPos, bul.image:getWidth(), bul.image:getHeight()) then
                gameOver()
            end
        end
    end
end

function updatePointsOnAlienKill()
    Player:changeScore(100)
    Player.scoreSinceLastBoss = Player.scoreSinceLastBoss + 100
    if Player.scoreSinceLastBoss >= 1200 then
        Boss:spawn()
        bossIsOn = true
    end
end

function bossIsDead()
    Player:changeScore(1000 * currentDifficulty)
    bossIsOn = false
    Player.scoreSinceLastBoss = 0
    --Player.speed = 100 + currentDifficulty*10
    currentDifficulty = currentDifficulty + 1
end

--returns true is the first a point with the coordinates of the first two arguments
--is in the rectangle constructed by the origin of the rectangle and its width and height  
function pointIsInRectangle(pointX, pointY, rectX, rectY, width, height)
    if rectX < rectX + width then
        leftSide = rectX
        rightSide = rectX + width
    else
        rigthSide = rectX
        leftSide = rectX + width
    end
    
    if rectY < rectY + height then
        topSide = rectY
        bottomSide = rectY + height
    else
        bottomSide = rectY
        topSide = rectY + height
    end

    return (pointX >= leftSide) and (pointX <= rightSide) and (pointY >= topSide) and (pointY <= bottomSide)
end

--receives two rectangles as arguments; the starting points of the rectangles (x,y)
--returns true only if a point from one is INSIDE the other; i.e. return false
--if they have a common edge; return false if they are separate as well
function rectanglesOverlap(rect1X, rect1Y, rect1Width, rect1Height, rect2X, rect2Y, rect2Width, rect2Height)
    --just checking if each of the edges of one of the rects is inside the other
    --with the pointIsInRectangle function

    local topEdge1X, topEdge1Y = rect1X, rect1Y
    local topEdge2X, topEdge2Y = rect1X + rect1Width, rect1Y
    local bottomEdge1X, bottomEdge1Y = rect1X, rect1Y + rect1Height
    local bottomEdge2X, bottomEdge2Y = rect1X + rect1Width, rect1Y + rect1Height

    local point1Inside = pointIsInRectangle(topEdge1X, topEdge1Y, rect2X, rect2Y, rect2Width, rect2Height)
    local point2Inside = pointIsInRectangle(topEdge2X, topEdge2Y, rect2X, rect2Y, rect2Width, rect2Height)
    local point3Inside = pointIsInRectangle(bottomEdge1X, bottomEdge1Y, rect2X, rect2Y, rect2Width, rect2Height)
    local point4Inside = pointIsInRectangle(bottomEdge2X, bottomEdge2Y, rect2X, rect2Y, rect2Width, rect2Height)

    return point1Inside or point2Inside or point3Inside or point4Inside
end

function gameOver ()
    gamestate = 'Game Over'
    gameover_load()
end

function resetGame()
    Player.score = 0
    Player.scoreSinceLastBoss = 0
    Player.bullets = {}
    Player.timeSinceLastBullet = 0
    Player.xPos = love.graphics.getWidth() / 10
    Player.yPos = love.graphics.getHeight() / 2
    aliens = {}
    timeSinceLastAlien = 0
    bossIsOn = false
    currentDifficulty = 1
end
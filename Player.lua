require 'Bullet'

Player = {}
Player.yPos = 0 --some default values - not to be used
Player.xPos = 100 --some default values - not to be used
Player.bullets = {} --to be filled later
Player.speed = 100
Player.timeSinceLastBullet = 0
Player.bulletsPerSecond = 1.3
Player.moveStep = love.graphics.getHeight() / 2 --the step to move on a single key press
Player.height = 20
Player.width = 100
Player.imagePath = 'spaceship.png'
Player.image = nil
Player.score = 0
Player.scoreSinceLastBoss = 0

function Player:new(object, xPos, yPos)
    local xPos = xPos or 0
    local yPos = yPos or 0
    local object = object or {}
    setmetatable(object, self)
    object.__index = self
    Player.setXPos(object, xPos)
    Player.setYPos(object, yPos)
    return object
end

function Player:moveDown(dt)
    if self.yPos + self.height + self.moveStep*dt <= love.graphics.getHeight() then 
        Player:moveYPos(self.moveStep*dt)
    end
end

function Player:moveUp(dt)
    if self.yPos - self.moveStep*dt > 0 then 
        Player:moveYPos(-self.moveStep*dt)
    end
end

function Player:moveXPos(moveBy)
    self.xPos = self.xPos + moveBy
end

function Player:moveYPos(moveBy)
    self.yPos = self.yPos + moveBy
end

function Player:setXPos(xPos)
    self.xPos = xPos
end

function Player:setYPos(yPos)
    self.yPos = yPos
end

function Player:getXPos()
    return self.xPos
end

function Player:getYPos()
    return self.yPos
end

function Player:fire()
    love.audio.play(shootingSound)
    if self.timeSinceLastBullet < 1 / self.bulletsPerSecond then
        return
    end

    local bulletX = self.xPos + self.width
    local bulletY = self.yPos + self.height / 2

    local bullet = Bullet.new(bulletX, bulletY, 1, 400)
    self.bullets[bullet]=true
    self.timeSinceLastBullet = 0
end

function Player:getRectangle ()
    return {self.xPos, self.yPos, self.width, self.height}
end

function Player:changeScore (delta)
    if self.score + delta <= 0 then
        gameOver()
    else
        self.score = self.score + delta
    end
end
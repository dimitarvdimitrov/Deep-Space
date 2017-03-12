Bullet = {}
--the direction is -1 when the direction is from right to left
--it is 1 when it is from left to right
Bullet.direction = 1
Bullet.xPos = 0
Bullet.yPos = 0
Bullet.imagePath = 'bullet.png' --the image to be used when drawing the bullets
Bullet.speed = 1

function Bullet.new(x, y, direction, speed, image)
    local object = {}
    setmetatable(object, Bullet)
    object.direction = direction or Bullet.direction
    object.speed = speed or Bullet.speed
    object.xPos = x or Bullet.xPos
    object.yPos = y or Bullet.yPos
    object.image = image or Bullet.image
    return object
end

function Bullet:move(dt, XmoveBy, YmoveBy)
    self.xPos = self.xPos + self.speed * (XmoveBy or 0) * self.direction * dt
    self.yPos = self.yPos + self.speed * (YmoveBy or 0) * self.direction * dt
end

function Bullet:specialMove(dt, XmoveBy, YmoveBy)
    self.xPos = self.xPos + self.speed * (XmoveBy or 0) * self.direction * dt
    --self.yPos = self.yPos + self.speed * (YmoveBy or 0) * self.direction * dt

    self.yPos = self.yPos + math.sin(self.xPos / 60) * self.direction * dt * self.speed
end

function Bullet:draw()
    --love.graphics.circle('fill', self.xPos, self.yPos, 5)
    love.graphics.draw(Bullet.image, self.xPos, self.yPos, 0, 2, 2)
end

function Bullet:getRectangle()
    return {self.xPos, self.yPos, self.image:getWidth()*2, self.image:getHeight()*2}
end

--function Bullet:updateSpeed()

Alien={}
Alien.xpose=700
Alien.ypose=100
Alien.speed=100
Alien.imagePath = 'alien.png'
Alien.image= nil
Alien.width = 20
Alien.height = 20
Alien.__index = function (table, key)
        return Alien.key 
    end

function Alien:move(dt)
	self.xpose=self.xpose-0.1*self.speed*dt
end

function Alien.new(speed)
    local object = object or {}
    object.xpose = 10 * love.graphics.getWidth() / 11
    object.ypose = (love.graphics.getHeight() - 300) * math.random() + 150
    object.speed = speed or Alien.speed
    object.width = Alien.width
    object.height = Alien.height
    setmetatable(object, Alien)

    return object
end

function Alien:getRectangle()
    return {self.xpose, self.ypose, self.width, self.height};
end
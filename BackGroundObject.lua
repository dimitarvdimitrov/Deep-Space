BackGroundObject = {}
BackGroundObject.image = nil

BackGroundObject.posX  = love.graphics.getWidth() + 200
BackGroundObject.posY  = love.math.random( 0, love.graphics.getHeight() )
BackGroundObject.speed  = love.math.random( 50, love.graphics.getHeight()/10 )
BackGroundObject.rot  = love.math.random( 0, 360 )

BackGroundObject.radius  = love.math.random( 0.2, 0.5 )
BackGroundObject.dRot 	 = love.math.random( 0, 4 )

function BackGroundObject.new(image)
    local object = {}
    setmetatable(object, BackGroundObject)
	object.image = image

	object.posX  = love.graphics.getWidth() + 200

	object.color  = {red=love.math.random( 0, 255 ),green=love.math.random( 0, 255 ),blue=love.math.random( 0, 255 )}

	object.posY  = love.math.random( 0, love.graphics.getHeight() )
	object.rot  = 0

	object.speed = love.math.random( 50, 400 )

	object.radius  = love.math.random( 1, 100 )/200.0

	object.dRot  = love.math.random( 1, 100 )/50.0

    return object
end

function BackGroundObject:update(dt)
	self.posX = self.posX - self.speed*dt
	self.rot = self.rot - self.dRot*dt
	if  self.posX < 0 then 
		self.posX = love.graphics.getWidth() + 200
		self.posY  = love.math.random( 0, love.graphics.getHeight() )
	end

end

function BackGroundObject:draw()
	--love.graphics.circle("fill", self.posX, self.posY, self.radius, 40)

	--love.graphics.draw(self.image, self.posX, self.posY, self.rot, 1, 1, (self.image:getWidth()/2)*self.radius, (self.image:getHeight()/2)*self.radius)
	love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
	love.graphics.draw(self.image, self.posX, self.posY, self.rot, self.radius, self.radius, (self.image:getWidth()/2), (self.image:getHeight()/2))

end


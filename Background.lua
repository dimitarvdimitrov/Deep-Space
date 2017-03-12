Background = {}
Background.imagePath = 'background.bmp'
Background.images = {}
Background.objects = {}
Background.speed = Player.speed * 10 / 3
Background.xPos = 0
Background.yPos = 0
Background.imageWidth = 0
Background.xPos2 = 0
Background.img2xPos = 0
Background.img2xPos2 = 0

Background.image2Path = 'background texture.png'
Background.image2 = nil

function Background:initialize()
    Background.imageWidth = Background.image:getWidth()
    Background.image2Width = Background.image2:getWidth()
    Background.xPos2 = Background.imageWidth
    Background.img2xPos2 = Background.image2Width - 50
    Background.images[#Background.images + 1] = love.graphics.newImage("venus.png")
    Background.images[#Background.images + 1] = love.graphics.newImage("mercury.png") 
end

function Background:newBackgroundObject()
    if #Background.images > 0 then
        Background.objects[#Background.objects + 1] = BackGroundObject.new(Background.images[math.floor(love.math.random( 1, #Background.images))])
    else
        print("No background images loaded!")
    end
end

function Background:move(dt)
    if self.xPos + self.imageWidth <= 0 then
        self.xPos2 = Background.imageWidth
        self.xPos = 0
    else
        self.xPos = self.xPos - self.speed * dt
        self.xPos2 = self.xPos2 - self.speed * dt
    end

    if self.img2xPos + self.image2Width <= 50 then
        self.img2xPos2 = Background.image2Width - 50
        self.img2xPos = 0
    else
        self.img2xPos = self.img2xPos - self.speed * dt * 1.0011 --slight adjustment to the speed
        self.img2xPos2 = self.img2xPos2 - self.speed * dt * 1.0011 --slight adjustment to the speed
    end

    for k,v in pairs( Background.objects ) do
        BackGroundObject.update(v,dt)
    end
end 
function Background:draw()
    for k,v in pairs( Background.objects ) do
        BackGroundObject.draw(v)
    end
end
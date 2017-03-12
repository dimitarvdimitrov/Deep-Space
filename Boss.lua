Boss={}
Boss.xpose=700
Boss.ypose=250
Boss.xScale = 1
Boss.yScale = 1
Boss.width=0
Boss.height=0
Boss.speed=5
Boss.health=0
Boss.maxHealth = 100
Boss.imagePath = 'boss.png'

Boss.const1=0
Boss.const2=0

Boss.shootCooldown=2

Boss.bullets={}

function Boss:spawn()
    self.shootCooldown=0
    self.const1=0
    self.const2=0
    self.maxHealth = 100 * currentDifficulty
    self.health = self.maxHealth
    self.xpose=700
    self.ypose=250
    self.xScale = 1
    self.yScale = 1
    self.width=self.image:getWidth()
    self.height=self.image:getHeight()
end

function Boss:fire ()
    if self.health <= 0 then
        return
    end



	if Boss.shootCooldown > (2 - currentDifficulty*0.1) then
		Boss.shootCooldown = 0
		local b=Bullet.new(self.xpose + 20, self.ypose + self.height/2, -1, 690 + 10*currentDifficulty, love.graphics.newImage('special bullet.png'))
		self.bullets[b] = true
	end
end

function Boss:move()
	if self.xpose>500 then
		self.xpose=self.xpose-0.1*self.speed
		return
	end
	self.ypose = 250 + math.sin(self.const1/10)*100
	if self.const2<0.03 then
		self.const2=self.const2+0.0002
	end
	self.const1=self.const1+self.const2
end

function Boss:draw()
    if self.health <= 0 then
        self:die()
    end
    if self.image ~= nil then
	    love.graphics.draw(self.image, self.xpose, self.ypose, 0, self.xScale, self.yScale)
    else
        love.graphics.rectangle("fill",Boss.xpose,Boss.ypose,100,100)
    end
end

function Boss:getRectangle()
    return {self.xpose, self.ypose, self.width, self.height}
end

function Boss:getHit()
    self.health = self.health - 50

    if self.health <= 0 then
        self:die()
    end
end

function Boss:die()
    if self.xScale > 0 then
        self.xScale = self.xScale - 0.01
    end

    if self.yScale > 0 then
        self.yScale = self.yScale - 0.01
    end

    if self.xScale <= 0 or self.yScale <= 0 then
        bossIsDead()
    end
end

function Boss:drawBullets ()
    for bullet, _ in pairs(self.bullets) do
        love.graphics.draw(bullet.image, bullet.xPos, bullet.yPos, math.pi, 2, 2)
    end
end
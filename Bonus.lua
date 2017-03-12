local  Bonus={}
Bonus.xpose=600
Bonus.ypose=100
Bonus.speed=20

function Bonus:move()
	self.xpose=self.xpose-1
	self.ypose=100+math.sin(self.xpose/20)*30
end

function love.update(dt)
	Bonus:move()
end
function love.draw()
	love.graphics.setColor(0,0,255)
	love.graphics.rectangle("fill",Bonus.xpose,Bonus.ypose,100,100)
end
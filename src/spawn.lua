local spawn = {}
spawn.wasDown = 0










function spawn:update(dt)
	if love.mouse.isDown(1) then
		if self.wasDown == 0 then
			self.startPos = {cam:getMouseWorldPos()}
			self.wasDown = 1
		end
		
		if self.wasDown == 2 then
			local x,y = cam:getMouseWorldPos()
			local xDis = math.abs(self.endPos[1]-self.startPos[1])
			local yDis = math.abs(self.endPos[2]-self.startPos[2])
			local radius = math.sqrt(xDis^2 + yDis^2)
			xDis = x-self.startPos[1]
			yDis = y-self.startPos[2]
			
			local p = planet:spawn{radius = radius, x = self.startPos[1], y = self.startPos[2], xvel = xDis, yvel = yDis, color = {math.random(0,255), math.random(0,255), math.random(0,255)}}
			gravity:add(p)
			self.wasDown = 3
		end
	else
		if self.wasDown == 1 then
			self.endPos = {cam:getMouseWorldPos()}
			self.wasDown = 2
		end
		
		if self.wasDown == 3 then
			self.wasDown = 0
		end
	end
	
	if self.wasDown == 2 then
		if love.mouse.isDown(2) then
			local x,y = cam:getMouseWorldPos()
			local xDis = math.abs(self.endPos[1]-self.startPos[1])
			local yDis = math.abs(self.endPos[2]-self.startPos[2])
			local radius = math.sqrt(xDis^2 + yDis^2)
				
			local p = planet:spawn{radius = radius, x = self.startPos[1], y = self.startPos[2], xvel = 0, yvel = 0, color = {math.random(0,255), math.random(0,255), math.random(0,255)}}
			gravity:add(p)
			self.wasDown = 0
		elseif love.keyboard.isDown('escape') then
			self.wasDown = 0
		end
	end
end


function spawn:draw()
	love.graphics.setColor(255,255,255)
	if self.wasDown ~= 0 and self.wasDown ~= 3 then
		local x,y = cam:getMouseWorldPos()
		if self.wasDown == 2 then
			x = self.endPos[1]
			y = self.endPos[2]
		end
		
		local radius = math.sqrt(math.abs(x-self.startPos[1])^2 + math.abs(y-self.startPos[2])^2)
		love.graphics.circle('line', self.startPos[1], self.startPos[2], radius)
		
		if self.wasDown == 2 then
			local x2, y2 = cam:getMouseWorldPos()
			love.graphics.line(self.startPos[1], self.startPos[2], x2, y2)
		end
	end
end





return spawn
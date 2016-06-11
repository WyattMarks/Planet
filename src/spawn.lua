local spawn = {}
spawn.wasDown = 0






function spawn:spawnPlanet(move, fixed)
	local x,y = cam:getMouseWorldPos()
	local radius, xDis, yDis = util:getDistance(self.endPos[1], self.endPos[2], self.startPos[1], self.startPos[2])
	local color = {math.random(0,255), math.random(0,255), math.random(0,255)}

	while (color[1] + color[2] + color[3]) / 3 < 100 do
		color = {math.random(0,255), math.random(0,255), math.random(0,255)}
	end

	xDis = x-self.startPos[1]
	yDis = y-self.startPos[2]

	if not move then
		xDis = 0
		yDis = 0
	end
			
	local p = planet:spawn{radius = radius, x = self.startPos[1], y = self.startPos[2], xvel = xDis, yvel = yDis, color = color, fixed = fixed}
	gravity:add(p)
end


function spawn:update(dt)
	if love.mouse.isDown(1) then
		if self.wasDown == 0 then
			self.startPos = {cam:getMouseWorldPos()}
			self.wasDown = 1
		end
		
		if self.wasDown == 2 then
			self:spawnPlanet(true, false)
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
			self:spawnPlanet(false, false)
			self.wasDown = 0
		elseif love.mouse.isDown(3) then 
			self:spawnPlanet(false, true)
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
		
		local radius = util:getDistance(x,y,self.startPos[1],self.startPos[2])
		love.graphics.circle('line', self.startPos[1], self.startPos[2], radius)
		
		if self.wasDown == 2 then
			local x2, y2 = cam:getMouseWorldPos()
			love.graphics.line(self.startPos[1], self.startPos[2], x2, y2)
		end
	end
end

function spawn:keypressed(key)
	if key == "delete" then
		for i=1, #gravity.planets do
			local x,y = cam:getMouseWorldPos()
			if util:getDistance(x,y, gravity.planets[i].x, gravity.planets[i].y) < gravity.planets[i].radius then
				if cam.following == gravity.planets[i].id then
					cam:unfollow()
				end

				table.remove( gravity.planets, i )
				break
			end 
		end
	end
end





return spawn
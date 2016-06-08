local cam = {}
cam.scale = 1
cam.xOffset = 0
cam.yOffset = 0

function cam:getMouseWorldPos()
	return self:screenToWorld(love.mouse.getPosition())
end

function cam:screenToWorld(x,y)
	return x / self.scale - self.xOffset, y / self.scale - self.yOffset
end

function cam:worldToScreen(x,y)
	return x * self.scale + self.xOffset, y * self.scale + self.yOffset
end

function cam:wheelmoved(dx,dy)
	local x,y = self:getMouseWorldPos()

	if dy>0 then
		self.scale = self.scale + self.scale/5
	elseif dy<0 then
		self.scale = self.scale - self.scale/5
	end
	
	local x2, y2 = self:getMouseWorldPos()
	
	
	if not self.following then
		self.xOffset = self.xOffset - (x - x2)
		self.yOffset = self.yOffset - (y - y2)
	end
end

function cam:set()
	love.graphics.scale(self.scale, self.scale)
	love.graphics.translate(self.xOffset, self.yOffset)
end

function cam:unset()
	love.graphics.origin()
end

function cam:follow(target)
	self.following = target.id
end

function cam:unfollow()
	self.following = false
end

function cam:update(dt)
	if spawn.wasDown == 0 and love.mouse.isDown(2) then
		for k,planet in pairs(gravity.planets) do
			local x,y = self:getMouseWorldPos()
			local xDistance = planet.x-x
			local yDistance = planet.y-y
			local distance = math.sqrt(xDistance^2 + yDistance^2)
			
			if distance < planet.radius then
				self:follow(planet)
				break
			end
		end
	end
	
	if self.following then
		local planet = gravity:getByID(self.following)
		
		self.xOffset = (-planet.x + screenWidth / 2 / self.scale)
		self.yOffset = (-planet.y + screenHeight / 2 / self.scale)
	end
end

function cam:mousemoved(x,y,dx,dy)
	if love.mouse.isDown(3) then
		self.xOffset = self.xOffset + dx / self.scale
		self.yOffset = self.yOffset + dy / self.scale
		self:unfollow()
	end
end

return cam
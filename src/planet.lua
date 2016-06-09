local planet = {}
planet.radius = 10
planet.x = 100
planet.y = 100
planet.xvel = 0
planet.yvel = 0
planet.color = {150,150,150}
planet.life = 0
planet.trail = {}

function planet:spawn(args)
	local new = table.copy(self)
	for k,v in pairs(args) do
		new[k] = v
	end
	
	return new
end

function planet:update(dt)
	self.life = self.life + dt
	self.x = self.x + self.xvel * dt
	self.y = self.y + self.yvel * dt
	
	if self.life > .05 then
		self.life = self.life - .05
		table.insert(self.trail, 1, self.y)
		table.insert(self.trail, 1, self.x)
		if #self.trail > 80 and debug.settings.traillimit then
			for i=81, #self.trail do
				self.trail[i] = nil
			end
		end
	end
end

function planet:draw()
	love.graphics.setColor(math.max(0, self.color[1] - 20), math.max(0, self.color[2] - 20), math.max(0, self.color[3] - 20))
	if debug.settings.trail and #self.trail > 2 then love.graphics.line(self.trail) end
	love.graphics.setColor(0,255,0)
	if debug.settings.velocity then love.graphics.line(self.x, self.y, self.x + self.xvel, self.y + self.yvel) end
	love.graphics.setColor(self.color)
	love.graphics.circle('fill', self.x, self.y, self.radius, self.radius * 4)
end

return planet
local planet = {}
planet.radius = 10
planet.x = 100
planet.y = 100
planet.xvel = 0
planet.yvel = 0
planet.color = {150,150,150}
planet.lastTrail = 0
planet.trail = {} --the trail points
planet.fixed = false

function planet:spawn(args)
	local new = table.copy(self)
	for k,v in pairs(args) do
		new[k] = v
	end
	
	return new
end

function planet:checkTrail()
	for i=1, #self.trail do 
		if i % 2 == 0 then
			if ((self.trail[i] - self.y)^2 + (self.trail[i-1] - self.x)^2) <= 36 then --If the point is 6 pixels close then return false (36 == 6^2, save a math.sqrt call)
				return false
			end
		end
	end

	return true
end

function planet:update(dt)
	self.lastTrail = self.lastTrail + dt
	if not self.fixed then
		self.x = self.x + self.xvel * dt
		self.y = self.y + self.yvel * dt
	end
	
	if self.lastTrail > .05 and self:checkTrail() then --Haven't spawned any points or distance to last point > 6
		self.lastTrail = self.lastTrail - .05
		table.insert(self.trail, 1, self.y)
		table.insert(self.trail, 1, self.x)
		local limit = 80
		if not debug.settings.trail then 
			limit = 0
		end
		if #self.trail > limit and (debug.settings.traillimit or not debug.settings.trail) then  --Only truncate the trail length if we have it set to limit their length, 80 is arbitrary
			for i=limit+1, #self.trail do
				self.trail[i] = nil
			end
		end
	end
end

function planet:drawPlanet()
	love.graphics.setColor(self.color)
	love.graphics.circle('fill', self.x, self.y, self.radius, self.radius * 4)

end

function planet:drawTrail()
	love.graphics.setColor(math.max(0, self.color[1] - 20), math.max(0, self.color[2] - 20), math.max(0, self.color[3] - 20))
	if  #self.trail > 4 then love.graphics.line(util:tessellate(self.trail)) end
	love.graphics.setColor(0,255,0)
	if debug.settings.velocity then love.graphics.line(self.x, self.y, self.x + self.xvel, self.y + self.yvel) end
end

return planet
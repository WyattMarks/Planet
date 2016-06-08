local gravity = {}
gravity.planets = {}

function gravity:add(planet)
	planet.index = #self.planets + 1
	planet.id = (planet.color[1] + planet.color[2] + planet.color[3]) / 3
	self.planets[planet.index] = planet
end

function gravity:getByID(id)
	for k,v in pairs(self.planets) do
		if v.id == id then
			return v
		end
	end
end

function gravity:update(dt)
	dt = dt * debug.settings.timescale
	for k,planet in pairs(self.planets) do
		for j, other in pairs(self.planets) do
			if other ~= planet then
				local xDistance = planet.x-other.x
				local yDistance = planet.y-other.y
				
				
				planet.xvel = planet.xvel - xDistance/(math.sqrt(xDistance^2+yDistance^2)+1) * dt * other.radius --/ 2
				planet.yvel = planet.yvel - yDistance/(math.sqrt(xDistance^2+yDistance^2)+1) * dt * other.radius --/ 2
			end
		end
	end
	
	for k,v in pairs(self.planets) do
		v:update(dt)
	end
end

function gravity:draw()
	for k,v in pairs(self.planets) do
		v:draw()
	end
end

return gravity
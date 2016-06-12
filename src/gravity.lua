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
	if debug.settings.pause then return end
	dt = dt * debug.settings.timescale
	for k,planet in pairs(self.planets) do
		for j, other in pairs(self.planets) do
			if other ~= planet then
				local xDistance = planet.x-other.x
				local yDistance = planet.y-other.y
				
				
				planet.xvel = planet.xvel - xDistance/(math.sqrt(xDistance^2+yDistance^2)+1) * dt * other.radius
				planet.yvel = planet.yvel - yDistance/(math.sqrt(xDistance^2+yDistance^2)+1) * dt * other.radius
			end
		end
	end
	
	for k,v in pairs(self.planets) do
		v:update(dt)
	end
end

function gravity:draw()
	local sort =  function(a,b) return a.radius > b.radius end
	local ordered = {}
	for k,v in pairs(self.planets) do table.insert(ordered, v) end
	table.sort(ordered, sort)

	for k,v in pairs(ordered) do
		v:drawTrail()
	end

	for k,v in pairs(ordered) do
		v:drawPlanet()
	end
end

return gravity
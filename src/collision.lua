local collision = {}




function collision:update(dt)
	if not debug.settings.collision then return end
	for k,planet in pairs(gravity.planets) do
		for j, other in pairs(gravity.planets) do
			if other ~= planet then
				local xDistance = planet.x-other.x
				local yDistance = planet.y-other.y
				local distance = math.sqrt(xDistance^2 + yDistance^2)
				
				if distance < other.radius + planet.radius then
					local big = planet.radius > other.radius and planet or other
					local small = planet.radius > other.radius and other or planet
					local newArea = big.radius^2 + small.radius^2
					local amountBig = big.radius^2 / newArea
					local amountSmall = small.radius^2 / newArea
					
					big.radius = math.sqrt(newArea)
					big.xvel = big.xvel * amountBig + small.xvel * amountSmall
					big.yvel = big.yvel * amountBig + small.yvel * amountSmall
					big.color[1] = big.color[1] * amountBig + small.color[1] * amountSmall
					big.color[2] = big.color[2] * amountBig + small.color[2] * amountSmall
					big.color[3] = big.color[3] * amountBig + small.color[3] * amountSmall
					
					if cam.following == small.id then
						big.id = small.id 
					end
					
					table.remove(gravity.planets, small.index)
					for i=1, #gravity.planets do
						gravity.planets[i].index = i
					end
				end
			end
		end
	end
	
end

















return collision
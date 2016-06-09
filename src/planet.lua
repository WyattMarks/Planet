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
		if #self.trail < 1 or math.sqrt((self.trail[2] - self.y)^2 + (self.trail[1] - self.x)^2) > 6 then
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
end

local function function tessellate(vertices)
   MIX_FACTOR = .5
   local new_vertices = {}
   new_vertices[#vertices*2] = 0
   for i=1,#vertices,2 do
      local newindex = 2*i
      -- indexing brackets:
      -- [1, *2*, 3, 4], [5, *6*, 7, 8]
      -- bracket center: 2*i
      -- bracket start: 2*1 - 1
      new_vertices[newindex - 1] = vertices[i];
      new_vertices[newindex] = vertices[i+1]
      if not (i+1 == #vertices) then
	 -- x coordinate
	 new_vertices[newindex + 1] = (vertices[i] + vertices[i+2])/2
	 -- y coordinate
	 new_vertices[newindex + 2] = (vertices[i+1] + vertices[i+3])/2
      else
	 -- x coordinate
	 new_vertices[newindex + 1] = (vertices[i] + vertices[1])/2
	 -- y coordinate
	 new_vertices[newindex + 2] = (vertices[i+1] + vertices[2])/2
      end
   end

   for i = 1,#new_vertices,4 do
      if i == 1 then
   	 -- x coordinate
   	 new_vertices[1] = MIX_FACTOR*(new_vertices[#new_vertices - 1] + new_vertices[3])/2 + (1 - MIX_FACTOR)*new_vertices[1]
   	 -- y coordinate
   	 new_vertices[2] = MIX_FACTOR*(new_vertices[#new_vertices - 0] + new_vertices[4])/2 + (1 - MIX_FACTOR)*new_vertices[2]
      else
   	 -- x coordinate
   	 new_vertices[i] = MIX_FACTOR*(new_vertices[i - 2] + new_vertices[i + 2])/2 + (1 - MIX_FACTOR)*new_vertices[i]
   	 -- y coordinate
   	 new_vertices[i + 1] = MIX_FACTOR*(new_vertices[i - 1] + new_vertices[i + 3])/2 + (1 - MIX_FACTOR)*new_vertices[i + 1]
      end
   end

   table.remove(new_vertices, 1)
   table.remove(new_vertices, 1)
   new_vertices[#new_vertices] = nil
   new_vertices[#new_vertices] = nil
   new_vertices[#new_vertices] = nil
   new_vertices[#new_vertices] = nil


   return new_vertices
end

function planet:draw()
	love.graphics.setColor(math.max(0, self.color[1] - 20), math.max(0, self.color[2] - 20), math.max(0, self.color[3] - 20))
	if debug.settings.trail and #self.trail > 4 then love.graphics.line(tessellate(self.trail)) end
	love.graphics.setColor(0,255,0)
	if debug.settings.velocity then love.graphics.line(self.x, self.y, self.x + self.xvel, self.y + self.yvel) end
	love.graphics.setColor(self.color)
	love.graphics.circle('fill', self.x, self.y, self.radius, self.radius * 4)
end

return planet
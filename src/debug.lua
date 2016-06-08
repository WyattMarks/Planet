local debug = {}
debug.variables = {}
debug.binds = {}
debug.offset = 10
debug.settings = {}

function debug:get(key)
	for k,v in pairs(self.variables) do
		if v[1] == key then
			return v[2]
		end
	end
end

function debug:add(key, value, toggle)
	local added = false
	for k,v in pairs(self.variables) do
		if v[1] == key then
			self.variables[k] = {key, value}
			added = true
			break
		end
	end
	
	if not added then self.variables[#self.variables + 1] = {key, value} end
	
	if toggle then
		self.binds[toggle] = key
		local c = string.find(key, ")")
		key = key:sub(c+2):lower()
		self.settings[key] = value
	end
end

function debug:load()
	self:add('(F1) Velocity', false, 'f1')
	self:add('(F2) Trail', true, 'f2')
	self:add('(F3) Collision', true, 'f3')
	self.font = love.graphics.newFont(20)
end

function debug:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(self.font)
	local y = 10
	for i=1, #self.variables do
		
		local str = tostring(self.variables[i][1])
		if self.variables[i][2] ~= '' then
			str = str .. ":"
		end
		
		local val = tostring(self.variables[i][2])
		
		love.graphics.print(val, screenWidth - self.offset - self.font:getWidth(val), y)
		love.graphics.print(str, screenWidth - self.offset * 2 - self.font:getWidth(val) - self.font:getWidth(str), y)
		
		y = y + self.font:getHeight() + 2
	end
end

function debug:keypressed(key)
	if self.binds[key] then
		self:add(self.binds[key], not self:get(self.binds[key]), key)
	end
end




return debug
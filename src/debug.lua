local debug = {}
debug.variables = {}
debug.added = {}
debug.binds = {}
debug.offset = 10
debug.settings = {}

--self.variables["(F1) Velocity] = true
--self.binds["f1"] = {"(F1) Velocity", "toggle"}
--self.binds["up"] = {"(^/v) Timescale", "incremental", 1, {'up', 'down', .1}}
--self.binds["down"] = {"(^/v) Timescale", "incremental", 2, {'up', 'down', .1}}

function debug:add(key, value, changeable, v)
	self.variables[key] = value
	local added = false
	for k,v in pairs(self.added) do
		if v == key then added = true end
	end

	if not added then self.added[#self.added + 1] = key end
	
	if changeable == "toggle" then
		self.binds[v] = {key, changeable}
		local c = string.find(key, ")")
		key = key:sub(c+2):lower()
		key = key:gsub(' ', '')
		self.settings[key] = value
	elseif changeable == "incremental" then
		self.binds[v[1]] = {key, changeable, 1, v}
		self.binds[v[2]] = {key, changeable, 2, v}
		local c = string.find(key, ")")
		key = key:sub(c+2):lower()
		key = key:gsub(' ', '')
		self.settings[key] = value
	end
end

function debug:load()
	self:add('(P) Pause', false, "toggle", 'p')
	self:add('(F1) Velocity', false, "toggle", 'f1')
	self:add('(F2) Trail', true, 'toggle', 'f2')
	self:add('(F3) Trail Limit', true, 'toggle', 'f3')
	self:add('(F4) Collision', true, 'toggle', 'f4')
	self:add('(^/v) Timescale', 1, 'incremental', {'up', 'down', .1})
	self.font = love.graphics.newFont(20)
end

function debug:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(self.font)
	local y = 10
	for i=1, #self.added do
		local k = self.added[i]
		local v = self.variables[k]
		local str = tostring(k)
		if v ~= '' then
			str = str .. ":"
		end
		
		v = tostring(v)
		
		love.graphics.print(v, screenWidth - self.offset - self.font:getWidth(v), y)
		love.graphics.print(str, screenWidth - self.offset * 2 - self.font:getWidth(v) - self.font:getWidth(str), y)
		
		y = y + self.font:getHeight() + 2
	end
end

--self.binds["down"] = {"(^/v) Timescale", "incremental", 2, {'up', 'down', .1}}

function debug:keypressed(key)
	if self.binds[key] then
		local change = self.binds[key][2]
		local str = self.binds[key][1]
		if change == 'toggle' then
			self:add(str, not self.variables[str], change,  key)
		elseif change == 'incremental' then
			local increment = self.binds[key][4][3]
			local neg = self.binds[key][3] == 1 and 1 or -1
			self:add(str, self.variables[str] + increment * neg, change, self.binds[key][4] )
		end
	end
end




return debug
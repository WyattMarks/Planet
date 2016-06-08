io.stdout:setvbuf("no")
planet = require('src/planet')
gravity = require('src/gravity')
spawn = require('src/spawn')
cam = require('src/cam')
debug = require('src/debug')
collision = require('src/collision')

function table.copy(tbl)
	local new = {}
	for k,v in pairs(tbl) do
		if type(v) == "table" then
			new[k] = table.copy(v)
		else
			new[k] = v
		end
	end
	
	return new
end

function love.load()
	math.randomseed(os.time())
	debug:load()
	screenWidth, screenHeight = love.window.getMode()
end

function love.update(dt)
	spawn:update(dt)
	collision:update(dt)
	gravity:update(dt)
	cam:update(dt)
end

function love.draw()
	cam:set()
	spawn:draw()
	gravity:draw()
	cam:unset()
	
	debug:draw()
end

function love.wheelmoved(x,y) 
	cam:wheelmoved(x,y)
end

function love.mousemoved(x,y,dx,dy)
	cam:mousemoved(x,y,dx,dy)
end

function love.keypressed(key)
	debug:keypressed(key)
end
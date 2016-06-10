local input = {}
input.repeatDelay = .05
input.beginDelay = 1
input.keys = {}

function input:update(dt)
    for k,v in pairs(self.keys) do 
        self.keys[k][1] = v[1] + dt

        if self.keys[k][2] then
            if self.keys[k][1] > self.repeatDelay then
                self.keys[k][1] = self.keys[k][1] - self.repeatDelay
                self:callback(k, true)
            end
        else
            if self.keys[k][1] > self.beginDelay then
                self.keys[k][2] = true
                self.keys[k][1] = self.keys[k][1] - self.beginDelay
                self:callback(k, true)
            end
        end
    end
end

function input:keypressed(key)
    self.keys[key] = {0}
    self:callback(key)
end

function input:keyreleased(key)
    self.keys[key] = nil
end

function input:callback(key, isBeingHeld)

end


return input
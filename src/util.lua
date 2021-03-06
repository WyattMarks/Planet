local util = {}

function util:tessellate(vertices)
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

function util:getDistance(x,y,x2,y2) 
    local xDis = math.abs(x-x2)
    local yDis = math.abs(y-y2)

    return math.sqrt(xDis^2 + yDis^2), xDis, yDis
end

function util:copyTable(tbl)
	local new = {}
	for k,v in pairs(tbl) do
		if type(v) == "table" then
			new[k] = self:copyTable(v)
		else
			new[k] = v
		end
	end
	
	return new
end


return util
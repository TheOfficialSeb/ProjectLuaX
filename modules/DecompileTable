return setmetatable({},{
	__tablehasvalue = function(Table)
		for _,_ in next,Table do
			return true
		end
		return false
	end,
	__get = function(value,functions,self,looped)
		local typeofvalue = (typeof or type)(value)
		if typeofvalue == "string" then
			return "\""..value.."\""
		elseif typeofvalue == "number" or typeofvalue == "boolean" or typeofvalue == "EnumItem" then 
			return tostring(value)
		elseif typeofvalue == "function" then
			return "function(...)\n"..string.rep("   ",looped+1).."print(...)\n"..string.rep("   ",looped+1).."return ...\n"..string.rep("   ",looped).."end"
		elseif typeofvalue == "table" then 
			return functions.__call(self,value,looped+1,looped)
		elseif typeofvalue == "Instance" then
			if value:IsDescendantOf(game) and value.Parent:IsA("DataModel") then
				return string.format("game:GetService(\"%s\")",value.ClassName)
			elseif value:IsDescendantOf(game) then
				for _,Service in next,game:GetChildren() do
					if value:IsDescendantOf(Service) then 
						return string.format("game:GetService(\"%s\")",Service.ClassName)..value:GetFullName():sub(#Service.Name+1)
					end
				end
			elseif value:IsA("DataModel") then 
				return "game"
			else
				return string.format("Instance.new(\"%s\")",value.ClassName)
			end
		elseif typeofvalue == "Vector2" or typeofvalue == "Vector2int16" or typeofvalue == "Vector3" or typeofvalue == "Vector3int16" or typeofvalue == "CFrame" or typeofvalue == "UDim" or typeofvalue == "UDim2" or typeofvalue == "PhysicalProperties" then
			return string.format("%s.new(%s)",typeofvalue,tostring(value):gsub("[{}]",""))
		elseif typeofvalue == "Color3" then
			return string.format("Color3.fromRGB(%d, %d, %d)",value.r*255,value.g*255,value.b*255)
		elseif typeofvalue == "BrickColor" then
			return string.format("BrickColor.new(%s)",functions.__get(value.Name,functions,self,looped))
		elseif typeofvalue == "Ray" then
			return string.format("Ray.new(%s, %s)",functions.__get(value.Origin,functions,self,looped),functions.__get(value.Direction,functions,self,looped))
		elseif typeofvalue == "NumberSequence" or typeofvalue == "ColorSequence" then
			return string.format("%s.new(%s)",typeofvalue,functions.__get(value.Keypoints,functions,self,looped))
		elseif typeofvalue == "NumberSequenceKeypoint" or typeofvalue == "ColorSequenceKeypoint" then
			return string.format("%s.new(%d, %s)",typeofvalue,value.Time,functions.__get(value.Value,functions,self,looped))
		elseif typeofvalue == "Enums" then
			return "Enum"
		elseif typeofvalue == "Enum" then
			return string.format("Enum.%s",tostring(value))
		elseif typeofvalue == "Region3" then
			return string.format("NumberRange.new(%s, %s)",functions.__get(value.CFrame.Position-(value.Size/2),functions,self,looped),functions.__get(value.CFrame.Position+(value.Size/2),functions,self,looped))
		elseif typeofvalue == "PathWaypoint" then
			return string.format("PathWaypoint.new(%s, %s)",functions.__get(value.Position,functions,self,looped),functions.__get(value.Action,functions,self,looped))
		elseif typeofvalue == "NumberRange" then
			return string.format("NumberRange.new(%d, %d)",value.Min,value.Max)
		elseif typeofvalue == "TweenInfo" then
			return string.format("TweenInfo.new(%d, %s, %s, %d, %s, %d)",value.Time,functions.__get(value.EasingStyle,functions,self,looped),functions.__get(value.EasingDirection,functions,self,looped),value.RepeatCount,functions.__get(value.Reverses,functions,self,looped),value.DelayTime)
		else
			return typeofvalue
		end
	end,
	__format = function(index,value,looped)
		return string.rep("   ",looped)..string.format("[%s] = %s",tostring(index),tostring(value))
	end,
	__call = function(self,Table,...)
		local functions = getmetatable(self)
		if functions.__tablehasvalue(Table) then
			local decompiled_table = {}
			for index,value in next,Table do
				decompiled_table[#decompiled_table+1] = functions.__format(functions.__get(index,functions,self,(({...})[1] or 1)),functions.__get(value,functions,self,(({...})[1] or 1)),({...})[1] or 1)..","
			end
			decompiled_table[#decompiled_table] = decompiled_table[#decompiled_table]:sub(1,#decompiled_table[#decompiled_table]-1)
			return "{\n"..table.concat(decompiled_table,"\n").."\n"..string.rep("   ",({...})[2] or 0).."}"
		else
			return "{}"
		end
	end
})

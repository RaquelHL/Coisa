Component = {}
local meta = {}
meta.__index = meta

local function new(handle, data, super)
	local comp = {}
	data = data or {}
	setmetatable(comp, meta)

	comp.handle = handle

	if super then
		if super:type() == "componentConstructor" then
			super = super()
		end
		comp.super = super
	end

	comp.clone = function(self)
		return clone(self)
	end

	comp.newComp = function(self, newData)
		local c = clone(data)
		if super then
			for k,v in pairs(super) do
				if k ~= "handle" and not c[k] then
					c[k] = c[k] or v					
				end
			end
			c.super = super
		end
		if newData then
			for k,v in pairs(newData) do
				if c[k] ~= nil then
					c[k] = v
				else
					print("Warning: key '"..k.."' doesn't exist in component '"..self.handle.."'")
				end
			end
		end
		c.handle = handle

		c.type = function()
			return "component"
		end

		return c
	end

	comp.type = function()
		return "componentConstructor"
	end

	setmetatable(comp, {__call = function(_, ...) return comp:newComp(...) end})
	return comp
end

--Faz com que seja possível chamar a função new assim: Component(); Ao inves de assim: Component.new()
setmetatable(Component, {__call = function(_, ...) return new(...) end})
Component = {}
local meta = {}
meta.__index = meta

local function new(handle, data, cons)
	local comp = {}
	data = data or {}
	setmetatable(comp, meta)

	comp.handle = handle

	comp.clone = function(self)
		return clone(self)
	end

	comp.new = function(self, ...)
		local c = clone(data)
		local arg = {...}
		local newData
		if cons then
			newData = cons(...)
		else
			newData = arg[1]
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

	setmetatable(comp, {__call = function(_, ...) return comp:new(...) end})
	return comp
end

--Faz com que seja possível chamar a função new assim: Component(); Ao inves de assim: Component.new()
setmetatable(Component, {__call = function(_, ...) return new(...) end})
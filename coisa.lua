Coisa = {}
Coisa.__index = Coisa

local nextID = 1

local function new(name, components)
	components = components or {}
	local c = {}
	setmetatable(c, Coisa)

	c.name = name or "Coisa"
	c.id = nextID
	nextID = nextID + 1

	c.scripts = {}
	
	cCore.registerCoisa(c)

	for k,comp in pairs(components) do
		c:addComponent(comp)
	end

	if not c.pos then
		c:addComponent(Position) 
	end


	return c
end

function Coisa:addComponent(c)
	if c:type() == "componentConstructor" then 	--Assim dá pra chamar o componente com ou sem parenteses
		c = c()
	end
	self[c.handle] = c
	self.scene:updateCoisa(self)
end

function Coisa:removeComponent(c)
	local handle = c.handle or c
	self[handle] = nil
	self.scene:updateCoisa(self)
end

function Coisa:init()
	for k,c in pairs(self.components) do
		c:initComp()
	end
end

function Coisa:destroy()
	self.toDestroy = true
	self.scene:removeCoisa(self)
end

function Coisa:compare(filter)
	for i,h in ipairs(filter) do
		if not self[h] then
			--print("Coisa "..self.name.." doesn't have a "..h)
			return false
		end
	end
	return true
end

setmetatable(Coisa, {__call = function(_, ...) return new(...) end})
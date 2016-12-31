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
	

	for k,comp in pairs(components) do
		c:addComponent(comp, true)
	end

	if not c.pos then
		c:addComponent(Position, true) 
	end

	cCore.registerCoisa(c)

	--c.scene:updateCoisa(c)

	return c
end

function Coisa:addComponent(c, skipUpdate)
	if c:type() == "componentConstructor" then 	--Assim dá pra chamar o componente com ou sem parenteses
		c = c()
	end
	self[c.handle] = c
	if c.super then
		self[c.super.handle] = true
	end
	if not skipUpdate then
		for i,v in ipairs(self.scripts) do
			error("chegou aqui")
		end
	end
end

function Coisa:removeComponent(c, skipUpdate)
	local handle = c.handle or c
	self[handle] = nil
	if not skipUpdate then
		for i,v in ipairs(self.scripts) do
			error("chegou aqui")
		end
	end
end

function Coisa:init()
	for k,c in pairs(self.components) do
		c:initComp()
	end
end

function Coisa:destroy()
	self.toDestroy = true
	cCore:removeCoisa(self)
end

function Coisa:compare(filter)
	if  #filter == 0 then --Sem filtro: script não atua diretamente nas coisas
		return false
	end
	for i,h in ipairs(filter) do
		if not self[h] then
			--print("Coisa "..self.name.." doesn't have a "..h)
			return false
		end
	end
	return true
end

setmetatable(Coisa, {__call = function(_, ...) return new(...) end})
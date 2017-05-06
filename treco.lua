Treco = {}
Treco.__index = Treco

local nextID = 1

local function new(...)
	components = {...} or {}
	local c = {}
	setmetatable(c, Treco)

	c.id = nextID
	nextID = nextID + 1

	c.scripts = {}


	for k,comp in pairs(components) do
		c:addComponent(comp, true)
	end

	tCore.registerTreco(c)

	return c
end

function Treco:addComponent(c, skipUpdate)
	if c:type() == "componentConstructor" then 	--Assim dá pra chamar o componente com ou sem parenteses
		c = c()
	end
	self[c.handle] = c
	if c.super then
		self[c.super.handle] = c
	end
end

function Treco:removeComponent(c, skipUpdate)
	local handle = c.handle or c
	self[handle] = nil
end

function Treco:destroy()
	self.toDestroy = true
	tCore.removeTreco(self)
end

function Treco:compare(filter)
	if  #filter == 0 then --Sem filtro: script não atua diretamente nas trecos
		return false
	end
	for i,h in ipairs(filter) do
		if not self[h] then
			-- print("Treco "..self.name.." doesn't have a "..h)
			return false
		end
	end
	return true
end

setmetatable(Treco, {__call = function(_, ...) return new(...) end})

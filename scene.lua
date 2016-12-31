Scene = {}
Scene.__index = Scene

local function new(name)
	local s = {}
	setmetatable(s, Scene)

	s.coisas = {}	--Tabela de coisas na cena
	s.name = name
	s.isScene = true

	cCore.registerScene(s)
	return s
end

function Scene:addCoisa(coisa)
	--coisa.scene = self 	--Necessário?
	self.coisas[coisa.id] = coisa
end

function Scene:removeCoisa(coisa)
	self.coisas[coisa.id] = nil
end

function Scene:getCoisas(filter)
	if not filter then return self.coisas end
	local fCoisas = {}
	for i,c in ipairs(self.coisas) do
		if c:compare(filter) then
			fCoisas[#fCoisas+1] = c.id
		end
	end
	return fCoisas
end

function Scene:_enter()
	if not self.isInitialized and self.init then
		self:init()
	end
	self.isInitialized = true
	if self.enter then
		self:enter()
	end
end

function Scene:_exit()
	if self.exit then
		self:exit()
	end
end

function Scene:_update(dt)
	if self.update then
		self:update(dt)
	end
end

function Scene:_lateUpdate(dt)
	if self.lateUpdate then
		self:lateUpdate(dt)
	end
end

function Scene:_draw()
	if self.draw then
		self:draw()
	end
end

setmetatable(Scene, {__call = function(_, ...) return new(...) end})
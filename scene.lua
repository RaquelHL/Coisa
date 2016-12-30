Scene = {}
Scene.__index = Scene

local function new(name)
	local s = {}
	setmetatable(s, Scene)

	s.coisas = {}	--Tabela de coisas na cena
	s.scripts = {}	--Tabela de scripts atuando na cena

	s.name = name

	cCore.registerScene(s)

	return s
end

function Scene:addCoisa(coisa)
	coisa.scene = self
	self.coisas[coisa.id] = coisa
	for i,s in ipairs(self.scripts) do
		s:addCoisa(coisa)	--Script decide se quer ou não
	end
end

function Scene:updateCoisa(coisa)
	for i,s in ipairs(self.scripts) do
		s:updateCoisa(coisa)
	end
end

function Scene:removeCoisa(coisa)
	for i in ipairs(coisa.scripts) do
		self.scripts[i]:removeCoisa(coisa.id)
	end
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

function Scene:setScripts(scripts)
	if not scripts then return end
	self.scripts = scripts
	for i,s in ipairs(scripts) do
		s.scene = self
		s.cList = self:getCoisas(s.requirements)
	end
end

function Scene:_enter()
	if not self.isInitialized and self.init then
		self:init()
	end
	self.isInitialized = true
	for i,s in ipairs(self.scripts) do
		s:_enter(dt)
	end
	if self.enter then
		self:enter()
	end

end

function Scene:_update(dt)
	if self.update then
		self:update(dt)
	end
	for i,s in ipairs(self.scripts) do
		s:_update(dt)
	end
end

function Scene:_draw()
	if self.draw then
		self:draw()
	end
	for i,s in ipairs(self.scripts) do
		s:_draw()
	end	
end




setmetatable(Scene, {__call = function(_, ...) return new(...) end})
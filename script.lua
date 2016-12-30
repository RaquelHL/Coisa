Script = {}
Script.__index = Script

local nextID = 1

local function new(handle, c)
	local s = {}
	setmetatable(s, Script)

	s.handle = handle
	s.id = nextID
	nextID = nextID + 1

	s.requirements = {}

	if c then
		s:require(c)
	end

	s.cList = {}
	cCore.registerScript(s)

	return s
end

function Script:require(c)
	self.requirements = {}
	for k,v in pairs(c) do
		self.requirements[#self.requirements+1] = v.handle
	end
end

function Script:addCoisa(coisa)
	if coisa:compare(self.requirements) then
		self.cList[coisa.id] = true	
		coisa.scripts[self.id] = true
		if self.initEach then
			self:initEach(coisa)
		end
	end
end

function Script:updateCoisa(coisa)
	if coisa:compare(self.requirements) then
		if not self.cList[coisa.id] then
			self:addCoisa(coisa)
		end
	else
		if self.cList[coisa.id] then
			self:removeCoisa(coisa)
		end
	end
end

function Script:removeCoisa(coisa)
	if self.onRemoval then
		self:onRemoval(coisa)
	end
	self.cList[coisa.id] = nil
	coisa.scripts[self.id] = nil
end

function Script:_enter()
	if self.init then
		self:init()
	end
	if self.initEach then
		self:callEach("initEach")
	end
end

function Script:_update(dt)
	if self.update then
		self:update(dt)
	end
	if self.updateEach then
		self:callEach("updateEach", dt)
	end
end

function Script:_draw()
	if self.draw then
		self:draw()
	end
	if self.drawEach then
		self:callEach("drawEach")
	end
end

function Script:callEach(func, ...)
	for i in ipairs(self.cList) do
		self[func](self, self.scene.coisas[i], ...)
	end
end

setmetatable(Script, {__call = function(_, ...) return new(...) end})
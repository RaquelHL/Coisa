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

--[[function Script:_enter()
	if not self.isInitialized and self.init then
		self:init()
	end
	self.isInitialized = true
	if self.enter then
		self:enter()
	end
end]]

function Script:_update(dt)
	if self.update then
		self:update(dt)
	end
	if self.updateEach then
		for i in ipairs(self.cList) do
			self:updateEach(self.scene.coisas[i], dt)
		end
	end
end

function Script:_draw()
	if self.draw then
		self:draw()
	end
	if self.drawEach then
		for i in ipairs(self.cList) do
			self:drawEach(self.scene.coisas[i])
		end
	end
end

function Script:removeCoisa(coisa)
	self.coisas[coisa.id] = nil
end

setmetatable(Script, {__call = function(_, ...) return new(...) end})
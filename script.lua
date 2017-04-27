Script = {}
Script.__index = Script

local nextID = 1

Script.type = {	--A ordem aqui também é a ordem de chamada de callbacks
	game = 1,
	system = 2,
	editor = 3}

local function new(c, sType)
	local s = {}
	setmetatable(s, Script)

	s.id = nextID
	nextID = nextID + 1

	s.requirements = {}

	if c then
		s:require(c)
	end

	s.cList = {}

	s.sType = sType or Script.type.game

	cCore.registerScript(s)

	s.isInitialized = false

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
		if self.init then
			self:init(coisa)
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

function Script:reset()
	if self.onRemoval then
		self:callEach("onRemoval")
	end
	self.cList = {}
end

function Script:_init()
	if self.initOnce then
		self:initOnce()
	end
	if self.init then
		self:callEach("init")
	end
end

function Script:_update(dt)
	if self.updateOnce then
		self:updateOnce(dt)
	end
	if self.update then
		self:callEach("update", dt)
	end
end

function Script:_lateUpdate(dt)
	if self.lateUpdateOnce then
		self:lateUpdateOnce(dt)
	end
	if self.lateUpdate then
		self:callEach("lateUpdate", dt)
	end
end

function Script:_draw()
	if self.drawBefore then
		self:drawBefore()
	end
	if self.draw then
		self:callEach("draw")
	end
end

function Script:_drawAfter()
	if self.drawAfter then
		self:callEach("drawAfter")
	end
end

function Script:callEach(func, ...)	
	for i in pairs(self.cList) do
		self[func](self, cCore.currentScene.coisas[i], ...)
	end
end

setmetatable(Script, {__call = function(_, c, sType) return new(c, sType) end})

IScript = {}
setmetatable(IScript, {__call = function(_, c) return new(c, Script.type.interface) end})
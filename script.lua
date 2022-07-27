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

function Script:addTreco(treco)
	if treco:compare(self.requirements) then
		self.cList[treco.id] = true
		treco.scripts[self.id] = true
		if self.init then
			self:init(treco)
		end
	end
end

function Script:updateTreco(treco)
	if treco:compare(self.requirements) then
		if not self.cList[treco.id] then
			self:addTreco(treco)
		end
	else
		if self.cList[treco.id] then
			self:removeTreco(treco)
		end
	end
end

function Script:removeTreco(treco)
    -- Verifica se o script possui essa treco, se sim, retira a treco do script
    if treco:compare(self.requirements) then
        if self.onRemoval then
            self:onRemoval(treco)
        end
        self.cList[treco.id] = nil
        treco.scripts[self.id] = nil
    end
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

function Script:_keypressed(k)
	if self.keypressed then
		self:callEach("keypressed", k)
	end
end

function Script:_keyreleased(k)
	if self.keyreleased then
		self:callEach("keyreleased", k)
	end
end

function Script:_joystickpressed(j, b)
	if self.joystickpressed then
		self:callEach("joystickpressed", j, b)
	end
end

function Script:_joystickreleased(j, b)
	if self.joystickreleased then
		self:callEach("joystickreleased", j, b)
	end
end


function Script:callEach(func, ...)
	for i in pairs(self.cList) do
		self[func](self, cCore.currentScene.trecos[i], ...)
	end
end

setmetatable(Script, {__call = function(_, c, sType) return new(c, sType) end})

IScript = {}
setmetatable(IScript, {__call = function(_, c) return new(c, Script.type.interface) end})

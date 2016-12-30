local BASE = (...):match('(.-)[^%.]+$')

require("lib.color")
require("lib.vector")

require(BASE..".coisa")
require(BASE..".scene")
require(BASE..".Component")
require(BASE..".Script")

require(BASE..".components")

R = require("lib.ResourceManager")

cCore = {}

cCore.scenes = {}
cCore.currentScene = nil

cCore.scripts = {}

cCore.debugPhysics = false

local function init()
	require(BASE.."scripts.renderer")
	require(BASE.."scripts.animator")

end
function cCore.registerCoisa(coisa)
	assert(cCore.currentScene, "No scene loaded!")
	cCore.scenes[cCore.currentScene]:addCoisa(coisa)
end

function cCore.registerScript(script)
	--error("a")
	cCore.scripts[script.id] = script

end

function cCore.registerScene(scene)
	cCore.scenes[scene.name] = scene
end

function cCore.loadScene(s)
	if type(s) == "string" then
		if cCore.scenes[s] then
			cCore.currentScene = s
			cCore.scenes[s]:setScripts(cCore.scripts)
		else
			error("Invalid scene: '"..s.."'")
		end
	else
		if type(s) == "table" then
			cCore.loadScene(s.name)
			return
		else
			error("Invalid argument '"..tostring(s).."'")
		end
	end
	cCore.scenes[cCore.currentScene]:_enter()
end

function cCore.update(dt)
	if cCore.currentScene then
		cCore.scenes[cCore.currentScene]:_update(dt)
	end
end

function cCore:draw()
	if cCore.currentScene then
		cCore.scenes[cCore.currentScene]:_draw()
	end
	if cCore.debugPhysics then
		bumpdebug.draw(physics)
	end
end

function cCore:mousepressed(x,y,b)
	if cCore.currentScene and cCore.scenes[cCore.currentScene].mousepressed then
		cCore.scenes[cCore.currentScene]:mousepressed(x,y,b)
	end
end

function cCore:keypressed(k)
	if cCore.currentScene and cCore.scenes[cCore.currentScene].keypressed then
		cCore.scenes[cCore.currentScene]:keypressed(k)
	end
end

function cCore:textinput(t)
	if cCore.currentScene and cCore.scenes[cCore.currentScene].textinput then
		cCore.scenes[cCore.currentScene]:textinput(t)
	end
end

function clone(c)
	if type(c) ~= "table" then return c end
	local n = {}
	for k,v in pairs(c) do
		n[k] = clone(v)
	end
	return n
end

return init()
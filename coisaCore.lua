local BASE = (...):match('(.-)[^%.]+$')
print("BASE = ", BASE)
require("lib.color")
require("lib.vector")


require(BASE..".coisa")
require(BASE..".scene")
require(BASE..".component")
require(BASE..".script")

require(BASE..".components")

R = require("lib.resourceManager")

cCore = {}

cCore.scenes = {}
cCore.currentScene = nil

cCore.scripts = {}

local function init()

	require(BASE.."scripts.renderer")
	require(BASE.."scripts.animator")
	require(BASE.."scripts.bumpWrapper")

	require(BASE.."scripts.binder")

	Physics = BumpWrapper

end

function cCore.registerCoisa(coisa)
	assert(cCore.currentScene, "No scene loaded!")
	cCore.currentScene:addCoisa(coisa)
	cCore.callScripts("addCoisa", coisa)
end

function cCore.removeCoisa(coisa)
	cCore.currentScene:removeCoisa(coisa)
	cCore.callScripts("removeCoisa", coisa.id)
end

function cCore.registerScript(script)
	if not cCore.scripts[script.sType] then
		cCore.scripts[script.sType] = {}
	end
	cCore.scripts[script.sType][script.id] = script
end

function cCore.registerScene(scene)
	cCore.scenes[scene.name] = scene
end

function cCore.loadScene(s)
	if type(s) == "table" then
		if s.isScene then
			if cCore.currentScene then
				cCore.currentScene:_exit()
				cCore.callScripts("reset")
			end
			cCore.currentScene = s
			for k,c in pairs(s.coisas) do
				callScripts("addCoisa", c)
			end
		else
			error("Invalid scene: '"..tostring(s).."'")
		end
	else
		if type(s) == "string" then
			cCore.loadScene(cCore.scenes[s])
			return
		else
			error("Invalid argument '"..tostring(s).."'")
		end
	end
	cCore.currentScene:_enter()
end

function cCore.callScripts(func, ...)
	for k,sType in pairs(cCore.scripts) do
		for k,scr in pairs(sType) do
			scr[func](scr, ...)
		end
	end
end

function cCore.update(dt)
	if cCore.currentScene then
		cCore.currentScene:_update(dt)

		cCore.callScripts("_update", dt)
		cCore.callScripts("_lateUpdate", dt)

		cCore.currentScene:_lateUpdate(dt)
	end

end

function cCore.draw()
	if cCore.currentScene then
		cCore.currentScene:_draw()
	end

	cCore.callScripts("_draw")
end

function cCore.mousepressed(x,y,b)
	if cCore.currentScene and cCore.currentScene.mousepressed then
		cCore.currentScene:mousepressed(x,y,b)
	end
end

function cCore:keypressed(k)
	if cCore.currentScene and cCore.currentScene.keypressed then
		cCore.currentScene:keypressed(k)
	end
end

function cCore:textinput(t)
	if cCore.currentScene and cCore.currentScene.textinput then
		cCore.currentScene:textinput(t)
	end
end

function clone(c)
	if type(c) ~= "table" then return c end
	if c.isVector then return c:clone() end
	local n = {}
	for k,v in pairs(c) do
		n[k] = clone(v)
	end
	return n
end

return init()
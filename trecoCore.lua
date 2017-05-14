BASE = (...):match('(.-)[^%.]+$')
require(BASE.."lib.color")
vector = require(BASE.."lib.vector")


require(BASE..".treco")
require(BASE..".scene")
require(BASE..".component")
require(BASE..".script")

require(BASE..".components")

R = require(BASE.."lib.resourceManager")

tCore = {}

tCore.scenes = {}
tCore.currentScene = nil

tCore.scripts = {}

local function init()

	require(BASE.."scripts.renderer")
	require(BASE.."scripts.animator")
	--require(BASE.."scripts.allCollWrapper")

	require(BASE.."scripts.binder")

	Physics = acWrapper

end

function tCore.registerTreco(treco)
	assert(tCore.currentScene, "No scene loaded!")
	tCore.currentScene:addTreco(treco)
	tCore.callScripts("addTreco", treco)
end

function tCore.removeTreco(treco)
	tCore.currentScene:removeTreco(treco)
	tCore.callScripts("removeTreco", treco)
end

function tCore.registerScript(script)
	if not tCore.scripts[script.sType] then
		tCore.scripts[script.sType] = {}
	end
	tCore.scripts[script.sType][script.id] = script
end

function tCore.registerScene(scene)
	tCore.scenes[scene.name] = scene
end

function tCore.loadScene(s)
	if type(s) == "table" then
		if s.isScene then
			if tCore.currentScene then
				tCore.currentScene:_exit()
				tCore.callScripts("reset")
			end
			tCore.currentScene = s
			for k,c in pairs(s.trecos) do
				callScripts("addTreco", c)
			end
		else
			error("Invalid scene: '"..tostring(s).."'")
		end
	else
		if type(s) == "string" then
			tCore.loadScene(tCore.scenes[s])
			return
		else
			error("Invalid argument '"..tostring(s).."'")
		end
	end
	tCore.currentScene:_enter()
end

function tCore.callScripts(func, ...)
	for k,sType in pairs(tCore.scripts) do
		for k,scr in pairs(sType) do
			scr[func](scr, ...)
		end
	end
end

function tCore.update(dt)
	if tCore.currentScene then
		tCore.currentScene:_update(dt)

		tCore.callScripts("_update", dt)
		tCore.callScripts("_lateUpdate", dt)

		tCore.currentScene:_lateUpdate(dt)
	end

end

function tCore.draw()
	tCore.callScripts("_draw")

	if tCore.currentScene then
		tCore.currentScene:_draw()
	end
	-- tCore.callScripts("_drawAfter")

end

function tCore.mousepressed(x,y,b)
	if tCore.currentScene and tCore.currentScene.mousepressed then
		tCore.currentScene:mousepressed(x,y,b)
	end
end

function tCore:keypressed(k)
	tCore.callScripts("_keypressed", k)
	if tCore.currentScene and tCore.currentScene.keypressed then
		tCore.currentScene:keypressed(k)
	end
end

function tCore:keyreleased(k)
	tCore.callScripts("_keyreleased", k)
	if tCore.currentScene and tCore.currentScene.keypressed then
		tCore.currentScene:keypressed(k)
	end
end

function tCore:joystickpressed(j, b)
	tCore.callScripts("_joystickpressed", j, b)
	if tCore.currentScene and tCore.currentScene.joystickpressed then
		tCore.currentScene:joystickpressed(j, b)
	end
end

function tCore:joystickreleased(j, b)
	tCore.callScripts("_joystickreleased", j, b)
	if tCore.currentScene and tCore.currentScene.joystickreleased then
		tCore.currentScene:joystickreleased(j, b)
	end
end

function tCore:textinput(t)
	if tCore.currentScene and tCore.currentScene.textinput then
		tCore.currentScene:textinput(t)
	end
end

function clone(c)
	if type(c) ~= "table" then return c end
	local n = {}
	for k,v in pairs(c) do
		n[k] = clone(v)
	end
	return setmetatable(n, getmetatable(c))
end

return init()

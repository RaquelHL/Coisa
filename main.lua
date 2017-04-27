require("coisaCore")

function love.load()
	cCore.loadScene(R.scene.testScene)
end

function love.update(dt)
	cCore.update(dt)
end

function love.draw()
	cCore.draw()
end

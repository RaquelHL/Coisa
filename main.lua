require("coisaCore")

function love.load()
	cCore.loadScene(R.scene.pongScene)
end

function love.update(dt)
	cCore.update(dt)
end

function love.draw()
	cCore.draw()
end
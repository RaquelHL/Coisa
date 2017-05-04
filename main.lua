require("trecoCore")

function love.load()
	cCore.loadScene(R.scene.testScene)
end

function love.update(dt)
	cCore.update(dt)
end

function love.draw()
	cCore.draw()
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'escape' then
        love.event.quit()
    end
end

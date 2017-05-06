require("trecoCore")

function love.load()
	tCore.loadScene(R.scene.pongScene)

end

function love.update(dt)
	tCore.update(dt)
end

function love.draw()
	tCore.draw()
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'escape' then
        love.event.quit()
    end
end

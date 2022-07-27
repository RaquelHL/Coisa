testScene = Scene("testScene")

function testScene:init()

	love.graphics.setBackgroundColor(200, 200, 200)

	R.add("animsheet", "PixelChar")

	player = Coisa(Position(200, 140), Sprite, Animation(R.anim.idle), Player, BoxCollider)
	tile = Coisa(Position(300, 140), Scale(2, 0.5), Sprite(R.texture.tile), BoxCollider)

	--self:loadMap("level1")
end

function testScene:update(dt)
	dir = {x = 0, y = 0}
	if love.keyboard.isDown("w") then
		dir.y = -50 * dt
	end
	if love.keyboard.isDown("s") then
		dir.y = 50 * dt
	end
	if love.keyboard.isDown("a") then
		dir.x = -50 * dt
	end
	if love.keyboard.isDown("d") then
		dir.x = 50 * dt
	end

	nX, nY, cols = Physics:move(player, dir)

	player.pos.x = nX
	player.pos.y = nY
end

return testScene

testScene = Scene("testScene")

function testScene:enter()

	love.graphics.setBackgroundColor(200, 200, 200)

	R.add("animsheet", "PixelChar")

	tile = Coisa("tile", {Position({x = 200, y = 140}), Sprite, Animation({anim = R.anim.idle}), Player})
end

return testScene
testScene = Scene("testScene")

function testScene:enter()

	tile = Coisa("tile", {Position({x = 200, y = 140}), Sprite({texture = R.texture.tile}), Player})
end

return testScene
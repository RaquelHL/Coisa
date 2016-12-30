
Renderer = Script("renderer", {Position, Sprite})

function Renderer:drawEach(c)
	love.graphics.setColor(c.sprite.color:value())
	love.graphics.draw(c.sprite.texture, c.pos.x, c.pos.y)
end

Renderer = Script("renderer", {Position, Sprite})

Renderer.pivot = {
	top_left = function(w, h)
		return vector(0, 0)
	end,
	top = function(w, h)
		return vector(w/2, 0)
	end,
	top_right = function(w, h)
		return vector(w, 0)
	end,
	left = function(w, h)
		return vector(0, h/2)
	end,
	center = function(w, h)
		return vector(w/2, h/2)
	end,
	right = function(w, h)
		return vector(w, h/2)
	end,
	bottom_left = function(w, h)
		return vector(0, h)
	end,
	bottom = function(w, h)
		return vector(w/2, h)
	end,
	bottom_right = function(w, h)
		return vector(w,h)
	end
}

function Renderer:initEach(c)
	if c.sprite.texture then
		c.sprite.offset = Renderer.pivot[c.sprite.pivot](c.sprite.texture:getWidth(), c.sprite.texture:getHeight())
	end
end

function Renderer:drawEach(c)
	love.graphics.setColor(c.sprite.color:value())
	if c.sprite.texture then
		if c.sprite.quad then
			love.graphics.draw(c.sprite.texture, c.sprite.quad, c.pos.x + c.sprite.offset.x, c.pos.y + c.sprite.offset.y)
		else
			love.graphics.draw(tex, c.pos.x + c.sprite.offset.x, c.pos.y + c.sprite.offset.y)
		end
	end
end
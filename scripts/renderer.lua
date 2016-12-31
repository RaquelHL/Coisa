
Renderer = Script({Sprite})

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

function Renderer:init(c)
	if c.sprite.texture then
		local scale = c.scale or vector(1,1)
		c.sprite.offset = -Renderer.pivot[c.sprite.pivot](c.sprite.texture:getWidth() * scale.x, c.sprite.texture:getHeight() * scale.y)
	end
end

function Renderer:draw(c)
	love.graphics.setColor(c.sprite.color:value())
	if c.sprite.texture then
		local pos = c.pos or vector(0,0)
		local scale = c.scale or vector(1,1)
		if c.sprite.quad then
			love.graphics.draw(c.sprite.texture, c.sprite.quad, pos.x + c.sprite.offset.x, pos.y + c.sprite.offset.y, 0, scale.x, scale.y)
		else
			love.graphics.draw(c.sprite.texture, pos.x + c.sprite.offset.x, pos.y + c.sprite.offset.y, 0, scale.x, scale.y)
		end
	end
	love.graphics.setColor(255, 0, 255)
	--love.graphics.circle("fill", c.pos.x, c.pos.y, 3)
end
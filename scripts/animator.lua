Animator = Script({Sprite, Animation})

function Animator:initEach(c)
	if c.animation.anim then
		c.sprite.texture = c.animation.anim.texture
	end
end

function Animator:updateEach(c)
	if not c.animation.anim then
		return
	end
	if (love.timer.getTime() - c.animation.lastUpdate > c.animation.anim.timestep) then
		c.animation.curFrame = c.animation.curFrame + 1
		if (c.animation.curFrame > c.animation.anim.size) then
			if (c.animation.anim.loop) then
				c.animation.curFrame = 1
			else
				c.animation.curFrame = c.animation.anim.size
			end
		end
		c.sprite.quad = c.animation.anim.frames[c.animation.curFrame].quad
		if c.animation.anim.offset then
			c.sprite.offset = c.animation.anim.offset
			if c.collider then
				c.collider.offset = c.animation.anim.colOffset
			end
		end
		if c.collider and c.animation.anim.colBox then
			c.collider.w = c.animation.anim.colBox.w
			c.collider.h = c.animation.anim.colBox.h
			Physics:updateRect(c)
		end
		c.animation.lastUpdate  = love.timer.getTime()
	end
end
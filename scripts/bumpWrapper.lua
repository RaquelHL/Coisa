BumpWrapper = Script("bumpWrapper", {BoxCollider})

local bump = require("lib.bump")
local bumpdebug = require("lib.bump_debug")

function BumpWrapper:init()
	physics = bump.newWorld(40)

end

function BumpWrapper:initEach(c)
	local scale = c.scale or vector(1,1)
	if c.collider.w == -1 then
		if c.sprite and c.sprite.texture and not c.sprite.quad then
			c.collider.w = c.sprite.texture:getWidth() * scale.x
			c.collider.offset.x = c.sprite.offset.x
		else
			c.collider.w = 1
		end
	end
	if c.collider.h == -1 then
		if c.sprite and c.sprite.texture and not c.sprite.quad then
			c.collider.h = c.sprite.texture:getHeight() * scale.y
			c.collider.offset.y = c.sprite.offset.y
		else
			c.collider.h = 1
		end
	end
	physics:add(c, c.pos.x + c.collider.offset.x, c.pos.y + c.collider.offset.y, c.collider.w, c.collider.h)
end

function BumpWrapper:updateRect(c)
	physics:update(c, c.pos.x + c.collider.offset.x, c.pos.y + c.collider.offset.y, c.collider.w, c.collider.h)
end

function BumpWrapper:move(c, m, ...)
	m = m + c.collider.offset
	local nX, nY, cols, n = physics:move(c,m.x + c.pos.x,m.y + c.pos.y,...)
	nX = nX - c.collider.offset.x
	nY = nY - c.collider.offset.y
	return nX, nY, cols, n
end

function BumpWrapper:moveTo(c, m, ...)
	physics:update(c, m.x, m.y)
end

function BumpWrapper:draw()
	--bumpdebug.draw(physics)
end
BumpWrapper = Script("bumpWrapper", {BoxCollider})

local bump = require("lib.bump")
local bumpdebug = require("lib.bump_debug")

function BumpWrapper:init()
	print("aqui com ", self)
	physics = bump.newWorld(40)

	_move = physics.move
	function physics:move(c, x, y, ...)
		x = x + c.collider.offset.x
		y = y + c.collider.offset.y
		local nX, nY, cols, n = _move(self,c,x,y,...)
		nX = nX - c.collider.offset.x
		nY = nY - c.collider.offset.y
		return nX, nY, cols, n
	end
end

function BumpWrapper:initEach(c)
	if c.collider.w == -1 then
		if c.sprite.texture and not c.sprite.quad then
			c.collider.w = c.sprite.texture:getWidth()
			c.collider.offset.x = c.sprite.offset.x
		else
			c.collider.w = 1
		end
	end
	if c.collider.h == -1 then
		if c.sprite.texture and not c.sprite.quad then
			c.collider.h = c.sprite.texture:getHeight()
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

function BumpWrapper:draw()
	bumpdebug.draw(physics)
end
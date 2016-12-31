PlayerInput = Script("playerInput", {Position, Player, Animation, BoxCollider})

function PlayerInput:updateEach(c, dt)
	local move = vector(0,0)
	if love.keyboard.isDown("w") then
		move.y = - c.player.speed*dt
	end
	if love.keyboard.isDown("s") then
		move.y = c.player.speed*dt
	end
	if love.keyboard.isDown("a") then
		move.x = - c.player.speed*dt
	end
	if love.keyboard.isDown("d") then
		move.x = c.player.speed*dt
	end

	if move ~= vector.zero then
		c.pos.x, c.pos.y = BumpWrapper:move(c, move)--physics:move(c, c.pos.x + move.x, c.pos.y + move.y)
	end

	if love.keyboard.isDown("x") then
		c:removeComponent(Player)
	end
end
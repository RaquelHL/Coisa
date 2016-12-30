PlayerInput = Script("playerInput", {Position, Player})

function PlayerInput:updateEach(c, dt)
	if love.keyboard.isDown("w") then
		c.pos.y = c.pos.y - c.player.speed*dt
	end
	if love.keyboard.isDown("s") then
		c.pos.y = c.pos.y + c.player.speed*dt
	end
	if love.keyboard.isDown("a") then
		c.pos.x = c.pos.x - c.player.speed*dt
	end
	if love.keyboard.isDown("d") then
		c.pos.x = c.pos.x + c.player.speed*dt
	end

	if love.keyboard.isDown("x") then
		c:removeComponent(Player)
	end
end
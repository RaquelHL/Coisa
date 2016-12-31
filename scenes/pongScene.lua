pongScene = Scene("pong")

Pad = Component("pad", {speed = 250})
Player = Component("player")
IA = Component("ia")

Ball = Component("ball", {direction = vector(1,1), speed = 200})

local wSize = vector(400,600)

function pongScene:enter()
	love.window.setMode(wSize.x,wSize.y)

	ball = Coisa("ball", {
		Position({x = wSize.x/2, y = wSize.y/2}),
		Scale({x = 0.2, y = 0.2}),
		Sprite({texture = R.texture.tile}),
		BoxCollider, Ball
	})

	playerPad = Coisa("pPad", {
		Position({x = wSize.x/2, y = wSize.y-30}), 
		Scale({x = 1.5, y = 0.3}), 
		Sprite({texture = R.texture.tile, color = Color(20,20,200)}),
		BoxCollider, Pad, Player
	})

	iaPad = Coisa("iaPad", {
		Position({x = wSize.x/2, y = 30}), 
		Scale({x = 1.5, y = 0.3}), 
		Sprite({texture = R.texture.tile, color = Color(200,20,20)}),
		BoxCollider, Pad, IA
	})

	Coisa("leftWall", {
		Position({x = -5}),
		BoxCollider({w = 10, h = wSize.y})
	})
	Coisa("rightWall", {
		Position({x = wSize.x-5}),
		BoxCollider({w = 10, h = wSize.y})
	})

end

padController = Script("padController", {Pad})

function padController.move(c, m)
	m = m * c.pad.speed
	nX, nY, cols, n = Physics:move(c, m)

	c.pos = vector(nX,nY)
end

ballController = Script("ballController", {Ball})

function ballController:updateEach(c, dt)
	nX, nY, cols = Physics:move(c, c.ball.direction*c.ball.speed*dt)
	for k,v in pairs(cols) do
		if v.normal.x ~= 0 then
			c.ball.direction.x = -c.ball.direction.x
		end
		if v.normal.y ~= 0 then
			c.ball.direction.y = -c.ball.direction.y
		end
	end
	c.pos = vector(nX,nY)
	if c.pos.y < -50 or c.pos.y > wSize.y+50 then
		c.pos = vector(wSize.x/2, wSize.y/2)
		Physics:moveTo(c, c.pos)
	end
end

playerInput = Script("playerInput", {Pad, Player})

function playerInput:updateEach(c, dt)
	local move = vector(0,0)
	if love.keyboard.isDown("a") then
		move = vector(-dt,0)
	end
	if love.keyboard.isDown("d") then
		move = vector(dt,0)
	end
	padController.move(c, move)
end

iaInput = Script("IAInput", {Pad, IA})

function iaInput:updateEach(c, dt)
	local move = nil
	if ball.pos.x > c.pos.x then
		move = vector(dt*0.5,0)
	else
		move = vector(-dt*0.5,0)
	end
	padController.move(c,move)
end

return pongScene
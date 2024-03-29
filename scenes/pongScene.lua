pongScene = Scene("pong")

Pad = Component("pad", {speed = 250})
Player = Component("player")
IA = Component("ia")

Ball = Component("ball", {direction = vector(1,1), speed = 200})

local wSize = vector(400,600)

function pongScene:init()
	love.window.setMode(wSize.x,wSize.y)
	love.graphics.setBackgroundColor(200, 200, 255)

	ball = Coisa(
		Position(wSize.x/2, wSize.y/2),
		Scale(0.2, 0.2),
		Sprite(R.texture.tile),
		BoxCollider, Ball)

	playerPad = Coisa(
		Position(wSize.x/2, wSize.y-30),
		Scale(1.5, 0.3),
		Sprite(R.texture.tile, Color(20,20,200)),
		BoxCollider, Pad, Player)

	iaPad = Coisa(
		Position(wSize.x/2, 30),
		Scale(1.5, 0.3),
		Sprite(R.texture.tile, Color(200,20,20)),
		BoxCollider, Pad, IA)

	--Left wall
	Coisa(
		Position(10),
		BoxCollider(10, wSize.y))

	--Right wall
	Coisa(
		Position(wSize.x),
		BoxCollider(10, wSize.y))

end

padController = Script({Pad})

function padController:init(c)
	--[[Conceito de funções nos componentes:
		Por design, componentes só guardam informação, sem lógica.
		Mas, teoricamente, a lógica aqui continua no sistema, o componente só guarda
		uma referência pra uma função no sistema
	]]
	c.pad.move = function(_,m) padController.move(c,m) end
end

function padController.move(c, m)
	m = m * c.pad.speed
	nX, nY, cols, n = Physics:move(c, m)

	c.pos = vector(nX,nY)
end

ballController = Script({Ball})

function ballController:update(c, dt)
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
	c.pos:floor()
	if c.pos.y < -50 or c.pos.y > wSize.y+50 then
		c.pos = vector(wSize.x/2, wSize.y/2)
		Physics:moveTo(c, c.pos)
	end
end

playerInput = Script({Pad, Player})

function playerInput:update(c, dt)
	local m = vector(0,0)
	if love.keyboard.isDown("a") then
		m = vector(-dt,0)
	end
	if love.keyboard.isDown("d") then
		m = vector(dt,0)
	end	
	c.pad:move(m)
end

iaInput = Script({Pad, IA})

function iaInput:update(c, dt)
	local m = nil
	if ball.pos.x > c.pos.x then
		m = vector(dt*0.5,0)
	else
		m = vector(-dt*0.5,0)
	end
	c.pad:move(m)
end

return pongScene
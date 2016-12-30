Sprite = Component("sprite", {
	texture = 0,	--É necessário que o campo texture exista, então é preciso atribuir um valor qualquer
	color = Color(255,255,255),
	offset = vector(0,0)	
})

Position = Component("pos", vector(0,0))

Player = Component("player", {speed = 40})

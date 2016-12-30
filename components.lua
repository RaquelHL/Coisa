
Position = Component("pos", vector(0,0))

Sprite = Component("sprite", {
	texture = false,	--É necessário que o campo texture exista, então é preciso atribuir um valor qualquer
	quad = false,
	color = Color(255,255,255),
	offset = vector(0,0),
	pivot = "center",
	mirror = false
})

Animation = Component("animation", {
	anim = false,
	lastUpdate = 0,
	curFrame = 1
})

Player = Component("player", {speed = 40})

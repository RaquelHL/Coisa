
Position = Component("pos", vector(0,0))

Scale = Component("scale", vector(1,1))

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

BoxCollider = Component("collider",{
	w = -1,
	h = -1, 
	offset = vector(0,0)
})

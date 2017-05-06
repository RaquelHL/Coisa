
Position = Component("pos", vector(0,0), 
	function(x,y)
		return {x = x, y = y}
	end)

Scale = Component("scale", vector(1,1),
	function(x,y)
		return {x = x, y = y}
	end)

Rotation = Component("rot", {r = 0},
	function(r)
		return({r = r})
	end)

Sprite = Component("sprite", {
		texture = false,	--É necessário que o campo texture exista, então é preciso atribuir um valor qualquer
		quad = false,
		color = Color(255,255,255),
		offset = vector(0,0),
		pivot = "center",
		mirror = false
	}, function(texture, color)
		return {texture = texture, color = color}
	end)

Animation = Component("animation", {
		anim = false,
		lastUpdate = 0,
		curFrame = 1
	}, 
	function(anim)
		return {anim = anim}
	end)

BoxCollider = Component("collider",{
	w = -1,
	h = -1, 
	offset = vector(0,0)
}, function(w,h,offset)
	return {w = w, h = h, offset = offset}
end)

Bind = Component("bind", {
	other = false,
	localPos = vector(0,0)
})
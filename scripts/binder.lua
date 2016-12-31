Binder = Script({Bind})
Binder.name = "binder"

function Binder:init(c)
	c.bind.localPos = c.pos:clone()
end

function Binder:lateUpdate(c, dt)
	c.pos = c.bind.other.pos + c.bind.localPos
end
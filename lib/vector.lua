local vector = {}
vector.__index = vector

local function new(x, y)
	return setmetatable({x = x or 0, y = y or 0}, vector)
end

function vector.clone(v)
	return new(v.x, v.y)
end

function vector.add(a, b)
	a.x = a.x + b.x
	a.y = a.y + b.y
end

function vector.sub(a, b)
	a.x = a.x - b.x
	a.y = a.y - b.y
end

function vector.mul(a, b)
	if (type(b) == "number") then
		a.x = a.x*b
		a.y = a.y*b
	else	
		a.x = a.x*b.x
		a.y = a.y*b.y
	end
end

function vector.div(a,b)
	a.x = a.x / b
	a.y = a.y / b
end

function vector.unm(a)
	a.x = -a.x
	a.y = -a.y
end

function vector.__unm(a)
	local b = clone(a)
	vector.unm(b)
	return b
end

function vector.__add(a,b)
	local c = clone(a)
	vector.add(c,b)
	return c
end

function vector.__sub(a,b)
	local c = clone(a)
	vector.sub(c,b)
	return c
end

function vector.__mul(a,b)
	local c = clone(a)
	vector.mul(c,b)
	return c
end

function vector.__div(a,b)
	local c = clone(a)
	vector.div(c,b)
	return c
end

function vector.__eq(a,b)
	return a.x == b.x and a.y == b.y
end

function vector.__tostring(a)
	return "["..a.x..","..a.y.."]"
end

function vector.rotate(v, o)
	local cos, sin = math.cos(o), math.sin(o)
	v.x = cos * v.x - sin * v.y
	v.y = sin * v.x + cos * v.y
	return v
end

function vector.magnitude(v)
	return vector.dist(vector.zero, v)
end

function vector.dist2(a,b)
	return math.pow(a.x-b.x,2)+math.pow(a.y-b.y,2)
end

function vector.dist(a,b)
	return math.sqrt(vector.dist2(a,b))
end

function vector.fromAngle(r)
	return new(math.cos(r),math.sin(r))
end

function vector.angleTo(a, b)
	return math.atan2(b.y-a.y, b.x-a.x)
end

function vector.floor(a)
	a.x = math.floor(a.x)
	a.y = math.floor(a.y)
	return a
end

function vector.isVector(v)
	return v.x and v.y;
end

--Constantes
vector.zero = new(0,0)
vector.forward = new(1,0)
vector.back = new(-1,0)

vector.up = new(0,-1)
vector.right = new(1,0)
vector.down = new(0,1)
vector.left = new(-1,0)

setmetatable(vector, {__call = function(_, ...) return new(...) end})
return vector
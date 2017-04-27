local bump = require(BASE..'lib.bump')

local bump_debug = {}

local function getCellRect(world, cx,cy)
  local cellSize = world.cellSize
  local l,t = world:toWorld(cx,cy)
  return l,t,cellSize,cellSize
end

function bump_debug.draw(world)
  --[[local cellSize = world.cellSize
  local font = love.graphics.getFont()
  local fontHeight = font:getHeight()
  local topOffset = (cellSize - fontHeight) / 2
  for cy, row in pairs(world.rows) do
    for cx, cell in pairs(row) do
      local l,t,w,h = getCellRect(world, cx,cy)
      local intensity = cell.itemCount * 12 + 16
      love.graphics.setColor(255,255,255,intensity)
      love.graphics.rectangle('fill', l,t,w,h)
      love.graphics.setColor(255,255,255, 64)
      love.graphics.printf(cell.itemCount, l, t+topOffset, cellSize, 'center')
      love.graphics.setColor(255,255,255,10)
      love.graphics.rectangle('line', l,t,w,h)
    end
  end]]

  local items = world:getItems()
  for k,v in pairs(items) do
    if(v.collider.isSlope) then
      love.graphics.setColor(255, 0, 255, 255)
      local x, y, w, h = world:getRect(v)

      love.graphics.line(x, y+((1-v.collider.leftY)*h), x+w, y+((1-v.collider.rightY)*h))
    end
    love.graphics.setColor(255, 255, 0, 255)
    love.graphics.rectangle("line", world:getRect(v))

  end
end

return bump_debug

Hitbox = Class {}

function Hitbox:init(params)
  self.x = params.x
  self.y = params.y
  self.width = params.width
  self.height = params.height
end

function Hitbox:update(x, y)
  self.x = x
  self.y = y
end

function Hitbox:render()
  if gDebug == true then
    love.graphics.rectangle(
      'line',
      self.x,
      self.y,
      self.width,
      self.height
    )
  end
end

function Hitbox:collides(other)
  if
    self.x > other.x + other.width - 1 or other.x > self.x + self.width - 1
   then
    return false
  end

  if
    self.y > other.y + other.height - 1 or
      other.y > self.y + self.height - 1
   then
    return false
  end

  return true
end

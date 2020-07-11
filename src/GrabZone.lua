GrabZone = Class {}

function GrabZone:init(params)
  self.x = params.x
  self.y = params.y
  self.playerWidth = params.playerWidth
  self.playerHeight = params.playerHeight
  self.width = 150
  self.height = self.width
end

function GrabZone:update(dt, x, y, balls)
  -- Align x and y to upper left corner for collision detection
  self.x = x - self.width / 2
  self.y = y - self.playerHeight / 2

  local newShootable = false
  for _, ball in ipairs(balls) do
    if self:collides(ball) then
      self.shootable = ball
      newShootable = true
    end
  end

  if not newShootable then
    self.shootable = nil
    return
  end

  if love.mouse.isDown(1) and self.shootable then
  -- change to shooting state
  end
end

function GrabZone:render()
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

function GrabZone:collides(other)
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

BallSpawner = Class {}

function BallSpawner:init()
  self.timer = 5
  self.margin = 50
  self.x = self.margin
  self.y = self.margin
  self.width = love.graphics.getWidth() - self.margin * 2
  self.height = love.graphics.getHeight() - self.margin * 2
end

function BallSpawner:update(dt)
  if self.timer <= 0 then
    self.timer = 5
    self:spawn()
  end

  self.timer = self.timer - dt
end

function BallSpawner:render()
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

function BallSpawner:spawn()
  local randomX, randomY = self:getBallCoords()

  Signal.emit(
    'new_ball',
    {
      x = randomX,
      y = randomY
    }
  )
end

function BallSpawner:getBallCoords()
  -- todo: randomize within bounds
  return 100, 100
end

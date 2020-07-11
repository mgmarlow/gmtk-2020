BallSpawner = Class {}

function BallSpawner:init()
  self.timer = 10
  self.margin = 50
  self.x = self.margin
  self.y = self.margin
  self.width = love.graphics.getWidth() - self.margin * 2
  self.height = love.graphics.getHeight() - self.margin * 2

  self.spawnSound = love.audio.newSource('sound/spawn.wav', 'static')
end

function BallSpawner:update(dt)
  if self.timer <= 0 then
    self.timer = 10
    self:spawn()
  end

  self.timer = self.timer - dt
end

function BallSpawner:render()
  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf(
    'New ball in: ' .. string.format('%.1f', self.timer),
    0,
    0,
    love.graphics.getWidth()
  )

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
  self.spawnSound:play()

  local x, y = self:getBallCoords()
  Signal.emit(
    'new_ball',
    {
      x = x,
      y = y
    }
  )
end

function BallSpawner:getBallCoords()
  local randomX = math.random(self.x + self.width)
  local randomY = math.random(self.y + self.height)

  return randomX, randomY
end

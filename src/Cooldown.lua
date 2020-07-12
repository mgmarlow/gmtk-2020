Cooldown = Class {}

function Cooldown:init(params)
  self.x = params.x
  self.y = params.y
  self.max = 50
  self.fill = 0
  self.active = false
end

function Cooldown:update(dt, x, y, isRunning)
  local rate = 1
  if isRunning then
    rate = 20
  else
    rate = 1
  end

  self.x = x
  self.y = y

  if self.fill > 0 then
    self.active = true
    self.fill = self.fill - rate * dt
  end

  if self.fill <= 0 then
    self.active = false
  end
end

function Cooldown:render()
  if self.active then
    love.graphics.rectangle(
      'fill',
      self.x + 40,
      self.y - 60,
      self.fill,
      10
    )
  end
end

Ball = Class {}

function Ball:init(params)
  self.x = params.x
  self.y = params.y
  self.width = 10
  self.height = 10
  self.dir = nil
  self.kind = 'shootable'
  self.velocity = 300
end

function Ball:update(dt)
  self:checkWorldBounds()

  if self.dir ~= nil then
    self.x = self.x + math.cos(self.dir) * dt * self.velocity
    self.y = self.y + math.sin(self.dir) * dt * self.velocity
  end
end

function Ball:render(dt)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Ball:fire(angle)
  self.dir = angle
end

function Ball:checkWorldBounds()
  if self.x + self.width >= love.graphics.getWidth() then
    self.dir = -self.dir + math.pi
  end

  if self.x <= 0 then
    self.dir = -self.dir + math.pi
  end

  if self.y <= 0 then
    self.dir = -self.dir
  end

  if self.y + self.height >= love.graphics.getHeight() then
    self.dir = -self.dir
  end
end

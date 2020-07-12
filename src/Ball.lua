Ball = Class {}

local TOP_VELOCITY = 400

function Ball:init(params)
  self.x = params.x
  self.y = params.y
  self.faction = params.faction or 'player_ball'
  self.width = 10
  self.height = 10
  self.dir = params.dir or nil
  self.kind = 'shootable'
  self.velocity = TOP_VELOCITY
  self.grabbed = false

  self.bounceSound = love.audio.newSource('sound/bump.wav', 'static')
end

function Ball:update(dt, player)
  if player.actionMachine:isActive('shoot') then
    self.velocity = 50
  else
    self.velocity = 400
  end

  if self.dir ~= nil then
    self:checkWorldBounds()
    self.x = self.x + math.cos(self.dir) * dt * self.velocity
    self.y = self.y + math.sin(self.dir) * dt * self.velocity
  end

  -- holy conditional
  if
    player:collides(self) and not self.grabbed and not player.invincible and
      self.dir
   then
    Signal.emit('player_hit')
  end
end

function Ball:render(dt)
  if self.faction == 'enemy_ball' then
    love.graphics.setColor(1, 0, 0, 1)
  else
    love.graphics.setColor(1, 1, 1, 1)
  end

  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
  love.graphics.setColor(1, 1, 1, 1)
end

function Ball:fire(angle)
  self.dir = angle
end

function Ball:checkWorldBounds()
  local bounced = false

  if self.x + self.width >= love.graphics.getWidth() - 1 then
    bounced = true
    self.x = love.graphics.getWidth() - 1 - self.width
    self.dir = -self.dir + math.pi
  end

  if self.x <= 1 then
    bounced = true
    self.x = 1 + self.width
    self.dir = -self.dir + math.pi
  end

  if self.y <= 1 then
    bounced = true
    self.y = 1 + self.height
    self.dir = -self.dir
  end

  if self.y + self.height >= love.graphics.getHeight() - 1 then
    bounced = true
    self.y = love.graphics.getHeight() - 1 - self.height
    self.dir = -self.dir
  end

  if bounced then
    self.bounceSound:play()
  end
end

function Ball:resetVelocity()
  self.velocity = TOP_VELOCITY
end

function Ball:collides(other)
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

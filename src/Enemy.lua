-- This class was copy-pasted last minute. It should be
-- rewritten from scratch to pull common code from the player
-- class (entites from data).
Enemy = Class {}

local SHOOT_TIMER = 4
local MOVEMENT_TIMER = 3

local animations = {
  ['running'] = Animation {
    frames = {25, 26, 27},
    interval = 0.3,
    loop = true
  }
}

function Enemy:init(params)
  self.x = params.x
  self.y = params.y
  self.dead = false
  self.movementChangeOriginal = love.math.random(2, 6)
  self.movementChangeTimer = self.movementChangeOriginal
  self.shootTimer = SHOOT_TIMER
  self.width = 96
  self.height = 128
  self.speed = 250
  self.rightFacing = false
  self.quadIndex = 1
  self.currentAnimation = nil
  self.invincible = false
  self.quads = generateQuads(gTextures.enemysheet, self.width, self.height)

  self.hitSound = love.audio.newSource('sound/enemy_hit.wav', 'static')
  self.deadSound = love.audio.newSource('sound/enemy_dead.wav', 'static')

  self.dir = {x = love.math.random(), y = love.math.random()}

  self.lifecounter =
    LifeCounter {
    x = self.x,
    y = self.y,
    width = self.width,
    lives = 4
  }

  self.hitbox =
    Hitbox {
    x = self.x - self.width / 4,
    y = self.y - self.height / 4,
    width = self.width / 2 + 20,
    height = self.height / 1.5
  }

  local onHit = function(params)
    if params.enemy == self then
      self.hitSound:play()
      self.lifecounter:decrement()

      if self.lifecounter:isDead() then
        self.dead = true
        self.deadSound:play()
      end

      self.invincible = true

      Timer.after(
        2,
        function()
          self.invincible = false
        end
      )
    end
  end

  Signal.register('enemy_hit', onHit)
end

function Enemy:exit()
  Signal.clear('enemy_hit')
end

function Enemy:update(dt, player)
  if self.dead then
    return
  end

  self.currentAnimation = self.currentAnimation or animations.running
  self.currentAnimation:update(dt)

  if
    player.stateMachine:isActive('run') and
      player.actionMachine:isActive('shoot')
   then
    self.speed = 250 / 4
    self.currentAnimation.interval = 0.7
  elseif player.stateMachine:isActive('run') then
    self.speed = 250
    self.currentAnimation.interval = 0.3
  else
    self.speed = 10
    self.currentAnimation.interval = 1
  end

  if self.movementChangeTimer <= 0 then
    self.movementChangeTimer = self.movementChangeOriginal
    self.dir = {x = love.math.random(), y = love.math.random()}
  end
  self.movementChangeTimer = self.movementChangeTimer - dt

  if self.shootTimer <= 0 then
    self.shootTimer = SHOOT_TIMER

    Signal.emit(
      'new_ball',
      {
        x = self.x,
        y = self.y,
        faction = 'enemy_ball',
        dir = self:getAngle(player.x, player.y) -- todo
      }
    )
  end
  self.shootTimer = self.shootTimer - dt

  self:checkWorldBounds()

  self.hitbox:update(
    self.x - self.width / 3,
    self.y + 10 - self.height / 4
  )

  self.quadIndex =
    self.currentAnimation == nil and 1 or
    self.currentAnimation:getCurrentFrame()

  self.lifecounter:update(self.x, self.y)

  -- Prevent movement when hit
  if self.invincible then
    return
  end

  local normalLength = math.sqrt(self.dir.x ^ 2 + self.dir.y ^ 2)

  local normX = (self.dir.x / normalLength) * dt
  local normY = (self.dir.y / normalLength) * dt

  self.x = self.x + normX * self.speed
  self.y = self.y + normY * self.speed
end

function Enemy:render()
  if self.dead then
    return
  end

  self.hitbox:render()
  self.lifecounter:render()

  love.graphics.draw(
    gTextures.enemysheet,
    self.quads[self.quadIndex],
    self.x,
    self.y,
    0,
    self.rightFacing and 1 or -1,
    1,
    self.width / 2,
    self.height / 2
  )
end

function Enemy:checkWorldBounds()
  local bounced = false

  if self.hitbox.x + self.hitbox.width >= love.graphics.getWidth() - 1 then
    bounced = true
    self.x = self.x - 10
  end

  if self.hitbox.x <= 1 then
    bounced = true
    self.x = self.x + 10
  end

  if self.hitbox.y <= 1 then
    bounced = true
    self.y = self.y + 10
  end

  if self.hitbox.y + self.hitbox.height >= love.graphics.getHeight() - 1 then
    bounced = true
    self.y = self.y - 10
  end

  if bounced == true then
    self.dir = {x = self.dir.x * -1, y = self.dir.x * -1}
  end
end

function Enemy:getAngle(destX, destY)
  return math.atan2(destY - self.y, destX - self.x)
end

function Enemy:collides(other)
  return self.hitbox:collides(other)
end

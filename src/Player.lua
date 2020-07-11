Player = Class {}

function Player:init()
  self.width = 96
  self.height = 128
  self.speed = 250
  self.x = love.graphics.getWidth() / 2
  self.y = love.graphics.getHeight() / 2
  self.hitboxX = self.x - self.width / 4
  self.hitboxY = self.y - self.height / 4
  self.hitboxWidth = self.width / 2
  self.hitboxHeight = self.height / 1.5
  self.invincible = false

  self.quadIndex = 1
  self.currentAnimation = nil

  self.quads =
    generateQuads(gTextures.playersheet, self.width, self.height)

  self.cooldown =
    Cooldown {
    x = self.x,
    y = self.y
  }

  self.grabzone =
    GrabZone {
    x = self.x,
    y = self.y,
    playerWidth = self.width,
    playerHeight = self.height
  }

  self.origCameraX, self.origCameraY = gCamera:position()

  self.stateMachine =
    StateMachine {
    ['idle'] = function()
      return PlayerIdleState({player = self})
    end,
    ['run'] = function()
      return PlayerRunState({player = self})
    end
  }

  -- Keep actions separate so a player can move and shoot simultaneously
  self.actionMachine =
    StateMachine {
    ['idle'] = function()
      return BaseState {}
    end,
    ['shoot'] = function()
      return PlayerShootingState({player = self})
    end
  }

  self.stateMachine:change('idle')
  self.actionMachine:change('idle')

  local onHit = function()
    self.invincible = true
    self.shaken = true

    Timer.after(
      1,
      function()
        self.invincible = false
        self.shaken = false
        gCamera:lookAt(self.origCameraX, self.origCameraY)
      end
    )
  end

  Signal.register('player_hit', onHit)
end

function Player:exit()
  Signal.clear('player_hit')
  gCamera:lookAt(self.origCameraX, self.origCameraY)
end

function Player:update(dt, balls)
  if
    love.mouse.isDown(1) and self.grabzone.shootable ~= nil and
      not self.cooldown.active
   then
    self.actionMachine:change(
      'shoot',
      {shootable = self.grabzone.shootable}
    )
  end

  if self.currentAnimation ~= nil then
    self.currentAnimation:update(dt)
  end

  if self.shaken then
    local min = -4
    local max = 4

    gCamera:lookAt(
      self.origCameraX + math.random(min, max),
      self.origCameraY + math.random(min, max)
    )
  end

  self.quadIndex =
    self.currentAnimation == nil and 1 or
    self.currentAnimation:getCurrentFrame()

  self.cooldown:update(dt, self.x, self.y)
  self.grabzone:update(dt, self.x, self.y, balls)
  self.stateMachine:update(dt)
  self.actionMachine:update(dt)

  self.hitboxX = self.x - self.width / 4
  self.hitboxY = self.y + 10 - self.height / 4
end

function Player:render()
  self.cooldown:render()
  self.grabzone:render()
  self.stateMachine:render()
  self.actionMachine:render()

  if gDebug == true then
    love.graphics.rectangle(
      'line',
      self.hitboxX,
      self.hitboxY,
      self.width / 2,
      self.height / 1.5
    )
  end
end

function Player:collides(other)
  if
    self.hitboxX > other.x + other.width - 1 or
      other.x > self.hitboxX + self.hitboxWidth - 1
   then
    return false
  end

  if
    self.hitboxY > other.y + other.height - 1 or
      other.y > self.hitboxY + self.hitboxHeight - 1
   then
    return false
  end

  return true
end

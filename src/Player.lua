Player = Class {}

function Player:init()
  self.width = 96
  self.height = 128
  self.speed = 250
  self.x = love.graphics.getWidth() / 2
  self.y = love.graphics.getHeight() / 2

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
end

function Player:update(dt, balls)
  for _, ball in ipairs(balls) do
    if self.actionMachine:isActive('shoot') then
      if self.stateMachine:isActive('run') then
        ball.movable = true
      else
        ball.movable = false
      end
    else
      ball.movable = true
      -- TODO: Need invincibility for a few seconds after shooting
      -- to avoid instantly dying when releasing the ball while over it
      if ball:collides(self) then
        print('oh shit, he ded')
        return
      end
    end
  end

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

  self.quadIndex =
    self.currentAnimation == nil and 1 or
    self.currentAnimation:getCurrentFrame()

  self.cooldown:update(dt, self.x, self.y)
  self.grabzone:update(dt, self.x, self.y, balls)
  self.stateMachine:update(dt)
  self.actionMachine:update(dt)
end

function Player:render()
  self.cooldown:render()
  self.grabzone:render()
  self.stateMachine:render()
  self.actionMachine:render()
end
